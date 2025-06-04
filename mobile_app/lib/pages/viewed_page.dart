import 'package:flutter/material.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/components/product_card.dart' as component;
import 'package:mobile_app/services/viewed_product_service.dart';

class ViewedPage extends StatefulWidget {
  const ViewedPage({super.key});

  @override
  _ViewedPageState createState() => _ViewedPageState();
}

class _ViewedPageState extends State<ViewedPage> {
  final ViewedProductService _viewedProductService = ViewedProductService();
  late Future<List<ProductsModel>> _viewedProductsFuture;

  @override
  void initState() {
    super.initState();
    _viewedProductsFuture = _fetchViewedProducts();
  }

  Future<List<ProductsModel>> _fetchViewedProducts() async {
    try {
      // Lấy danh sách productId từ getViewedProducts
      final viewedResponse = await _viewedProductService.getViewedProducts();
      if (viewedResponse['success'] &&
          viewedResponse['viewedProducts'] != null) {
        List<String> productIds = List<String>.from(
          viewedResponse['viewedProducts'],
        );
        if (productIds.isEmpty) {
          return [];
        }

        // Lấy toàn bộ sản phẩm từ fetchAllProducts
        final allProducts = await ProductService.fetchAllProducts();

        // Lọc các sản phẩm có id nằm trong productIds
        final viewedProducts =
            allProducts
                .where((product) => productIds.contains(product.id))
                .toList();

        // Sắp xếp theo thứ tự của productIds (nếu cần)
        viewedProducts.sort(
          (a, b) =>
              productIds.indexOf(a.id).compareTo(productIds.indexOf(b.id)),
        );

        return viewedProducts;
      } else {
        throw Exception(
          viewedResponse['message'] ??
              'Không lấy được danh sách sản phẩm đã xem',
        );
      }
    } catch (e) {
      debugPrint('Error fetching viewed products: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm đã xem'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder<List<ProductsModel>>(
        future: _viewedProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có sản phẩm nào được xem'));
          }

          final products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return component.ProductCard(products: products[index]);
            },
          );
        },
      ),
    );
  }
}
