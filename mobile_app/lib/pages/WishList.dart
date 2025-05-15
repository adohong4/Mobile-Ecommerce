import 'package:flutter/material.dart';
import 'package:mobile_app/pages/HomePage.dart';
import 'package:mobile_app/widgets/wish_list_provider.dart';
import 'package:mobile_app/widgets/cart_provider.dart';
import 'package:provider/provider.dart';

// Widget cho trang danh sách yêu thích
class WishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wishList = context.watch<WishListProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          ),
        ),
        title: Text("Yêu thích"),
      ),
      body: wishList.items.isEmpty
          ? Center(child: Text("Bạn chưa có sản phẩm yêu thích"))
          : ListView.builder(
        itemCount: wishList.items.length,
        itemBuilder: (ctx, i) {
          final p = wishList.items[i];
          return ListTile(
            leading: Image.asset(p.image, width: 40, height: 40),
            title: Text(p.name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => wishList.remove(p),
            ),
          );
        },
      ),
    );
  }
}
