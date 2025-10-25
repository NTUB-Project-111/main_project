import 'package:drw/frontend/pages/familypages/family_dialog.dart';
import 'package:drw/frontend/pages/familypages/healed_part.dart';
import 'package:drw/frontend/pages/familypages/remind_part.dart';
import 'package:drw/frontend/pages/familypages/report_part.dart';
import 'package:drw/frontend/utility/family_record_util.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

//--------------假資料 (之後記得刪掉------------------------
final List<Map<String, String>> reportList = [
  {'imageUrl': '', 'date': '10.25', 'woundType': '手術傷口', 'role': '媽'},
  {'imageUrl': '', 'date': '10.26', 'woundType': '燙傷', 'role': '爸'},
  {'imageUrl': '', 'date': '10.27', 'woundType': '擦傷', 'role': '妹'},
  {'imageUrl': '', 'date': '10.28', 'woundType': '割傷', 'role': '弟'},
  {'imageUrl': '', 'date': '10.25', 'woundType': '割傷', 'role': '媽'},
  {'imageUrl': '', 'date': '10.26', 'woundType': '燙傷', 'role': '爸'},
  {'imageUrl': '', 'date': '10.27', 'woundType': '擦傷', 'role': '妹'},
  {'imageUrl': '', 'date': '10.28', 'woundType': '割傷', 'role': '弟'},
  {'imageUrl': '', 'date': '10.25', 'woundType': '割傷', 'role': '媽'},
  {'imageUrl': '', 'date': '10.26', 'woundType': '燙傷', 'role': '爸'},
  {'imageUrl': '', 'date': '10.27', 'woundType': '擦傷', 'role': '妹'},
  {'imageUrl': '', 'date': '10.28', 'woundType': '割傷', 'role': '弟'},
];

//----------------------------------------
class _FamilyPageState extends State<FamilyPage> {
  int _selectedTopIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: FrontUtil.textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '家庭群組',
          style: TextStyle(
              color: FrontUtil.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 2.0,
            color: FrontUtil.textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 頂部卡片
            Container(
              padding: const EdgeInsets.fromLTRB(23, 20, 23, 35),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  // colors: [Color(0xFF7EC2CA), Color(0xFFB8E6EB),Color(0xFFF4FEFF)],
                  colors: [Color(0xFFB8E6EB), Color(0xFFF4FEFF), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // 小熊圖示
                      Container(
                        width: 68,
                        height: 68,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/register_icon.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 家庭名稱與人數
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '我滴家 🏠',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 2,
                                color: Color(0xFF589399)),
                          ),
                          Text(
                            '家庭人數：4', //這裡之後要改成變數呦
                            style: TextStyle(color: FrontUtil.textColor),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const FamilyDialog(),
                            );
                          },
                          icon: Icon(Icons.groups_rounded,
                              color: FrontUtil.textColor)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTopButton('報告集', 0),
                      _buildTopButton('已開啟提醒報告', 1),
                      _buildTopButton('已癒合', 2),
                    ],
                  ),
                ],
              ),
            ),
            // 將報告集區塊包在固定高度的 Container 中
            Container(
              height: 550, // 想依照手機高度進行調整（用比例的，未用。
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _selectedTopIndex == 0
                  ? GridView.builder(
                      physics:
                          const AlwaysScrollableScrollPhysics(), // 這裡 GridView 可以滑動
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: reportList.length,
                      itemBuilder: (context, index) {
                        final report = reportList[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 6), // ✅ 給每個卡片上方空間
                          child: FamilyRecordCard(
                            imageUrl: report['imageUrl'] ?? '',
                            date: report['date'] ?? '',
                            woundType: report['woundType'] ?? '',
                            role: report['role'] ?? '',
                          ),
                        );
                      },
                    )
                  : _selectedTopIndex == 1
                      ? const RemindPart()
                      : const HealedPart(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButton(String text, int index) {
    final isSelected = _selectedTopIndex == index;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedTopIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF9FC3C6) : Colors.white,
        foregroundColor: isSelected ? Colors.white : FrontUtil.textColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: FrontUtil.textColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Text(text),
    );
  }
}
