import 'package:flutter/material.dart';

class MessageAppBar extends StatelessWidget {
  const MessageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // go back to the previous screen
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, size: 30, color: Color(0xFF4C53A5)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Tin nhắn",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
          ),
          Spacer(),
          Icon(Icons.more_vert, size: 30, color: Color(0xFF4C53A5)),
        ],
      ),
    );
  }
}
