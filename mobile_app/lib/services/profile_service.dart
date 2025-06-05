import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/LoginService.dart';

class ProfileService {
  static const String _baseUrl = ApiService.profileService;

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

  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String gender,
    required String phoneNumber,
    required String dateOfBirth,
  }) async {
    final url = Uri.parse('$_baseUrl/update');
    try {
      final token = await LoginService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      // Chuẩn bị body cho yêu cầu POST
      final body = jsonEncode({
        'fullName': fullName,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'dateOfBirth': dateOfBirth,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Cập nhật thông tin thành công',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Cập nhật thất bại',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
