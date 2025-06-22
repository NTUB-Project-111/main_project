import 'package:flutter/material.dart';

//註冊及免責畫面的header
class Header1 extends StatefulWidget {
  final String title;
  final Icon? icon;
  final Widget? targetPage;

  const Header1({super.key, required this.title, this.icon, this.targetPage});

  @override
  State<Header1> createState() => _Header1State();
}

class _Header1State extends State<Header1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFF589399), width: 2),
          ),
        ),
        child: Row(
          children: [
            if (widget.icon != null && widget.targetPage != null)
              IconButton(
                icon: widget.icon!,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => widget.targetPage!),
                  );
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
                    fontSize: 22,
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
      ),
    );
  }
}
