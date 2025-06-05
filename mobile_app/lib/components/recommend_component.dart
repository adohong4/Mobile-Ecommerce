import 'package:flutter/material.dart';
import 'package:mobile_app/components/product_card.dart';
import 'package:mobile_app/models/productModel.dart';

class RecommendComponent extends StatelessWidget {
  final List<ProductsModel> recommendedProducts;
  final bool isLoading;
  final String query;

  const RecommendComponent({
    Key? key,
    required this.recommendedProducts,
    required this.isLoading,
    required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Vui lòng nhập từ khóa để tìm kiếm sản phẩm',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    if (recommendedProducts.isEmpty) {
      return Center(
        child: Text(
          'Không có sản phẩm gợi ý cho "$query"',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: recommendedProducts.length,
      itemBuilder: (context, index) {
        final product = recommendedProducts[index];
        return ProductCard(products: product);
      },
    );
  }
}
