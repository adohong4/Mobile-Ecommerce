import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            'https://example.com/profile_picture.jpg',
          ),
        ),
      ),
    );
  }
}
