import 'package:flutter/material.dart';

//修改密碼、暱稱header
class Header4 extends StatefulWidget {
  final String title;
  final Widget? nextPage;
  const Header4({super.key, required this.title, this.nextPage});

  @override
  State<Header4> createState() => _Header4State();
}

class _Header4State extends State<Header4> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  widget.nextPage == null
                      ? Navigator.pop(context)
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => widget.nextPage!),
                        );
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF669FA5),
                ),
                padding: const EdgeInsets.only(bottom: 17),
              ),
              const SizedBox(width: 20),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF669FA5),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
