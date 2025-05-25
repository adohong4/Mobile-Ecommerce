import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/pages/CartPage.dart';
import 'package:mobile_app/pages/MessagePage.dart';
import 'package:mobile_app/pages/ProfilePage.dart';
import 'package:mobile_app/pages/WishList.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/widgets/HomeAppBar.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import 'package:mobile_app/components/product_card.dart' as component;
import 'package:mobile_app/data/fake_products.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService productService = ProductService();
  late Future<List<ProductsModel>> _productsFuture;

  final PageController _bannerController = PageController(
    viewportFraction: 0.9,
  );
  final PageController _categoryController = PageController(
    viewportFraction: 1.0,
  );
  int _bannerPage = 0;
  int _categoryPage = 0;
  late Timer _timer;

  final List<String> _banners = [
    'assets/banner_1.jpg',
    'assets/banner_2.png',
    'assets/banner_3.png',
  ];

  final List<List<Map<String, String>>> _productCategories = [
    [
      {'image': 'assets/apple.png', 'title': 'APPLE'},
      {'image': 'assets/microsoft.png', 'title': 'MICROSOFT'},
    ],
    [
      {'image': 'assets/apple.png', 'title': 'ASUS'},
      {'image': 'assets/microsoft.png', 'title': 'SAMSUNG'},
    ],
  ];

  @override
  void initState() {
    super.initState();

    _productsFuture = ProductService.fetchAllProducts();

    // Hiển thị popup quảng cáo khi màn hình load xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAdPopup();
    });

    // Tự động cuộn banner
    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      if (_bannerController.hasClients) {
        int nextPage = (_bannerPage + 1) % _banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _categoryController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // hoặc bất kỳ màu nền nào của app bar
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // màu bóng
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3), // đổ bóng xuống dưới
                ),
              ],
            ),
            child: HomeAppBar(),
          ),// Cố định ở trên
          Expanded( // Nội dung cuộn được
            child: ListView(
              children: [
                // Banner slider
                Container(
                  height: 200,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _bannerController,
                          itemCount: _banners.length,
                          onPageChanged: (index) {
                            setState(() {
                              _bannerPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return buildBanner(_banners[index]);
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _banners.length,
                              (index) => Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _bannerPage == index ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Product categories
                Container(
                  height: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'DANH MỤC SẢN PHẨM',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _categoryController,
                          itemCount: _productCategories.length,
                          onPageChanged: (index) {
                            setState(() {
                              _categoryPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return buildCategoryRow(_productCategories[index]);
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _productCategories.length,
                              (index) => Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _categoryPage == index ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      FutureBuilder<List<ProductsModel>>(
                        future: _productsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No products available'));
                          }

                          final products = snapshot.data!;
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: products.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              return component.ProductCard(products: products[index]);
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

  // Widget hiển thị banner
  Widget buildBanner(String asset) => Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover),
    ),
  );

  // Widget hiển thị danh mục sản phẩm
  Widget buildCategoryRow(List<Map<String, String>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          items.map((item) {
            return Row(
              children: [
                Image.asset(
                  item['image']!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    item['title']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  void _showAdPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text(' Ưu đãi đặc biệt!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/banner_3.png',
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Text('Giảm 20% toàn bộ sản phẩm hôm nay!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Xem ngay'),
            ),
          ],
        );
      },
    );
  }
}
