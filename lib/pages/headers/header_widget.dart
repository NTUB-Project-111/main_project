import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;

  const HeaderWidget({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('images/icon_nobkg.png', height: 140, fit: BoxFit.fitHeight),
        ),
        const SizedBox(width: 25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF669FA5),fontSize: 40),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF669FA5),fontSize: 16),
              ),
          ],
        ),
        // Expanded(
        //   child: RichText(
        //     text: TextSpan(
        //       style: const TextStyle(
        //         fontSize: 40,
        //         fontWeight: FontWeight.bold,
        //         fontFamily: 'Rubik Dirt',
        //         color: Color(0xFF669FA5),
        //       ),
        //       children: [
        //         TextSpan(text: "$title\n",style:TextStyle(background: Paint())),
        //         if (subtitle != null)
        //           TextSpan(
        //             text: subtitle,
        //             style: TextStyle(fontSize: 14,background: Paint()),
        //           ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
