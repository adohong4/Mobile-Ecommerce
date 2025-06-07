import 'package:flutter/material.dart';
import 'package:mobile_app/pages/HomePage.dart';
import 'package:mobile_app/pages/CheckoutPage.dart';
import 'package:mobile_app/providers/cart_provider.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Map<String, bool> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).fetchCart();
    });
  }

  String formatCurrency(double price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return "${formatter.format(price)} đ";
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    // Khởi tạo trạng thái chọn cho các sản phẩm
    for (var item in cartProvider.cartItems) {
      _selectedItems.putIfAbsent(item.id, () => true);
    }

    // Lấy danh sách sản phẩm được chọn
    final List<ProductsModel> selectedItems =
        cartProvider.cartItems
            .where((item) => _selectedItems[item.id] == true)
            .toList();

    // Tính toán tổng giá và giảm giá
    final double total = selectedItems.fold(
      0.0,
      (sum, item) =>
          sum + item.displayPrice * (cartProvider.cartData[item.id] ?? 1),
    );
    final double discount = selectedItems.fold(
      0.0,
      (sum, item) =>
          sum +
          (item.hasDiscount
              ? (item.price - item.displayPrice) *
                  (cartProvider.cartData[item.id] ?? 1)
              : 0.0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Giỏ hàng (${cartProvider.cartItems.length})',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body:
          cartProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : cartProvider.errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cartProvider.errorMessage!),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => cartProvider.fetchCart(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
              : cartProvider.cartItems.isEmpty
              ? const Center(child: Text('Giỏ hàng trống'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartProvider.cartItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = cartProvider.cartItems[index];
                        final quantity = cartProvider.cartData[item.id] ?? 1;
                        return ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedItems[item.id] =
                                    !(_selectedItems[item.id] ?? false);
                              });
                            },
                            child: Icon(
                              _selectedItems[item.id] ?? false
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: const Color(0xFF003366),
                            ),
                          ),
                          title: Row(
                            children: [
                              item.images.isNotEmpty
                                  ? Image.network(
                                    '${ApiService.imageBaseUrl}${item.images[0]}',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                              'assets/images/asus.png',
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                  )
                                  : Image.asset(
                                    'assets/images/asus.png',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    if (item.hasDiscount)
                                      Text(
                                        formatCurrency(item.price),
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    Text(
                                      formatCurrency(item.displayPrice),
                                      style: const TextStyle(
                                        color: Color(0xFF003366),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (item.discountDisplay != null)
                                      Text(
                                        item.discountDisplay!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await cartProvider.updateQuantity(
                                        item,
                                        quantity - 1,
                                      );
                                    },
                                    icon: const Icon(Icons.remove, size: 20),
                                  ),
                                  Text('$quantity'),
                                  IconButton(
                                    onPressed: () async {
                                      await cartProvider.updateQuantity(
                                        item,
                                        quantity + 1,
                                      );
                                    },
                                    icon: const Icon(Icons.add, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                final allSelected = _selectedItems.values.every(
                                  (selected) => selected,
                                );
                                setState(() {
                                  _selectedItems.updateAll(
                                    (key, value) => !allSelected,
                                  );
                                });
                              },
                              child: Icon(
                                _selectedItems.values.every(
                                      (selected) => selected,
                                    )
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: const Color(0xFF003366),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text("Tất cả"),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatCurrency(total),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF003366),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (discount > 0)
                                  Text(
                                    'Giảm: ${formatCurrency(discount)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                selectedItems.isEmpty
                                    ? null
                                    : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => CheckoutPage(
                                                selectedItems:
                                                    selectedItems
                                                        .map(
                                                          (item) => {
                                                            'id': item.id,
                                                            'name': item.name,
                                                            'price':
                                                                item.displayPrice,
                                                            'originalPrice':
                                                                item.hasDiscount
                                                                    ? item.price
                                                                    : null,
                                                            'quantity':
                                                                cartProvider
                                                                    .cartData[item
                                                                    .id],
                                                            'image':
                                                                item
                                                                        .images
                                                                        .isNotEmpty
                                                                    ? item
                                                                        .images[0]
                                                                    : 'assets/images/asus.png',
                                                            'discountDisplay':
                                                                item.discountDisplay,
                                                          },
                                                        )
                                                        .toList(),
                                                total: total.toInt(),
                                              ),
                                        ),
                                      );
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003366),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Thanh toán (${selectedItems.length})',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
