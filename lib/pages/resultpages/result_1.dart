import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 用於格式化日期
import 'package:wounddetection/my_flutter_app_icons.dart';

class ResultPage1 extends StatefulWidget {
  const ResultPage1({super.key});

  @override
  State<ResultPage1> createState() => _ResultPage1State();
}

class _ResultPage1State extends State<ResultPage1> {
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    // 初始化抓取當前日期
    formattedDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF589399),
                width: 2,
              ),
            ),
          ),
          height: 55,
          // padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  MyFlutterApp.icon_park_solid__back,
                  color: Color(0xFF669FA5),
                ),
                padding: EdgeInsets.zero, // 移除 padding
                constraints: const BoxConstraints(), // 移除預設大小
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  '診斷報告',
                  style: TextStyle(
                    color: Color(0xFF589399),
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // 使用系統抓取的日期顯示
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
