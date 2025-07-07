import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  void _showButtonDialog(
    String text1,
    String text2,
    VoidCallback onTap1,
    VoidCallback onTap2,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color(0xFF589399),
            width: 2,
          ),
        ),
        backgroundColor: const Color(0xFFF5FEFF),
        contentPadding: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // 點完關閉 dialog
                onTap1(); // 執行傳入的第一個方法
              },
              splashColor: const Color(0xFFDFF6F7),
              highlightColor: const Color(0xFFDFF6F7),
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF669FA5))),
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt, color: Color(0xFF589399)),
                    const SizedBox(width: 15),
                    Text(text1, style: const TextStyle(color: Color(0xFF589399), fontSize: 14)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // 點完關閉 dialog
                onTap2(); // 執行傳入的第二個方法
              },
              splashColor: const Color(0xFFDFF6F7),
              highlightColor: const Color(0xFFDFF6F7),
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: double.infinity,
                child: Row(
                  children: [
                    const Icon(Icons.photo, color: Color(0xFF589399)),
                    const SizedBox(width: 15),
                    Text(text2, style: const TextStyle(color: Color(0xFF589399), fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("測試 Care Steps")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _showButtonDialog(
                  '拍攝新照片',
                  '舊照片續拍',
                  () {
                    // 開啟相機的邏輯
                    debugPrint('Camera clicked');
                  },
                  () {
                    // 開啟相簿的邏輯
                    debugPrint('Gallery clicked');
                  },
                );
              },
              child: const Text("測試"),
            ),
          ],
        ),
      ),
    );
  }
}
