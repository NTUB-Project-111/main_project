import 'package:flutter/material.dart';

import '../headers/header_3.dart';
import '../resultpages/result_1.dart';
import '../resultpages/result_3.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<String> _tags = ['手部', '刺痛'];

  Widget _buildTagChip(List<String> list) {
    return Wrap(
      children: list.map((text) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.only(right: 5), // 可以加上 margin 讓每個 Container 之間有間距
          decoration: BoxDecoration(
            color: const Color(0xFF589399),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      }).toList(), // 轉換為 List
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEBFEFF),
        body: Column(children: [
          const HeaderPage3(),
          const ResultPage1(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Color(0xFF589399),
                        width: 2,
                      ))),
                      height: 230,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('images/1.png', width: 180, fit: BoxFit.cover),
                            ),
                          ),
                          // const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    48, 4, 48, 4), //對稱的內間距，讓Container與裡面的子元素的上下間距為n，左右間距為m
                                decoration: BoxDecoration(
                                  color: const Color(0xFF589399).withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "傷口類型",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const Text(
                                '割傷',
                                style: TextStyle(
                                  color: Color(0xFF589399),
                                  fontSize: 50,
                                ),
                              ),
                              const SizedBox(
                                width: 180,
                                child: Row(
                                  children: [
                                    Text(
                                      '預計癒合時間',
                                      style: TextStyle(
                                        color: Color(0xFF589399),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      ' X~X ',
                                      style: TextStyle(
                                        color: Color(0xFF589399),
                                        fontSize: 26,
                                      ),
                                    ),
                                    Text(
                                      '天',
                                      style: TextStyle(
                                        color: Color(0xFF589399),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const ResultPage3(resultinfo: ['xxxxxxx', 'xxxxx']),
                    const Text(
                      '自我紀錄',
                      style: TextStyle(color: Color(0xFF589399), fontSize: 22, height: 3),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 1)]),
                      child: _buildTagChip(_tags),
                    ),
                    Container(
                      width: double.infinity,
                      height: 250,
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 1)]),
                      child: const Text("xxxxxxxxx",style:TextStyle(color:Colors.grey)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: const Color(0xFF589399),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              '確定',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
