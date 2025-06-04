import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/LoginService.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageService {
  static const String _baseUrl = 'http://localhost:9002/v1/api/message';
  static IO.Socket? _socket;

  // Khởi tạo WebSocket
  static void initializeSocket(String userId) {
    _socket = IO.io('http://localhost:9002', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket?.connect();
    _socket?.emit('addUser', userId);

    _socket?.onConnect((_) {
      print('Connected to WebSocket');
    });

    _socket?.onDisconnect((_) {
      print('Disconnected from WebSocket');
    });
  }

  // Lắng nghe tin nhắn mới
  static void onNewMessage(Function(Map<String, dynamic>) callback) {
    _socket?.on('newMessage', (data) {
      callback(data);
    });
  }

  // Ngắt kết nối WebSocket
  static void disconnectSocket() {
    _socket?.disconnect();
    _socket = null;
  }

  // Gửi tin nhắn
  static Future<Map<String, dynamic>> sendMessage(
    String receiverId,
    String text, {
    String? image,
  }) async {
    final url = Uri.parse('$_baseUrl/send/$receiverId');
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
        body: jsonEncode({'text': text, if (image != null) 'image': image}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'messageData': data['metadata'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể gửi tin nhắn',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // Lấy danh sách tin nhắn
  static Future<Map<String, dynamic>> getMessages(String userToChatId) async {
    final url = Uri.parse('$_baseUrl/get/$userToChatId');
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
          'messages': data['metadata'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không lấy được danh sách tin nhắn',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
