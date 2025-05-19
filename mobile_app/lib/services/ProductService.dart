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
        // Kiểm tra nếu metadata hoặc product không tồn tại
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
}
