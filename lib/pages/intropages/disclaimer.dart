import 'package:flutter/material.dart';
import '../loginpages/login.dart'; // ✅ 引入登入畫面

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF669FA5)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "免責聲明",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF669FA5),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "1. WoundCC 應用程式內所載的資料及材料僅供一般性資訊、教育及參考之用。\n"
                "2. WoundCC 並沒有對應用程式內的任何方面（包括但不限於其準確性、完整性及時效性）作出擔保。\n"
                "使用應用程式即表示您同意此免責聲明。",
                style: TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // ❌ 按下不同意就回到上一頁
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      side: const BorderSide(color: Color(0xFF669FA5)),
                    ),
                    child: const Text(
                      "不同意",
                      style: TextStyle(color: Color(0xFF669FA5)),
                    ),
                  ),
ElevatedButton(
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF669FA5),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  ),
  child: const Text(
    "同意",
    style: TextStyle(color: Colors.white),
  ),
),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}