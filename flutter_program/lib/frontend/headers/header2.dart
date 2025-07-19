import 'package:flutter/material.dart';

//註冊畫面Header
class Header2 extends StatefulWidget {
  final String title;
  final String? subtitle;
  const Header2({super.key, required this.title, this.subtitle});

  @override
  State<Header2> createState() => _Header2State();
}

class _Header2State extends State<Header2> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('images/icon.png', height: 140, fit: BoxFit.fitHeight),
        ),
        const SizedBox(width: 25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF669FA5), fontSize: 40),
            ),
            if (widget.subtitle != null)
              Text(
                widget.subtitle!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF669FA5), fontSize: 16),
              ),
          ],
        ),
      ],
    );
  }
}
