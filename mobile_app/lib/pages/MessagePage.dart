import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/MessageAppBar.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ListView(children: [MessageAppBar()]));
  }
}
