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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [_buildWoundSection()],
        ),
      ),
    );
  }

  Widget _buildWoundSection() {
    return Container(
      color: FrontUtil.bkColor,
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 82,
            height: 82,
            color: Colors.grey,
            margin: const EdgeInsets.all(10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '使用者取的傷口名稱',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: FrontUtil.textColor, // 深藍綠
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '2025/07/20',
                  style: TextStyle(
                    fontSize: 14,
                    color: FrontUtil.textColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF86BCA1), // 綠色背景
              shape: BoxShape.circle,
            ),
            child: const Text(
              '擦',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
