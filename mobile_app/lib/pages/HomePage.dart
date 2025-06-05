import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/components/suggest_component.dart';
import 'package:mobile_app/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/components/banner_component.dart';
import 'package:mobile_app/components/category_component.dart';
import 'package:mobile_app/components/advertise_component.dart';
import 'package:mobile_app/components/product_home_component.dart';
import 'package:mobile_app/pages/EditProfilePage.dart';
import 'package:mobile_app/widgets/HomeAppBar.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProfileService profileService = ProfileService();
  bool _hasShownAd = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkProfileAndNavigate();
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const AdvertiseComponent(),
      );
    });
  }

  Future<void> _checkProfileAndNavigate() async {
    try {
      final result = await profileService.getProfile();
      if (!result['success'] || result['profile'] == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditProfilePage(profile: {}),
          ),
        ).then((_) {
          setState(() {}); // Làm mới giao diện nếu cần
        });
      }
    } catch (e) {
      debugPrint('Error checking profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi kiểm tra hồ sơ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
              children: const [
                BannerComponent(),
                CategoryComponent(),
                ProductHomeComponent(), // Thêm component mới
                SuggestComponent(), // Gợi ý sản phẩm
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
