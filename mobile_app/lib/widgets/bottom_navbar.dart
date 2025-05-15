import 'package:flutter/material.dart';
import 'package:mobile_app/pages/CartPage.dart';
import 'package:mobile_app/pages/MessagePage.dart';
import 'package:mobile_app/pages/ProfilePage.dart';
import 'package:mobile_app/pages/WishList.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';




class CustomBottomNav extends StatefulWidget {
  final BuildContext parentContext;

  const CustomBottomNav({required this.parentContext});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}


class _CustomBottomNavState extends State<CustomBottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushReplacement(
          widget.parentContext,
          MaterialPageRoute(builder: (context) => WishList()), // <- Đúng tên class
        );
        break;
      case 2:
        Navigator.pushReplacement(
          widget.parentContext,
          MaterialPageRoute(builder: (context) => MessagePage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          widget.parentContext,
          MaterialPageRoute(builder: (context) => CartPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          widget.parentContext,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: Color(0xFFEDEDED),
      selectedItemColor: Color(0xFF194689),
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
      items: [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.house, color: _selectedIndex == 0 ? Color(0xFF194689) : Colors.black),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.heart, color: _selectedIndex == 1 ? Color(0xFF194689) : Colors.black),
          label: 'My favourite',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.comments, color: _selectedIndex == 2 ? Color(0xFF194689) : Colors.black),
          label: 'Contact',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.cartShopping, color: _selectedIndex == 3 ? Color(0xFF194689) : Colors.black),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.user, color: _selectedIndex == 4 ? Color(0xFF194689) : Colors.black),
          label: 'User',
        ),
      ],
    );
  }
}
