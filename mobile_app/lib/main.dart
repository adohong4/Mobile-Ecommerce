import 'package:flutter/material.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/pages/LoginPage.dart';
import 'package:mobile_app/providers/wish_list_provider.dart';
import 'package:mobile_app/providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishListProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).initAuth();
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Ecommerce',
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.blue),
      home: LoginPage(), // bỏ const nếu LoginPage không có constructor const
    );
  }
}
