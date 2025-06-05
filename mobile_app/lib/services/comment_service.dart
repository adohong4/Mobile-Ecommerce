import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/comment_model.dart';
import 'package:mobile_app/services/LoginService.dart';

class CommentService {
  static const String _baseUrl = 'http://localhost:9003/v1/api/profile';

  Future<Map<String, dynamic>> postComment({
    required String productId,
    required String orderId,
    required String comment,
    required int rating,
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
          'Authorization': '$token',
        },
        body: jsonEncode({
          'productId': productId,
          'orderId': orderId,
          'comment': comment,
          'rating': rating,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'message': data['message'] ?? 'Đánh giá thành công',
          'commentData': data['metadata'],
        };
      } else {
        return {
          'success': false,
          'message':
              data['message'] ?? 'Không thể gửi đánh giá. Vui lòng thử lại.',
        };
      }
    } catch (e) {
      debugPrint('Error posting comment: $e');
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> getRatingStatsAndComments(
    String productId,
  ) async {
    final url = Uri.parse('$_baseUrl/comment/product/rate/$productId');
    try {
      final token = await LoginService.getToken();
      final headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = '$token';
      }

      final response = await http.get(url, headers: headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final metadata = data['metadata'] as Map<String, dynamic>?;
        if (metadata == null) {
          return {
            'success': false,
            'message': 'Dữ liệu trả về không hợp lệ: thiếu metadata',
            'ratingStats': {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
            'averageRating': 0.0,
            'comments': [],
          };
        }

        final ratingStats = Map<String, int>.from(
          metadata['ratingStats'] ?? {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
        );
        final averageRating =
            (metadata['averageRating'] as num?)?.toDouble() ?? 0.0;
        final comments =
            (metadata['comments'] as List<dynamic>?)
                ?.map((item) => Comment.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [];

        return {
          'success': true,
          'message': data['message'] ?? 'Lấy thông tin thành công',
          'ratingStats': ratingStats,
          'averageRating': averageRating,
          'comments': comments,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không lấy được thông tin',
          'ratingStats': {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
          'averageRating': 0.0,
          'comments': [],
        };
      }
    } catch (e) {
      debugPrint('Error fetching rating stats and comments: $e');
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
        'ratingStats': {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
        'averageRating': 0.0,
        'comments': [],
      };
    }
  }

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
          'Authorization': '$token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final comments =
            (data['metadata'] as List<dynamic>?)
                ?.map((item) => Comment.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [];
        return {
          'success': true,
          'message': data['message'] ?? 'Lấy danh sách bình luận thành công',
          'comments': comments,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không lấy được danh sách bình luận',
        };
      }
    } catch (e) {
      debugPrint('Error fetching user comments: $e');
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

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
          'message': data['message'] ?? 'Không thể xóa bình luận.',
        };
      }
    } catch (e) {
      debugPrint('Error deleting comment: $e');
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> getUserById(String userId) async {
    final url = Uri.parse('$_baseUrl/userComment/$userId');
    try {
      final token = await LoginService.getToken();
      final headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = '$token';
      }

      final response = await http.get(url, headers: headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Lấy thông tin người dùng thành công',
          'user': data['metadata'] ?? {},
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không lấy được thông tin người dùng',
        };
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
