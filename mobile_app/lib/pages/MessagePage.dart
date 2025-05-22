import 'package:flutter/material.dart';
import 'package:mobile_app/pages/HomePage.dart';
import 'package:mobile_app/services/LoginService.dart';
import 'package:mobile_app/services/message_service.dart';

class MessagePage extends StatefulWidget {
  final String receiverId; // ID của người nhận (CSKH hoặc người dùng khác)
  final String receiverName; // Tên người nhận để hiển thị

  const MessagePage({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Kiểm tra token
    final token = await LoginService.getToken();
    if (token == null) {
      setState(() {
        _errorMessage = 'Vui lòng đăng nhập lại';
        _isLoading = false;
      });
      return;
    }

    // Đặt userId cố định
    _userId = '682f22449b14ebd1d789b682';

    // Khởi tạo WebSocket
    MessageService.initializeSocket(_userId!);
    MessageService.onNewMessage((message) {
      setState(() {
        _messages.add({
          'senderId': message['senderId'],
          'receiverId': message['receiverId'],
          'content': message['content'],
          'image': message['image'],
          'createdAt': message['createdAt'],
        });
      });
    });

    // Lấy danh sách tin nhắn
    await _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await MessageService.getMessages(widget.receiverId);

    if (result['success']) {
      setState(() {
        _messages.clear();
        _messages.addAll(List<Map<String, dynamic>>.from(result['messages']));
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result['message'];
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final text = _controller.text.trim();
    setState(() {
      _controller.clear();
    });

    final result = await MessageService.sendMessage(widget.receiverId, text);

    if (result['success']) {
      setState(() {
        _messages.add(result['messageData']);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    MessageService.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'),
              radius: 18,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverName,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                const Text(
                  '● Đang hoạt động',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_errorMessage!),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _fetchMessages,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child:
                        _messages.isEmpty
                            ? ListView(
                              padding: const EdgeInsets.all(12),
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                          0.75,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Chào bạn! Hôm nay bạn cần giúp gì?',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                final msg = _messages[index];
                                final isUser = msg['receiverId'] == _userId;

                                return Align(
                                  alignment:
                                      isUser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                          0.75,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          isUser
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        if (msg['image'] != null &&
                                            msg['image'].isNotEmpty)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              msg['image'],
                                              width: 200,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.broken_image,
                                                    size: 50,
                                                  ),
                                            ),
                                          ),
                                        if (msg['content'] != null &&
                                            msg['content'].isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color:
                                                  isUser
                                                      ? const Color(0xFF003366)
                                                      : Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              msg['content'],
                                              style: TextStyle(
                                                color:
                                                    isUser
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'Gửi tin nhắn',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _sendMessage,
                          icon: const Icon(Icons.send, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
