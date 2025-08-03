import 'package:drw/backend/services/careinfo_gpt.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Map<String, dynamic>? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (result != null && result!['careSteps'] != null)
                ..._buildAllWoundSections(result!['careSteps'] as Map<String, List<String>>),
              if (result != null && result!['healingTime'] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '癒合時間：${result!['healingTime']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ElevatedButton(
                onPressed: () async {
                  final r = await _analyzeWoundImage();
                  setState(() {
                    result = r;
                  });
                },
                child: const Text('取得建議'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAllWoundSections(Map<String, List<String>> steps) {
    return steps.entries.map((entry) {
      final title = entry.key;
      final details = entry.value;
      return _buildWoundSection(title, details);
    }).toList();
  }

  Widget _buildWoundSection(String title, List<String> contents) {
    bool show = false;
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.fromLTRB(20, 5, 5, 3),
            width: double.infinity,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    setState(() => show = !show);
                  },
                  icon: Icon(show ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ),
              ],
            ),
          ),
          if (show)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contents
                    .map((line) => Text('• ${line.replaceAll(RegExp(r'\s+'), '')}'))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  /// 🔹 呼叫 GPT API 並回傳結果
  Future<Map<String, dynamic>?> _analyzeWoundImage() async {
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
