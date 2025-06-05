import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/services/viewed_product_service.dart';

class RecommendService {
  static const String _recommendUrl = ApiService.Search;
  static const String _recommendViewedUrl = ApiService.recommend;

  static Future<List<ProductsModel>> getRecommendedProducts({
    required String query,
    int topK = 10,
  }) async {
    try {
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

        final List<dynamic> recommendations = data['recommendations'];
        final List<String> productIds =
            recommendations.map((item) => item['_id'].toString()).toList();

        final allProducts = await ProductService.fetchAllProducts();
        final recommendedProducts =
            allProducts
                .where((product) => productIds.contains(product.id))
                .toList();

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

  static Future<List<ProductsModel>>
  getRecommendedProductsBasedOnViewed() async {
    try {
      // Step 1: Get viewed product IDs
      final viewedService = ViewedProductService();
      final viewedResponse = await viewedService.getViewedProducts();

      if (!viewedResponse['success']) {
        print('Error fetching viewed products: ${viewedResponse['message']}');
        return [];
      }

      final List<String> viewedProductIds = List<String>.from(
        viewedResponse['viewedProducts'] ?? [],
      );

      if (viewedProductIds.isEmpty) {
        print("No viewed products available for recommendation.");
        return [];
      }

      // Step 2: Send POST request to recommendation API with productIds
      final response = await http.post(
        Uri.parse(_recommendViewedUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'productIds': viewedProductIds}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> recommendations = jsonDecode(response.body);
        final List<String> recommendedProductIds =
            recommendations.map((item) => item['_id'].toString()).toList();

        // Step 3: Fetch all products and filter by recommended IDs
        final allProducts = await ProductService.fetchAllProducts();
        final recommendedProducts =
            allProducts
                .where((product) => recommendedProductIds.contains(product.id))
                .toList();

        // Step 4: Sort products according to the order of recommended IDs
        final sortedProducts = <ProductsModel>[];
        for (var id in recommendedProductIds) {
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
      print('Error fetching recommended products based on viewed: $e');
      rethrow;
    }
  }
}
