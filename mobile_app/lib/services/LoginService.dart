import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {

  static const String _baseUrl = ApiService.identityService;

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Lưu token và user vào SharedPreferences
        final token = data['metadata']['token'];
        final user = data['metadata']['user'];
        final cookie = 'jwt=$token';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user', jsonEncode(user));
        await prefs.setString('cookies', cookie);

        return {
          'success': true,
          'user': user,
          'token': token,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Đăng ký thất bại',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Lấy token và user từ response
        final token = data['metadata']['token'];
        final user = data['metadata']['user'];

        // Tạo cookie với định dạng jwt=<token>
        final cookie = 'jwt=$token';

        // Lưu token và user vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user', jsonEncode(user));
        await prefs.setString('cookies', cookie);

        // Debug: In ra để kiểm tra
        // print('Stored token: $token');
        // print('Stored cookie: $cookie');

        return {
          'success': true,
          'user': user,
          'token': token,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Đăng nhập thất bại',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    final url = Uri.parse('$_baseUrl/logout');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Xóa dữ liệu cục bộ
        final prefs = await SharedPreferences.getInstance();
        await Future.wait([
          prefs.remove('auth_token'),
          prefs.remove('user'),
          prefs.remove('cookies'),
        ]);

        return {'success': true, 'message': 'Đăng xuất thành công'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              data['message'] ??
              'Đăng xuất thất bại (mã ${response.statusCode})',
        };
      }
    } catch (e) {
      print('Logout error: $e'); // Debug
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // get token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    // print('Retrieved token: $token'); // Debug
    return token;
  }

  //get user from SharedPreferences
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }

  // get cookies from SharedPreferences
  static Future<String?> getCookies() async {
    final prefs = await SharedPreferences.getInstance();
    final cookies = prefs.getString('cookies');
    // print('Retrieved cookies: $cookies'); // Debug
    return cookies;
  }
}
