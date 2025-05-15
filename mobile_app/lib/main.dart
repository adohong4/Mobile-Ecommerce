import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/pages/LoginPage.dart';
import 'package:mobile_app/widgets/wish_list_provider.dart';
import 'package:mobile_app/widgets/cart_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishListProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Ecommerce',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),   // bỏ const nếu LoginPage không có constructor const
    );
  }
}