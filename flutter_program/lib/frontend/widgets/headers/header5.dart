import 'package:drw/frontend/pages/remind_page.dart';
import 'package:flutter/material.dart';

//首頁header
class Header5 extends StatefulWidget {
  final Icon? icon;
  const Header5({super.key, this.icon});

  @override
  State<Header5> createState() => _Header5State();
}

class _Header5State extends State<Header5> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'images/icon.png',
                height: 45,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Text(
                'Dr. W',
                style: TextStyle(
                  color: Color(0xFF669FA5),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 3
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
