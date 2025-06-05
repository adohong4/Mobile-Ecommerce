import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/voucher_model.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/LoginService.dart';

class VoucherService {
  static const String _baseUrl = ApiService.voucher;

  Future<Map<String, dynamic>> getVoucherById(String voucherId) async {
    final url = Uri.parse('$_baseUrl/get/$voucherId');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Không tìm thấy token'};
      }

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 200) {
        return {
          'success': true,
          'voucher': VoucherModel.fromJson(data['metadata']),
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể lấy thông tin voucher',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> useVoucher(String voucherId) async {
    final url = Uri.parse('$_baseUrl/use/$voucherId');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Không tìm thấy token'};
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể sử dụng voucher',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> getUserVoucherList() async {
    final url = Uri.parse('$_baseUrl/user');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Không tìm thấy token'};
      }

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 200) {
        final vouchers =
            (data['metadata'] as List)
                .map((item) => VoucherModel.fromJson(item))
                .toList();
        return {
          'success': true,
          'vouchers': vouchers,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể lấy danh sách voucher',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> addVoucherToUser(String voucherId) async {
    final url = Uri.parse('$_baseUrl/pushUser');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Không tìm thấy token'};
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: jsonEncode({'voucherId': voucherId}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể thêm voucher',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
