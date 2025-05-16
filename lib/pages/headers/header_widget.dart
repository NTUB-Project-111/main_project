import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeaderWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('images/icon_nobkg.png',
              height: 135, fit: BoxFit.fitHeight),
        ),
        const SizedBox(width: 25),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Rubik Dirt',
                color: Color(0xFF669FA5),
              ),
              children: [
                TextSpan(text: "$title\n"),
                TextSpan(text: subtitle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
