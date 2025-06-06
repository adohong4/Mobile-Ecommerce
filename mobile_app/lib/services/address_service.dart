import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/addressModel.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/LoginService.dart';

class AddressService {

  static const String _baseUrl = ApiService.address;


  Future<Map<String, dynamic>> createAddress(AddressModel address) async {
    final url = Uri.parse('$_baseUrl/create');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: jsonEncode(address.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (data['metadata'] != null &&
            data['metadata']['address'] is List &&
            (data['metadata']['address'] as List).isNotEmpty) {
          return {
            'success': true,
            'message': data['message'] ?? 'Create address',
            'address': AddressModel.fromJson(
              (data['metadata']['address'] as List).last,
            ),
          };
        } else {
          return {
            'success': false,
            'message': 'Dữ liệu trả về không đúng định dạng',
          };
        }
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể tạo địa chỉ',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getAddresses() async {
    final url = Uri.parse('$_baseUrl/get');
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
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Lấy danh sách địa chỉ từ metadata.address
        final addresses =
            (data['metadata']['address'] as List)
                .map((item) => AddressModel.fromJson(item))
                .toList();
        return {
          'success': true,
          'addresses': addresses,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không lấy được danh sách địa chỉ',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> deleteAddress(String addressId) async {
    final url = Uri.parse('$_baseUrl/delete/$addressId');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể xóa địa chỉ',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> setDefaultAddress(String addressId) async {
    final url = Uri.parse('$_baseUrl/update/$addressId');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể cài đặt mặc định địa chỉ',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
