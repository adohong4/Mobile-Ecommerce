import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/models/addressModel.dart';
import 'package:mobile_app/models/order_model.dart';
import 'package:mobile_app/models/voucher_model.dart';
import 'package:mobile_app/pages/ShippingAddressPage.dart';
import 'package:mobile_app/pages/voucher_select.dart';
import 'package:mobile_app/pages/HomePage.dart'; // Import HomePage
import 'package:mobile_app/providers/voucher_provider.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/address_service.dart';
import 'package:mobile_app/services/payment_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:url_launcher/url_launcher.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final int total;

  const CheckoutPage({
    Key? key,
    required this.selectedItems,
    required this.total,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPaymentMethod = 'cod';
  AddressModel? defaultAddress;
  bool isLoadingAddress = true;
  bool isProcessingPayment = false;
  String? addressError;

  final AddressService _addressService = AddressService();
  final PaymentService _paymentService = PaymentService();
  final NumberFormat currencyFormatter = NumberFormat('#,###', 'vi_VN');

  List<Map<String, dynamic>> get paymentMethods => [
    {
      'id': 'cod',
      'label': 'Thanh toán khi giao hàng',
      'icon_type': 'text',
      'icon_text': 'COD',
      'icon_color': Colors.green,
    },
    {
      'id': 'stripe',
      'label': 'Thanh toán Stripe',
      'icon_type': 'image',
      'icon_asset': 'assets/stripe.png',
      'icon_color': const Color.fromARGB(255, 70, 6, 112),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchDefaultAddress();
  }

  Future<void> _fetchDefaultAddress() async {
    setState(() {
      isLoadingAddress = true;
      addressError = null;
    });
    final result = await _addressService.getAddresses();
    if (result['success']) {
      final addresses = result['addresses'] as List<AddressModel>;
      setState(() {
        defaultAddress = addresses.firstWhere((address) => address.active);
        isLoadingAddress = false;
      });
    } else {
      setState(() {
        addressError = result['message'];
        isLoadingAddress = false;
      });
    }
  }

  String formatCurrency(double price) {
    return "${currencyFormatter.format(price)} đ";
  }

  double calculateSubtotal() {
    return widget.selectedItems.fold(0.0, (sum, item) {
      final price = item['price'] as double;
      final quantity = item['quantity'] as int;
      return sum + price * quantity;
    });
  }

  double calculateDiscount(VoucherModel? selectedVoucher, double subtotal) {
    if (selectedVoucher == null) return 0.0;
    if (selectedVoucher.discountType == 'FIXED_AMOUNT') {
      return selectedVoucher.discountValue;
    } else if (selectedVoucher.discountType == 'PERCENTAGE') {
      final discount = subtotal * selectedVoucher.discountValue / 100;
      return discount > selectedVoucher.maxDiscountAmount
          ? selectedVoucher.maxDiscountAmount
          : discount;
    }
    return 0.0;
  }

  Future<void> _placeOrder() async {
    if (defaultAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn địa chỉ giao hàng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isProcessingPayment = true);

    try {
      final subtotal = calculateSubtotal();
      final voucherProvider = Provider.of<VoucherProvider>(
        context,
        listen: false,
      );
      final selectedVoucher = voucherProvider.selectedVoucher;
      final discount = calculateDiscount(selectedVoucher, subtotal);
      final totalAfterDiscount = subtotal - discount;

      final order = Order(
        items:
            widget.selectedItems
                .map(
                  (item) => OrderItem(
                    id: item['id'] as String,
                    quantity: item['quantity'] as int,
                    price: item['price'] as double,
                  ),
                )
                .toList(),
        amount: totalAfterDiscount,
        address: Address(
          fullname: defaultAddress!.fullname ?? '',
          street: defaultAddress!.street ?? '',
          precinct: defaultAddress!.precinct,
          city: defaultAddress!.city ?? '',
          province: defaultAddress!.province ?? '',
        ),
        date: DateTime.now().toLocal().toString(),
        paymentMethod: selectedPaymentMethod == 'cod' ? 'cod' : 'online',
        status: 'pending',
        payment: selectedPaymentMethod == 'stripe',
      );

      if (selectedPaymentMethod == 'cod') {
        final response = await _paymentService.placeCODOrder(order);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Đặt hàng COD thành công'),
          ),
        );
        // Chuyển về HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else if (selectedPaymentMethod == 'stripe') {
        final stripeResponse = await _paymentService.placeStripeOrder(order);
        final orderId = stripeResponse['orderId'];
        if (kIsWeb) {
          // Web: Chuyển hướng đến Stripe Checkout
          final sessionUrl = stripeResponse['sessionUrl'];
          final uri = Uri.parse(sessionUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã mở Stripe để thanh toán')),
            );
            // VerifyPage sẽ xử lý chuyển hướng về HomePage
          } else {
            throw Exception('Không thể mở Stripe Checkout');
          }
        } else {
          // Mobile: Sử dụng PaymentSheet
          final clientSecret = stripeResponse['clientSecret'];
          await stripe.Stripe.instance.initPaymentSheet(
            paymentSheetParameters: stripe.SetupPaymentSheetParameters(
              paymentIntentClientSecret: clientSecret,
              merchantDisplayName: 'HOAPHAT',
            ),
          );
          await stripe.Stripe.instance.presentPaymentSheet();
          await _paymentService.verifyStripeOrder(orderId, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanh toán Stripe thành công')),
          );
          // Chuyển về HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isProcessingPayment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final voucherProvider = Provider.of<VoucherProvider>(context);
    final selectedVoucher = voucherProvider.selectedVoucher;
    final subtotal = calculateSubtotal();
    final discount = calculateDiscount(selectedVoucher, subtotal);
    final totalAfterDiscount = subtotal - discount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("THANH TOÁN", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoadingAddress
                      ? const Center(child: CircularProgressIndicator())
                      : addressError != null
                      ? Text(
                        addressError!,
                        style: const TextStyle(color: Colors.red),
                      )
                      : defaultAddress == null
                      ? const Center(
                        child: Text(
                          'Chưa có địa chỉ. Vui lòng thêm địa chỉ.',
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF003366),
                            size: 30,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  defaultAddress!.fullname != null &&
                                          defaultAddress!.phone != null
                                      ? '${defaultAddress!.fullname} (+84)${defaultAddress!.phone}'
                                      : 'Không có thông tin liên hệ',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  defaultAddress!.street ?? 'Chưa cập nhật',
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                ),
                                Text(
                                  [
                                    defaultAddress!.precinct,
                                    defaultAddress!.city,
                                    defaultAddress!.province,
                                  ].where((e) => e != null).join(', '),
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF003366),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ShippingAddressPage(),
                                ),
                              ).then((_) => _fetchDefaultAddress());
                            },
                          ),
                        ],
                      ),
                  const SizedBox(height: 20),
                  ...widget.selectedItems.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            item['image'].startsWith('http')
                                ? item['image']
                                : '${ApiService.imageBaseUrl}${item['image']}',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Image.asset(
                                  'assets/asus.png',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Số lượng: ${item['quantity']}',
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                ),
                                Text(
                                  formatCurrency(item['price'] as double),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF003366),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      final selectedVoucher = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VoucherSelectPage(),
                        ),
                      );
                      if (selectedVoucher != null) {
                        await Provider.of<VoucherProvider>(
                          context,
                          listen: false,
                        ).fetchVoucherById(selectedVoucher.id);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.discount, color: Color(0xFF003366)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              selectedVoucher != null
                                  ? 'Giảm giá từ cửa hàng ${formatCurrency(discount)}'
                                  : 'Chọn voucher giảm giá',
                              style: const TextStyle(fontFamily: 'Poppins'),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF003366),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng phụ',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            Text(
                              formatCurrency(subtotal),
                              style: const TextStyle(fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Vận chuyển',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            const Text(
                              'Miễn phí',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Giảm giá',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            Text(
                              selectedVoucher != null
                                  ? '-${formatCurrency(discount)}'
                                  : '0 đ',
                              style: const TextStyle(fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatCurrency(totalAfterDiscount),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003366),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phương thức thanh toán',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...paymentMethods.map((method) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = method['id'].toString();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      if (method['icon_type'] == 'text')
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                method['icon_color'] as Color,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            method['icon_text'] as String,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      else if (method['icon_type'] == 'image' &&
                                          method['icon_asset'] != null)
                                        Image.asset(
                                          method['icon_asset'] as String,
                                          height: 24,
                                        ),
                                      const SizedBox(width: 12),
                                      Text(
                                        method['label'] as String,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Radio<String>(
                                    value: method['id'].toString(),
                                    groupValue: selectedPaymentMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPaymentMethod =
                                            value.toString();
                                      });
                                    },
                                    activeColor: const Color(0xFFE91E63),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng (${widget.selectedItems.length} sản phẩm)',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatCurrency(totalAfterDiscount),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: isProcessingPayment ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  child:
                      isProcessingPayment
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'ĐẶT HÀNG',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
