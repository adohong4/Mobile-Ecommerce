import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ApiService.dart';

class ProductService {
  // Lấy tất cả sản phẩm (giữ nguyên)
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

  // Lấy sản phẩm theo ID
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
        return ProductsModel.fromJson(
          data['metadata']['updatedProduct'] ?? data['metadata']['product'],
        );
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

  // Lấy sản phẩm theo danh sách ID (giữ nguyên)
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

  // Lấy sản phẩm theo danh mục (giữ nguyên)
  static Future<List<ProductsModel>> fetchProductsByCategory(
    String categoryId,
  ) async {
    try {
      // Bước 1: Lấy danh sách sản phẩm thuộc danh mục
      final response = await http.get(

        Uri.parse('${ApiService.productService}/category/$categoryId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
          'fetchProductsByCategory response for category $categoryId: $data',
        ); // In JSON để debug
        if (data is! Map<String, dynamic> || data['metadata'] == null) {
          throw Exception('Invalid JSON structure: missing metadata');
        }

        final List<dynamic> productsJson = data['metadata'];
        final List<String> productIds =
            productsJson
                .map((json) => json['_id']?.toString())
                .where((id) => id != null)
                .cast<String>()
                .toList();

        print(
          'Product IDs from category $categoryId: $productIds',
        ); // In danh sách ID

        // Bước 2: Lấy tất cả sản phẩm khuyến mãi
        final campaignProducts = await fetchCampaignProducts();
        print(
          'Campaign products fetched: ${campaignProducts.length}',
        ); // In số lượng sản phẩm khuyến mãi

        // Bước 3: Lọc sản phẩm khuyến mãi theo productIds
        final List<ProductsModel> filteredProducts =
            campaignProducts
                .where((product) => productIds.contains(product.id))
                .toList();

        print(
          'Filtered campaign products for category $categoryId: ${filteredProducts.length}',
        ); // In số lượng sản phẩm sau lọc

        // Bước 4: Nếu muốn giữ cả sản phẩm không khuyến mãi, kết hợp với danh sách gốc
        final Map<String, ProductsModel> productMap = {
          for (var product in filteredProducts) product.id!: product,
        };
        for (var json in productsJson) {
          final String? id = json['_id']?.toString();
          if (id != null && !productMap.containsKey(id)) {
            productMap[id] = ProductsModel.fromJson(json);
          }
        }

        return productMap.values.toList();
      } else {
        throw Exception(
          'Failed to load products for category: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching products by category $categoryId: $e');
      rethrow;
    }
  }

  // Lấy sản phẩm ngẫu nhiên theo danh mục (giữ nguyên)
  static Future<List<Map<String, dynamic>>>
  fetchRandomProductsByCategories() async {
    try {
      final response = await http.get(

        Uri.parse('${ApiService.productService}/random'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is! Map<String, dynamic> || data['metadata'] == null) {
          throw Exception('Invalid JSON structure: missing metadata');
        }

        final allProducts = await fetchAllProducts();
        final List<dynamic> categoriesJson = data['metadata'];
        final List<Map<String, dynamic>> result = [];

        for (var categoryData in categoriesJson) {
          final String category = categoryData['category'];
          final List<dynamic> productIds = categoryData['productIds'] ?? [];

          final List<ProductsModel> filteredProducts =
              allProducts
                  .where(
                    (product) =>
                        productIds.contains(product.id.toString()) &&
                        product.active == true,
                  )
                  .take(5)
                  .toList();

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

  // Lấy sản phẩm với giá đã cập nhật từ chương trình khuyến mãi
  static Future<List<ProductsModel>> fetchCampaignProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.productService}/campaign/updateProductPrice'),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data is! Map<String, dynamic> ||
            data['metadata'] == null ||
            data['metadata']['updatedProducts'] == null) {
          throw Exception(
            'Invalid JSON structure: missing metadata or updatedProducts',
          );
        }
        final List<dynamic> productsJson = data['metadata']['updatedProducts'];
        final String? campaignType =
            data['metadata']['campaignType']?.toString();
        final double? campaignValue =
            (data['metadata']['campaignValue'] as num?)?.toDouble();

        // Thêm campaignType và campaignValue vào mỗi sản phẩm
        return productsJson
            .map(
              (json) => ProductsModel.fromJson({
                ...json,
                'campaignType': campaignType,
                'campaignValue': campaignValue,
              }),
            )
            .toList();
      } else {
        throw Exception(
          'Failed to load campaign products: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching campaign products: $e');
      rethrow;
    }
  }

  // Lấy sản phẩm với giá đã cập nhật theo ID
  static Future<ProductsModel> fetchCampaignProductById(
    String productId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiService.productService}/campaign/updateProductPrice/$productId',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is! Map<String, dynamic> ||
            data['metadata'] == null ||
            data['metadata']['updatedProduct'] == null) {
          throw Exception(
            'Invalid JSON structure: missing metadata or updatedProduct',
          );
        }
        final json = data['metadata']['updatedProduct'];
        final String? campaignType =
            data['metadata']['campaignType']?.toString();
        final double? campaignValue =
            (data['metadata']['campaignValue'] as num?)?.toDouble();

        return ProductsModel.fromJson({
          ...json,
          'campaignType': campaignType,
          'campaignValue': campaignValue,
        });
      } else {
        throw Exception(
          'Failed to load campaign product: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching campaign product by ID: $e');
      rethrow;
    }
  }
}
