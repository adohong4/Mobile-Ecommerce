import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ProductService.dart';

class RecommendService {
  static const String _recommendUrl = 'http://localhost:5000/v1/api/recommend';

  static Future<List<ProductsModel>> getRecommendedProducts({
    required String query,
    int topK = 10,
  }) async {
    try {
      // Gửi yêu cầu POST tới API gợi ý
      final response = await http.post(
        Uri.parse(_recommendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query, 'top_k': topK}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['recommendations'] == null) {
          throw Exception('Invalid response: missing recommendations');
        }

        // Lấy danh sách ID sản phẩm gợi ý
        final List<dynamic> recommendations = data['recommendations'];
        final List<String> productIds =
            recommendations.map((item) => item['_id'].toString()).toList();

        // Lấy tất cả sản phẩm và lọc theo ID
        final allProducts = await ProductService.fetchAllProducts();
        final recommendedProducts =
            allProducts
                .where((product) => productIds.contains(product.id))
                .toList();

        // Sắp xếp sản phẩm theo thứ tự ID từ API gợi ý
        final sortedProducts = <ProductsModel>[];
        for (var id in productIds) {
          final product = recommendedProducts.firstWhere(
            (p) => p.id == id,
            // orElse: () => ProductsModel.empty(),
          );
          if (product.id.isNotEmpty) {
            sortedProducts.add(product);
          }
        }

        return sortedProducts;
      } else {
        throw Exception(
          'Failed to load recommendations: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching recommended products: $e');
      rethrow;
    }
  }
}
