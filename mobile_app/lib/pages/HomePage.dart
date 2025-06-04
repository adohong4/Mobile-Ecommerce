import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/components/banner_component.dart';
import 'package:mobile_app/components/category_component.dart';
import 'package:mobile_app/components/advertise_component.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/widgets/HomeAppBar.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import 'package:mobile_app/components/product_card.dart' as component;
import 'package:mobile_app/pages/EditProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService productService = ProductService();
  final ProfileService profileService =
      ProfileService(); // Khởi tạo ProfileService
  late Future<List<ProductsModel>> _productsFuture;
  bool _hasShownAd = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchAllProducts();

    // Kiểm tra hồ sơ sau khi giao diện được xây dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkProfileAndNavigate();
      // Hiển thị quảng cáo
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const AdvertiseComponent(),
      );
    });
  }

  // Hàm kiểm tra hồ sơ và điều hướng nếu cần
  Future<void> _checkProfileAndNavigate() async {
    try {
      final result = await profileService.getProfile();
      if (!result['success'] || result['profile'] == null) {
        // Nếu không có hồ sơ, điều hướng đến EditProfilePage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => const EditProfilePage(
                  profile: {}, // Truyền hồ sơ rỗng
                ),
          ),
        ).then((_) {
          // Làm mới dữ liệu sản phẩm hoặc hồ sơ nếu cần sau khi quay lại
          setState(() {
            _productsFuture = ProductService.fetchAllProducts();
          });
        });
      }
    } catch (e) {
      debugPrint('Error checking profile: $e');
      // Có thể hiển thị SnackBar thông báo lỗi nếu cần
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi kiểm tra hồ sơ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Reset trạng thái quảng cáo khi đăng xuất
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
            height: 100,
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
                                  childAspectRatio: 0.65,
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
      bottomNavigationBar: CustomBottomNav(
        parentContext: context,
        selectedIndex: 0,
      ),
    );
  }
}
