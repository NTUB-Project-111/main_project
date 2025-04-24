import 'package:flutter/material.dart';
import 'package:wounddetection/pages/remindpage.dart';

//首頁header
class HeaderPage3 extends StatefulWidget {
  final Icon? icon;
  const HeaderPage3({super.key, this.icon});

  @override
  State<HeaderPage3> createState() => _HeaderPage3State();
}

class _HeaderPage3State extends State<HeaderPage3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 36, 20, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Icon(MyFlutterApp.bell,color: Color(0xFF669FA5),),
              Image.asset(
                'images/icon.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Text(
                'Dr. W',
                style: TextStyle(
                  color: Color(0xFF669FA5),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          widget.icon == null
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const RemindPage()));
                  },
                  icon: widget.icon!), //若widget.icon有值則widget.icon，否則顯示sizedbox
        ],
      ),
    );
  }
}
