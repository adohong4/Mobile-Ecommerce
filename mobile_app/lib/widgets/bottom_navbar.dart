import 'package:flutter/material.dart';
import 'package:mobile_app/pages/CartPage.dart';
import 'package:mobile_app/pages/ProfilePage.dart';
import 'package:mobile_app/pages/WishList.dart';
import 'package:mobile_app/pages/voucher_page.dart';
import 'package:mobile_app/pages/HomePage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNav extends StatefulWidget {
  final BuildContext parentContext;
  final int selectedIndex;

  const CustomBottomNav({
    required this.parentContext,
    required this.selectedIndex,
  });
  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget targetPage;

    switch (index) {
      case 0:
        targetPage = HomePage(); // Bạn cần import và định nghĩa HomePage
        break;
      case 1:
        targetPage = WishList();
        break;
      case 2:
        targetPage = VoucherPage();
        break;
      case 3:
        targetPage = CartPage();
        break;
      case 4:
        targetPage = ProfilePage();
        break;
      default:
        targetPage = HomePage();
    }

    Navigator.push(
      widget.parentContext,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: Color(0xFFEDEDED),
      // selectedItemColor: Color(0xFF194689),
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
      items: [
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.house,
            color: _selectedIndex == 0 ? Color(0xFF194689) : Colors.black,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.heart,
            color: _selectedIndex == 1 ? Color(0xFF194689) : Colors.black,
          ),
          label: 'My favourite',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.tags,
            color: _selectedIndex == 2 ? Color(0xFF194689) : Colors.black,
          ),
          label: 'Voucher',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.cartShopping,
            color: _selectedIndex == 3 ? Color(0xFF194689) : Colors.black,
          ),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.user,
            color: _selectedIndex == 4 ? Color(0xFF194689) : Colors.black,
          ),
          label: 'User',
        ),
      ],
    );
  }
}
