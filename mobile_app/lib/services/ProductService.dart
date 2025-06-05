import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ApiService.dart';

class ProductService {
  static Future<List<ProductsModel>> fetchAllProducts() async {
    try {
      final response = await http.get(Uri.parse(ApiService.productList));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is! Map<String, dynamic> ||
            data['metadata'] == null ||
            data['metadata']['product'] == null) {
          throw Exception(
            'Invalid JSON structure: missing metadata or product',
          );
        }
        final List<dynamic> productsJson = data['metadata']['product'];
        return productsJson
            .map((json) => ProductsModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<ProductsModel> fetchProductById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.productList}/$id'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is! Map<String, dynamic> || data['metadata'] == null) {
          throw Exception('Invalid JSON structure: missing metadata');
        }
        return ProductsModel.fromJson(data['metadata']['product']);
      } else {
        throw Exception(
          'Failed to load product: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching product by ID: $e');
      rethrow;
    }
  }

  static Future<List<ProductsModel>> fetchProductsByIds(
    List<String> ids,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.productList}/by-ids'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ids': ids}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is! Map<String, dynamic> || data['metadata'] == null) {
          throw Exception('Invalid JSON structure: missing metadata');
        }
        final List<dynamic> productsJson = data['metadata'];
        return productsJson
            .map((json) => ProductsModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load products: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print(
        'Error fetching products by IDs: $e. Falling back to individual fetches.',
      );
      final products = <ProductsModel>[];
      for (var id in ids) {
        try {
          final product = await fetchProductById(id);
          products.add(product);
        } catch (e) {
          print('Failed to fetch product $id: $e');
        }
      }
      return products;
    }
  }

  static Future<List<ProductsModel>> fetchProductsByCategory(
    String categoryId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:9004/v1/api/product/category/$categoryId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is! Map<String, dynamic> || data['metadata'] == null) {
          throw Exception('Invalid JSON structure: missing metadata');
        }
        final List<dynamic> productsJson = data['metadata'];
        return productsJson
            .map((json) => ProductsModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load products for category: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching products by category: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>>
  fetchRandomProductsByCategories() async {
    try {
      // Gọi API /random để lấy danh sách productIds theo danh mục
      final response = await http.get(
        Uri.parse('http://localhost:9004/v1/api/product/random'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is! Map<String, dynamic> || data['metadata'] == null) {
          throw Exception('Invalid JSON structure: missing metadata');
        }

        // Lấy tất cả sản phẩm từ fetchAllProducts
        final allProducts = await fetchAllProducts();
        final List<dynamic> categoriesJson = data['metadata'];
        final List<Map<String, dynamic>> result = [];

        // Lặp qua từng danh mục trong metadata
        for (var categoryData in categoriesJson) {
          final String category = categoryData['category'];
          final List<dynamic> productIds = categoryData['productIds'] ?? [];

          // Lọc các sản phẩm từ allProducts dựa trên productIds
          final List<ProductsModel> filteredProducts =
              allProducts
                  .where(
                    (product) =>
                        productIds.contains(product.id.toString()) &&
                        product.active == true,
                  )
                  .take(5) // Đảm bảo tối đa 5 sản phẩm
                  .toList();

          // Thêm danh mục và danh sách sản phẩm vào kết quả
          result.add({'category': category, 'products': filteredProducts});
        }

        return result;
      } else {
        throw Exception(
          'Failed to load random products: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching random products by categories: $e');
      rethrow;
    }
  }
}
