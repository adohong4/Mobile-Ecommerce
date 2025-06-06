import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/LoginService.dart';

class FavouriteService {
  static const String _baseUrl = 'http://192.168.1.9:9003/v1/api/profile';

  Future<Map<String, dynamic>> addToFavourite(String itemId) async {
    final url = Uri.parse('$_baseUrl/favourite/add');
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
          'favourites': data['metadata'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể thêm vào yêu thích',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> getListFavourite() async {
    final url = Uri.parse('$_baseUrl/favourite/list');
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
          'favourites': data['metadata'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không lấy được danh sách yêu thích',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> removeFromFavourite(String itemId) async {
    final url = Uri.parse('$_baseUrl/favourite/remove');
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
          'favourites': data['metadata'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể xóa khỏi yêu thích',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
