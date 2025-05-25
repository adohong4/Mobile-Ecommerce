import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/LoginService.dart';

class ProfileService {
  static const String _baseUrl = 'http://192.168.1.9:9003/v1/api/profile';

  Future<Map<String, dynamic>> getProfile() async {
    final url = Uri.parse('$_baseUrl/get');
    try {
      // Lấy token từ SharedPreferences
      final token = await LoginService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      // Tạo cookie với định dạng jwt=<token>
      final cookieHeaderValue = 'jwt=$token';
      // print('DEBUG: Cookie header value to be sent: $cookieHeaderValue');

      // Gửi yêu cầu API với cookie
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      // print("$response");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Lấy dữ liệu profile từ metadata[0]
        final profileData = data['metadata'][0];
        return {
          'success': true,
          'profile': profileData,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không lấy được hồ sơ',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
