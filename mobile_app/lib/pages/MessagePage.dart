import 'package:flutter/material.dart';
import 'package:mobile_app/pages/HomePage.dart';
class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [
    {'sender': 'bot', 'text': 'Chào bạn! Hôm nay bạn cần giúp gì?'},
    {'sender': 'user', 'text': 'xin chào'},
    {'sender': 'user', 'text': 'tôi đang học IT, thì có những chiếc laptop nào phù hợp với tôi'},
    {
      'sender': 'bot',
      'text':
      'Bạn học IT, nên một chiếc laptop phù hợp cần có hiệu năng tốt, bền bỉ và hỗ trợ tốt cho lập trình, máy ảo, đồ hoạ hoặc các công nghệ bạn đang theo đuổi. Dưới đây là một số lựa chọn phù hợp theo từng nhu cầu:\n• MacBook Air M2 / MacBook Pro M2/M3\n• Dell XPS 17 (RTX 4060/4070)\n• Asus ROG Strix Scar 16/18 (RTX 4080/4090)'
    },
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': _controller.text.trim()});
      _controller.clear();
    });

    // Giả lập phản hồi bot
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        messages.add({
          'sender': 'bot',
          'text': 'Cảm ơn bạn! Chúng tôi sẽ sớm hỗ trợ thêm cho bạn.'
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Chuyển hướng về trang chủ
            );
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'),
              radius: 18,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Dịch vụ chăm sóc khách hàng',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  '● Đang hoạt động',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg['sender'] == 'user';

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Color(0xFF003366) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Gửi tin nhắn',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
