import 'package:flutter/material.dart';

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
  String? selectedAddress;
  String? selectedPaymentMethod = 'cod';

  List<Map<String, dynamic>> paymentMethods = [
    {'id': 'cod', 'label': 'Trả tiền mặt khi nhận hàng'},
    {'id': 'bank', 'label': 'Chuyển khoản ngân hàng'},
    {'id': 'stripe', 'label': 'Quét Mã Stripe', 'image': 'assets/stripe.png'},
    {'id': 'zalopay', 'label': 'Quét Mã QR ZaloPay', 'image': 'assets/zalopay.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("THANH TOÁN", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Mã ưu đãi
            buildInputField("Nhập mã ưu đãi"),

            const SizedBox(height: 20),
            // Thông tin thanh toán
            buildSection("Thông tin thanh toán", child: Column(
              children: [
                buildInputField("Họ"),
                buildInputField("Tên"),
                buildAddressDropdown(),
                buildInputField("Số điện thoại"),
              ],
            )),

            const SizedBox(height: 20),
            // Thông tin bổ sung
            buildSection("Thông tin bổ sung", child: buildInputField("Ghi chú của bạn cho đơn hàng...", lines: 3)),

            const SizedBox(height: 20),
            // Đơn hàng của bạn
            buildSection("Đơn hàng của bạn", child: buildOrderSummary()),

            const SizedBox(height: 20),
            // Phương thức thanh toán
            ...paymentMethods.map((method) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio(
                  value: method['id'],
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value.toString();
                    });
                  },
                ),
                title: Row(
                  children: [
                    Text(method['label']),
                    const SizedBox(width: 8),
                    if (method['image'] != null)
                      Image.asset(method['image'], height: 24),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Xử lý đặt hàng
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF003366),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("ĐẶT HÀNG", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, {int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget buildAddressDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Địa chỉ',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        items: ['Hà Nội', 'TP. HCM', 'Đà Nẵng']
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedAddress = value;
          });
        },
      ),
    );
  }

  Widget buildSection(String title, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFF5F5F5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget buildOrderSummary() {
    return Column(
      children: [
        ...widget.selectedItems.map((item) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('${item['name']} × ${item['quantity']}')),
              Text('${(item['price'] as int).toStringAsFixed(0)}đ'),
            ],
          );
        }).toList(),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Tạm tính", style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${widget.total.toStringAsFixed(0)}đ'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Tổng", style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${widget.total.toStringAsFixed(0)}đ', style: const TextStyle(color: Colors.blue)),
          ],
        ),
      ],
    );
  }
}
