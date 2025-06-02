import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/components/banner_component.dart';
import 'package:mobile_app/components/category_component.dart';
import 'package:mobile_app/components/advertise_component.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/widgets/HomeAppBar.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import 'package:mobile_app/components/product_card.dart' as component;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService productService = ProductService();
  late Future<List<ProductsModel>> _productsFuture;
  bool _hasShownAd = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchAllProducts();

    // Kiểm tra trạng thái hiển thị quảng cáo
    _checkAndShowAd();
  }

  Future<void> _checkAndShowAd() async {
    final prefs = await SharedPreferences.getInstance();
    final isAdShown = prefs.getBool('isAdShown') ?? false;

    if (!isAdShown) {
      // Hiển thị quảng cáo lần đầu
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder:
              (context) => AdvertiseComponent(
                // onAdTap: (adId) {
                //   // TODO: Điều hướng đến trang chi tiết quảng cáo nếu cần
                //   print('Tapped on ad: $adId');
                // },
              ),
        );
      });
      // Lưu trạng thái đã hiển thị quảng cáo
      await prefs.setBool('isAdShown', true);
      setState(() {
        _hasShownAd = true;
      });
    }
  }

  // Reset trạng thái quảng cáo khi đăng xuất (gọi từ trang đăng xuất)
  static Future<void> resetAdStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAdShown', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: HomeAppBar(),
          ),
          Expanded(
            child: ListView(
              children: [
                // Banner slider
                BannerComponent(),

                // Product categories
                CategoryComponent(),

                // Flash Sale
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "FLASH SALE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FutureBuilder<List<ProductsModel>>(
                        future: _productsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No products available'),
                            );
                          }

                          final products = snapshot.data!;
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0,
                                ),
                            itemBuilder: (context, index) {
                              return component.ProductCard(
                                products: products[index],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(parentContext: context),
    );
  }
}
