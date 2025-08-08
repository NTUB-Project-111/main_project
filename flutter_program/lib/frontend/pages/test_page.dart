import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '自我紀錄',
                  style: TextStyle(color: FrontUtil.textColor, fontSize: 20, height: 3),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      '標籤：',
                      style: TextStyle(color: FrontUtil.textColor, fontSize: 16, height: 2),
                    )
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      '描述：',
                      style: TextStyle(color: FrontUtil.textColor, fontSize: 16, height: 2),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
