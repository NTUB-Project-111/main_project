import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

//註冊及免責畫面的header
class Header6 extends StatefulWidget {
  final String title;
  final Icon? icon;

  const Header6({super.key, required this.title, this.icon});

  @override
  State<Header6> createState() => _Header6State();
}

class _Header6State extends State<Header6> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: FrontUtil.textColor, width: 2),
        ),
      ),
      child: Row(
        children: [
          if (widget.icon != null)
            IconButton(
              icon: widget.icon!,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          else
            const SizedBox(width: 48), // 保留空間對齊

          // 中間標題
          Expanded(
            child: Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  letterSpacing: 2.5,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 2.5,
                  color: Color(0xFF669FA5),
                ),
              ),
            ),
          ),

          // 右邊保留空間讓標題置中
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
