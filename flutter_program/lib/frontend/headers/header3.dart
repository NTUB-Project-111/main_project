import 'package:flutter/material.dart';

//主畫面header
class Header3 extends StatelessWidget {
  final String title;
  final Icon icon;
  final Widget targetPage;
  const Header3({super.key, required this.title, required this.icon, required this.targetPage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 25,right: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFF589399), width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 2.5,
                color: Color(0xFF669FA5),
              ),
            ),
            IconButton(
              icon: icon,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => targetPage),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
