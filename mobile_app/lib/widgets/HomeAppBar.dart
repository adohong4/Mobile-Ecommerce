import 'package:flutter/material.dart';
import 'package:mobile_app/pages/SearchPage.dart';
import 'package:mobile_app/pages/MessagePage.dart';
import 'dart:async';

class AnimatedSearchText extends StatefulWidget {
  const AnimatedSearchText({super.key});

  @override
  _AnimatedSearchTextState createState() => _AnimatedSearchTextState();
}

class _AnimatedSearchTextState extends State<AnimatedSearchText> {
  final List<String> _texts = [
    "Máy làm mát không khí",
    "Điều hòa mini",
    "Tủ đông Hòa Phát",
  ];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _texts.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Text(
        _texts[_currentIndex],
        key: ValueKey<int>(_currentIndex),
        style: TextStyle(color: Colors.black, fontSize: 15),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Color(0xFF4C53A5),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: const AnimatedSearchText()),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF4C53A5),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 15),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const MessagePage(
                      receiverId: '682f22449b14ebd1d789b682', //ID
                      receiverName: 'Dịch vụ chăm sóc khách hàng',
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.mark_chat_unread_outlined,
                color: Color(0xFF4C53A5),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
