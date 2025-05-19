import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mobile_app/pages/HomePage.dart';
import 'package:mobile_app/pages/CheckoutPage.dart';
class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, dynamic>> cartItems = List.generate(5, (index) {
    final random = Random();
    final prices = [17500000, 20000000, 25000000, 30000000];
    final oldPrices = [25000000, 27000000, 30000000, 35000000];
    final names = [
      'Màn Hình Di Động Thông Minh SIEGenX 27 inch',
      'Laptop ASUS ZenBook 14',
      'Tai Nghe Bluetooth Sony WH-1000XM4',
      'Điện Thoại Samsung Galaxy S22',
      'Máy Tính Bảng Apple iPad Pro',
    ];
    final images = [
      'assets/asus.png',
      'assets/samsung.png',
      'assets/asus.png',
      'assets/apple.png',
      'assets/asus.png',
    ];

    return {
      'id': index,
      'name': names[random.nextInt(names.length)],
      'price': prices[random.nextInt(prices.length)],
      'oldPrice': oldPrices[random.nextInt(oldPrices.length)],
      'discount': random.nextInt(30) + 10, // Giảm giá từ 10-40%
      'quantity': random.nextInt(5) + 1, // Số lượng từ 1 đến 5
      'selected': random.nextBool(), // Chọn ngẫu nhiên
      'image': images[random.nextInt(images.length)],
    };
  });

  @override
  Widget build(BuildContext context) {
    final selectedItems = cartItems.where((item) => item['selected'] == true).toList();

    final total = selectedItems.fold(
      0,
          (sum, item) =>
      sum + (item['price'] as int) * (item['quantity'] as int),
    );

    final discount = selectedItems.fold(
      0,
          (sum, item) =>
      sum + ((item['oldPrice'] as int) - (item['price'] as int) * (item['quantity'] as int)).toInt(),
    );

    return Scaffold(
      appBar: AppBar(
        title:  Text('Giỏ hàng (${cartItems.length})', style: TextStyle(color: Colors.black)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Chuyển hướng về trang chủ
            );
          },
        ),

      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      setState(() {
                        item['selected'] = !(item['selected'] ?? false);
                      });
                    },
                    child: Icon(
                      item['selected'] ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: Color(0xFF003366),
                    ),
                  ),
                  title: Row(
                    children: [
                      Image.asset(
                        item['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${item['price'].toStringAsFixed(0)} đ',
                                  style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '${item['oldPrice'].toStringAsFixed(0)} đ',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 6),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (item['quantity'] > 1) item['quantity']--;
                              });
                            },
                            icon: Icon(Icons.remove, size: 20),
                          ),
                          Text('${item['quantity']}'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                item['quantity']++;
                              });
                            },
                            icon: Icon(Icons.add, size: 20),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final allSelected = cartItems.every((item) => item['selected']);
                        setState(() {
                          for (var item in cartItems) {
                            item['selected'] = !allSelected;
                          }
                        });
                      },
                      child: Icon(
                        cartItems.every((item) => item['selected'])
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: Color(0xFF003366),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text("Tất cả"),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${total.toStringAsFixed(0)} đ',
                          style: TextStyle(fontSize: 16, color: Color(0xFF003366), fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Giảm: ${discount.toStringAsFixed(0)} đ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedItems.isEmpty
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            selectedItems: selectedItems,
                            total: total,
                          ),
                        ),
                      );
                    },


                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF003366),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Thanh toán (${selectedItems.length})', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5),
    );
  }
}
