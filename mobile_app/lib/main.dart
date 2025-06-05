import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/providers/voucher_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/pages/LoginPage.dart';
import 'package:mobile_app/providers/wish_list_provider.dart';
import 'package:mobile_app/providers/cart_provider.dart';

void main() {
  if (!kIsWeb) {
    stripe.Stripe.publishableKey =
        'pk_test_51RUVHWRr5z5pdPCHpnnv1nKGUvwf5v5rBBYJVGR240QDHYQm4Zja0gwLBBhFQsHeOHF6Wfe9e7kFuL4TApsMPlzC000oT3GTEJ';
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VoucherProvider()),
        ChangeNotifierProvider(create: (_) => WishListProvider()),
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
