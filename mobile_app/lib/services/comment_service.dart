// UI Language: Vietnamese
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/LoginService.dart'; // Đảm bảo đúng đường dẫn tới LoginService
import 'package:mobile_app/models/comment_model.dart'; // Import Comment model

class CommentService {
  static const String _baseUrl =
      'http://localhost:9003/v1/api/profile'; // Thay đổi nếu cần

  // Hàm gửi bình luận mới
  Future<Map<String, dynamic>> postComment({
    required String productId,
    required String orderId, // Thêm orderId
    required String comment,
    required int rating,
    // Có thể thêm List<String> images nếu backend hỗ trợ upload ảnh
  }) async {
    final url = Uri.parse('$_baseUrl/comment');
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
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token', // Sử dụng token trong header Authorization
        },
        body: jsonEncode({
          'productId': productId,
          'orderId': orderId, // Thêm orderId vào body
          'comment': comment,
          'rating': rating,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Backend trả về 200 hoặc 201
        return {
          'success': true,
          'message': data['message'] ?? 'Đánh giá thành công',
          'commentData': data['metadata'], // Dữ liệu bình luận trả về
        };
      } else {
        return {
          'success': false,
          'message':
              data['message'] ?? 'Không thể gửi đánh giá. Vui lòng thử lại.',
        };
      }
    } catch (e) {
      // print('Lỗi khi gửi bình luận: $e'); // Log lỗi để debug
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // Hàm lấy danh sách bình luận theo ID sản phẩm
  Future<Map<String, dynamic>> getCommentsByProduct(String productId) async {
    final url = Uri.parse('$_baseUrl/comment/product/get/$productId');
    try {
      final token = await LoginService.getToken();
      final headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = '$token';
      }

      final response = await http.get(url, headers: headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Parse danh sách bình luận từ metadata
        List<Comment> comments =
            (data['metadata'] as List)
                .map((item) => Comment.fromJson(item as Map<String, dynamic>))
                .toList();

        return {
          'success': true,
          'message': data['message'] ?? 'Lấy danh sách bình luận thành công',
          'comments': comments, // Trả về danh sách Comment objects
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không lấy được danh sách bình luận',
        };
      }
    } catch (e) {
      // print('Lỗi khi lấy bình luận theo sản phẩm: $e'); // Log lỗi để debug
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // Hàm lấy danh sách bình luận của người dùng hiện tại
  Future<Map<String, dynamic>> getCommentsByUser() async {
    final url = Uri.parse('$_baseUrl/comment/user/get');
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
          'Authorization': '$token', // Sử dụng token trong header Authorization
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Parse danh sách bình luận từ metadata
        List<Comment> comments =
            (data['metadata'] as List)
                .map((item) => Comment.fromJson(item as Map<String, dynamic>))
                .toList();

        return {
          'success': true,
          'message':
              data['message'] ??
              'Lấy danh sách bình luận của người dùng thành công',
          'comments': comments, // Trả về danh sách Comment objects
        };
      } else {
        return {
          'success': false,
          'message':
              data['message'] ??
              'Không lấy được danh sách bình luận của người dùng',
        };
      }
    } catch (e) {
      // print('Lỗi khi lấy bình luận theo người dùng: $e'); // Log lỗi để debug
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // Hàm xóa bình luận (nếu cần sử dụng)
  Future<Map<String, dynamic>> deleteComment(String commentId) async {
    final url = Uri.parse('$_baseUrl/comment/user/delete/$commentId');
    try {
      final token = await LoginService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token. Vui lòng đăng nhập lại.',
        };
      }

      final response = await http.delete(
        // Sử dụng http.delete
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
          'message': data['message'] ?? 'Xóa bình luận thành công',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể xóa bình luận',
        };
      }
    } catch (e) {
      // print('Lỗi khi xóa bình luận: $e'); // Log lỗi để debug
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
