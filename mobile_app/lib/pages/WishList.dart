import 'package:flutter/material.dart';
import 'package:mobile_app/pages/HomePage.dart';

class WishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm yêu thích'),
        backgroundColor: Color(0xFF194689),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Điều hướng về trang chủ
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        children: List.generate(4, (index) {
          return _buildWishlistItem(
            title: 'Tivi Xiaomi 75 inch 4K (EA75 model 2023)',
            price: '2.000.000 đ',
            onDelete: () {
              // Xử lý sự kiện xóa sản phẩm
            },
          );
        }),
      ),
    );
  }

  Widget _buildWishlistItem({
    required String title,
    required String price,
    required VoidCallback onDelete,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Image.asset('product.png', fit: BoxFit.cover)),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      price,
                      style: TextStyle(color: Color(0xFF194689), fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
