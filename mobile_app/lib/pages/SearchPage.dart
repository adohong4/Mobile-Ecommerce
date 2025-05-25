
import 'package:flutter/material.dart';
import 'package:mobile_app/data/fake_products.dart'; // danh sách sản phẩm giả lập
import 'package:mobile_app/models/models_products.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = "";
  List<ProductModel> _searchResults = [];

  void _searchProducts(String query) {
    setState(() {
      _query = query.trim().toLowerCase();
      if (_query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = fakeProducts.where((product) {
          return product.name.toLowerCase().contains(_query) ||
              product.brand.toLowerCase().contains(_query);
        }).toList();
      }
    });
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tìm kiếm sản phẩm",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF194689),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Nhập tên sản phẩm...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onSubmitted: _searchProducts,
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _query.isEmpty
                  ? const Center(
                child: Text(
                  "Vui lòng nhập từ khóa để tìm kiếm sản phẩm",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : (_searchResults.isEmpty
                  ? Center(
                child: Text(
                  "Không có sản phẩm liên quan cho '$_query'",
                  style: const TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final product = _searchResults[index];
                  return ListTile(
                    leading: product.images.isNotEmpty
                        ? Image.asset(
                      'assets/images/${product.images[0]}',
                      width: 50,
                      fit: BoxFit.cover,
                    )
                        : null,
                    title: Text(product.name),
                    subtitle: Text(
                      product.discountPercent > 0
                          ? "${_formatPrice(product.price)} đ (-${product.discountPercent}%)"
                          : "${_formatPrice(product.price)} đ",
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // TODO: thêm điều hướng tới chi tiết sản phẩm nếu cần
                    },
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
