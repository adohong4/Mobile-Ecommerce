import 'package:flutter/material.dart';
import 'package:mobile_app/components/Product_card.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ProductService.dart';

class SearchPage extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const SearchPage({super.key, this.categoryId, this.categoryName});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = "";
  List<ProductsModel> _searchResults = [];
  List<ProductsModel> _categoryProducts = [];
  bool _isLoadingCategoryProducts = false;

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      _fetchCategoryProducts();
    }
  }

  void _searchProducts(String query) {
    setState(() {
      _query = query.trim().toLowerCase();
      if (_query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults =
            _categoryProducts.where((product) {
              return product.name.toLowerCase().contains(_query) ||
                  (product.title?.toLowerCase().contains(_query) ?? false);
            }).toList();
      }
    });
  }

  Future<void> _fetchCategoryProducts() async {
    setState(() {
      _isLoadingCategoryProducts = true;
    });
    try {
      final products = await ProductService.fetchProductsByCategory(
        widget.categoryId!,
      );
      setState(() {
        _categoryProducts = products;
        _isLoadingCategoryProducts = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategoryProducts = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading category products: $e')),
      );
    }
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            if (widget.categoryName != null && widget.categoryId != null) ...[
              Text(
                widget.categoryName!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF194689),
                ),
              ),
              const SizedBox(height: 8),
              _isLoadingCategoryProducts
                  ? const Center(child: CircularProgressIndicator())
                  : _categoryProducts.isEmpty
                  ? const Center(
                    child: Text(
                      'Sản phẩm không tồn tại',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 sản phẩm mỗi hàng
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio:
                                0.7, // Tỷ lệ chiều cao/rộng của ProductCard
                          ),
                      itemCount:
                          _query.isEmpty
                              ? _categoryProducts.length
                              : _searchResults.length,
                      itemBuilder: (context, index) {
                        final product =
                            _query.isEmpty
                                ? _categoryProducts[index]
                                : _searchResults[index];
                        return ProductCard(products: product);
                      },
                    ),
                  ),
            ] else
              Expanded(
                child:
                    _query.isEmpty
                        ? const Center(
                          child: Text(
                            "Vui lòng nhập từ khóa để tìm kiếm sản phẩm",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                        : _searchResults.isEmpty
                        ? Center(
                          child: Text(
                            "Không có sản phẩm liên quan cho '$_query'",
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                        : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.7,
                              ),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final product = _searchResults[index];
                            return ProductCard(products: product);
                          },
                        ),
              ),
          ],
        ),
      ),
    );
  }
}
