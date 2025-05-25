import 'package:flutter/material.dart';
import 'package:mobile_app/pages/SearchPage.dart';
import 'package:mobile_app/models/models_products.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Spacer(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            child: const Icon(Icons.search, size: 32, color: Color(0xFF4C53A5)),
          ),
        ],
      ),
    );
  }
}
