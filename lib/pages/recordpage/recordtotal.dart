import 'package:flutter/material.dart';
import 'package:wounddetection/my_flutter_app_icons.dart';
import '../headers/header_1.dart';
import '../remindpage.dart';

class TotalPage extends StatefulWidget {
  const TotalPage({super.key});

  @override
  State<TotalPage> createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEBFEFF),
        body: Column(
          children: [
            const HeaderPage1(
              title: "傷口紀錄冊",
              icon: Icon(
                MyFlutterApp.bell,
                size: 23,
                color: Color(0xFF589399),
              ),
              targetPage: RemindPage(),
            ),
            Container(
              padding: const EdgeInsets.only(right: 38),
              color: const Color(0xFFCBF0F4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      MyFlutterApp.icon_park_solid__back,
                      color: Color(0xFF04555D),
                    ),
                  ),
                  const Text(
                    "2025年",
                    style: TextStyle(
                        color: Color(0xFF04555D), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox()
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonth('12月',5),
                    _buildMonth('11月',7),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildMonth(String month,int len) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          month,
          style: const TextStyle(
            height: 3,
            fontSize: 14,
            color: Color(0xFF589399),
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          children: [
            for (int i = 1; i <= len; i++) _buildImage(),
          ],
        )
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
      height: 82,
      width: 82,
    );
  }
}
