// category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/category_model.dart';
import 'package:mobile_app/services/ApiService.dart';

class CategoryService {
  static const String baseUrl = ApiService.productService;

  static Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category/get'));

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> categoriesJson = jsonData['metadata'];
      return categoriesJson
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }
}
