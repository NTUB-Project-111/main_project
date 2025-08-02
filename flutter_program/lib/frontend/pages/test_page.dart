import 'package:drw/backend/services/careinfo_gpt.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String result = ''; // ✅ 將 result 移到 build 之外，成為 state 成員變數

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(result),
            ),
            ElevatedButton(
              onPressed: () async {
                final map = await _analyzeWoundImage();
                setState(() {
                  result = map;
                });
                            },
              child: const Text('取得建議'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _analyzeWoundImage() async {
    return await CareInfo.getCareSteps(
      '割傷',
      '2000',
      '糖尿病',
      '無、無、無',
      false,
      '15~20天',
      '2025',
    );
  }
}
