import 'package:flutter/material.dart';
import 'package:mobile_app/components/product_card.dart';
import 'package:mobile_app/components/recommend_component.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/services/recommend_service.dart';

class SearchPage extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const SearchPage({Key? key, this.categoryId, this.categoryName})
    : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = "";
  List<ProductsModel> _searchResults = [];
  List<ProductsModel> _categoryProducts = [];
  bool _isLoadingCategoryProducts = false;
  bool _isLoadingSearch = false;

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      _fetchCategoryProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchProducts() async {
    final query = _searchController.text.trim();
    setState(() {
      _query = query;
      _isLoadingSearch = true;
      _searchResults = [];
    });

    if (_query.isEmpty) {
      setState(() {
        _isLoadingSearch = false;
        _searchResults = [];
      });
      return;
    }

    try {
      // Gọi API gợi ý sản phẩm
      final recommendedProducts = await RecommendService.getRecommendedProducts(
        query: _query,
        topK: 20,
      );

      setState(() {
        _searchResults = recommendedProducts;
        _isLoadingSearch = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSearch = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tìm kiếm sản phẩm: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Nếu có danh mục, lọc thêm trong danh sách danh mục
    if (widget.categoryId != null && _categoryProducts.isNotEmpty) {
      final filteredCategoryProducts =
          _categoryProducts.where((product) {
            return product.name.toLowerCase().contains(_query.toLowerCase()) ||
                (product.title?.toLowerCase().contains(_query.toLowerCase()) ??
                    false);
          }).toList();

      setState(() {
        // Kết hợp sản phẩm gợi ý và sản phẩm trong danh mục
        _searchResults =
            [
              ...filteredCategoryProducts,
              ..._searchResults,
            ].toSet().toList(); // Loại bỏ trùng lặp
      });
    }
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
        SnackBar(content: Text('Lỗi khi tải sản phẩm danh mục: $e')),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Nhập tên sản phẩm...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF194689)),
                  onPressed: _searchProducts,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.categoryName != null &&
                widget.categoryId != null &&
                _query.isEmpty) ...[
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
                  : _categoryProducts.isEmpty && _query.isEmpty
                  ? const Center(
                    child: Text(
                      'Sản phẩm không tồn tại',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : Expanded(
                    child:
                        _query.isEmpty
                            ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 0.7,
                                  ),
                              itemCount: _categoryProducts.length,
                              itemBuilder: (context, index) {
                                final product = _categoryProducts[index];
                                return ProductCard(products: product);
                              },
                            )
                            : RecommendComponent(
                              recommendedProducts: _searchResults,
                              isLoading: _isLoadingSearch,
                              query: _query,
                            ),
                  ),
            ] else
              Expanded(
                child: RecommendComponent(
                  recommendedProducts: _searchResults,
                  isLoading: _isLoadingSearch,
                  query: _query,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
