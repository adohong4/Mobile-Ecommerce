import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/LoginService.dart';

class CartService {
  static const String _baseUrl = 'http://localhost:9003/v1/api/profile';

  Future<Map<String, dynamic>> addToCart(String itemId) async {
    final url = Uri.parse('$_baseUrl/cart/add');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      final cookie = 'jwt=$token';
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode({'itemId': itemId}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'cartData': data['metadata'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể thêm vào giỏ hàng',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> getListCart() async {
    final url = Uri.parse('$_baseUrl/cart/list');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      final cookie = 'jwt=$token';
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
          'cartData': data['metadata'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không lấy được danh sách giỏ hàng',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> removeFromCart(String itemId) async {
    final url = Uri.parse('$_baseUrl/cart/remove');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      final cookie = 'jwt=$token';
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode({'itemId': itemId}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'cartData': data['metadata'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể xóa khỏi giỏ hàng',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> getUserOrders() async {
    final url = Uri.parse('$_baseUrl/order/list');
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
          'orders': data['metadata'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không lấy được danh sách đơn hàng',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
