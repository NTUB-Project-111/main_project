import 'package:drw/backend/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitlePart extends StatefulWidget {
  const TitlePart({super.key});

  @override
  State<TitlePart> createState() => _TitlePartState();
}

class _TitlePartState extends State<TitlePart> {
  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context, listen: false);
    return Container(
      
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
              Icons.arrow_back,
              color: Color(0xFF669FA5),
            ),
            padding: EdgeInsets.zero, // 移除 padding
            constraints: const BoxConstraints(), // 移除預設大小
          ),
          const Padding(
            padding: EdgeInsets.only(left: 23),
            child: Text(
              '診斷報告',
              style: TextStyle(
                color: Color(0xFF589399),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // 使用系統抓取的日期顯示
          Text(
            report.date,
            style: const TextStyle(
              color: Color(0xFF589399),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
