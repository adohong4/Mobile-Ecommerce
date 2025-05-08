import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/pages/CartPage.dart';
import 'package:mobile_app/pages/MessagePage.dart';
import 'package:mobile_app/pages/ProfilePage.dart';
import 'package:mobile_app/pages/WishList.dart';
import 'package:mobile_app/widgets/HomeAppBar.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _bannerController = PageController(viewportFraction: 0.9);
  final PageController _categoryController = PageController(viewportFraction: 1.0);
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
      body: ListView(
        children: [
          HomeAppBar(),
          SizedBox(height: 10),

          // --- Banner slider ---
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

          // --- Product category slider ---
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

          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "FLAST SALE",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNav(parentContext: context),
    );
  }

  // Banner builder
  Widget buildBanner(String asset) => Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: DecorationImage(
        image: AssetImage(asset),
        fit: BoxFit.cover,
      ),
    ),
  );

  // Category builder
  Widget buildCategoryRow(List<Map<String, String>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((item) {
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
              padding: EdgeInsets.only(left: 16.0), // Thêm padding bên trái
              child: Text(
                item['title']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )

          ],
        );
      }).toList(),
    );
  }
}
