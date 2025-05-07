import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/components/ProfilePicture.dart';
import 'package:mobile_app/pages/CartPage.dart';
import 'package:mobile_app/pages/MessagePage.dart';
import 'package:mobile_app/widgets/CartAppBar.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [CartAppBar(), ProfilePicture()]),
        bottomNavigationBar: CustomBottomNav(parentContext: context)
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: Colors.transparent,
      //   onTap: (index) {
      //     if (index == 3) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => CartPage()),
      //       );
      //     }
      //     if (index == 2) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => MessagePage()),
      //       );
      //     }
      //     if (index == 4) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => ProfilePage()),
      //       );
      //     }
      //   },
      //   height: 50,
      //   color: Color(0xFF194689),
      //   items: [
      //     Icon(Icons.home, size: 30, color: Colors.white),
      //     Icon(Icons.favorite, size: 30, color: Colors.white),
      //     Icon(Icons.message, size: 30, color: Colors.white),
      //     Icon(Icons.shopping_bag_outlined, size: 30, color: Colors.white),
      //     Icon(Icons.person, size: 30, color: Colors.white),
      //   ],
      // ),
    );
  }
}
