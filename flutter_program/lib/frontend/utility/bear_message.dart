import 'package:flutter/material.dart';
import 'package:drw/frontend/utility/front_util.dart';

class BearWithTextBox extends StatelessWidget {
  final String text;
  final double bearSize;
  final double spacing;

  const BearWithTextBox({
    super.key,
    required this.text,
    this.bearSize = 110,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: const Offset(0, 10), // ✅ 將圖片往下壓貼近文字框
          child: Image.asset(
            'images/nurse_bear.png',
            width: 110,
            height: 110,
          ),
        ),
        // SizedBox(height: spacing),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: FrontUtil.textColor, width: 1.5),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: FrontUtil.textColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
