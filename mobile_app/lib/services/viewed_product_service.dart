import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/LoginService.dart';

class ViewedProductService {

  static const String _baseUrl = ApiService.profileService;


  // Lấy danh sách sản phẩm đã xem
  Future<Map<String, dynamic>> getViewedProducts() async {
    final url = Uri.parse('$_baseUrl/viewedProduct/list');
    try {
      final token = await LoginService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'viewedProducts': data['metadata'] ?? [],
          'message':
              data['message'] ?? 'Lấy danh sách sản phẩm đã xem thành công',
        };
      } else {
        return {
          'success': false,
          'message':
              data['message'] ?? 'Không lấy được danh sách sản phẩm đã xem',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // Thêm sản phẩm đã xem
  Future<Map<String, dynamic>> addViewedProduct(String productId) async {
    final url = Uri.parse('$_baseUrl/viewedProduct/add');
    try {
      final token = await LoginService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      final body = jsonEncode({'productId': productId});

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'viewedProducts': data['metadata'] ?? [],
          'message': data['message'] ?? 'Thêm sản phẩm đã xem thành công',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Thêm sản phẩm đã xem thất bại',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
