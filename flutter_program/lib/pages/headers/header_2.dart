import 'package:flutter/material.dart';
import '../../my_flutter_app_icons.dart';

//我的header
class HeaderPage2 extends StatefulWidget {
  final String title;
  final Widget? nextPage;
  const HeaderPage2({super.key, required this.title, this.nextPage});

  @override
  State<HeaderPage2> createState() => _HeaderPage2State();
}

class _HeaderPage2State extends State<HeaderPage2> {
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
                    : Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => widget.nextPage!),
                      );
                },
                icon: const Icon(
                  MyFlutterApp.icon_park_solid__back,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Image.asset('images/dash.png'),
        ),
      ],
    );
  }
}
