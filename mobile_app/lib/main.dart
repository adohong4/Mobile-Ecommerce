import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:mobile_app/pages/CartPage.dart';
import 'package:mobile_app/pages/CheckoutPage.dart';
import 'package:mobile_app/pages/EditProfilePage.dart';
import 'package:mobile_app/pages/HomePage.dart' show HomePage;
import 'package:mobile_app/pages/ProfilePage.dart';
import 'package:mobile_app/pages/VerifyPage.dart';
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
      home: LoginPage(),
      // initialRoute: '/login',
      // routes: {
      //   '/login': (context) => LoginPage(),
      //   '/': (context) => const HomePage(),
      //   '/verify': (context) => const VerifyPage(),
      //   '/cart': (context) => const CartPage(),
      //   '/profile': (context) => const ProfilePage(),
      //   '/edit_profile': (context) => const EditProfilePage(profile: {}),
      // },
      // onGenerateRoute: (settings) {
      //   if (settings.name == '/checkout') {
      //     final args = settings.arguments as Map<String, dynamic>;
      //     return MaterialPageRoute(
      //       builder:
      //           (context) => CheckoutPage(
      //             selectedItems:
      //                 args['selectedItems'] as List<Map<String, dynamic>>,
      //             total: args['total'] as int,
      //           ),
      //     );
      //   }
      //   return null;
      // },
    );
  }
}
