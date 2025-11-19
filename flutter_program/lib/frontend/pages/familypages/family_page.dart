import 'package:drw/backend/models/family.dart';
import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/provider/family_provider.dart';
import 'package:drw/backend/provider/report_provider.dart';
// import 'package:drw/frontend/pages/familypages/family_dialog.dart';
import 'package:drw/frontend/pages/familypages/healed_part.dart';
import 'package:drw/frontend/pages/familypages/member_dialog.dart';
// import 'package:drw/frontend/pages/familypages/member_dialog.dart';
import 'package:drw/frontend/pages/familypages/remind_part.dart';
// import 'package:drw/frontend/pages/familypages/report_part.dart';
import 'package:drw/frontend/utility/family_record_util.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

//--------------假資料 (之後記得刪掉------------------------
// final List<Map<String, String>> reportList = [
//   {'imageUrl': '', 'date': '10.25', 'woundType': '手術傷口', 'role': '媽'},
//   {'imageUrl': '', 'date': '10.26', 'woundType': '燙傷', 'role': '爸'},
//   {'imageUrl': '', 'date': '10.27', 'woundType': '擦傷', 'role': '妹'},
//   {'imageUrl': '', 'date': '10.28', 'woundType': '割傷', 'role': '弟'},
//   {'imageUrl': '', 'date': '10.25', 'woundType': '割傷', 'role': '媽'},
//   {'imageUrl': '', 'date': '10.26', 'woundType': '燙傷', 'role': '爸'},
//   {'imageUrl': '', 'date': '10.27', 'woundType': '擦傷', 'role': '妹'},
//   {'imageUrl': '', 'date': '10.28', 'woundType': '割傷', 'role': '弟'},
//   {'imageUrl': '', 'date': '10.25', 'woundType': '割傷', 'role': '媽'},
//   {'imageUrl': '', 'date': '10.26', 'woundType': '燙傷', 'role': '爸'},
//   {'imageUrl': '', 'date': '10.27', 'woundType': '擦傷', 'role': '妹'},
//   {'imageUrl': '', 'date': '10.28', 'woundType': '割傷', 'role': '弟'},
// ];

//----------------------------------------
class _FamilyPageState extends State<FamilyPage> {
  int _selectedTopIndex = 0;

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.read<ReportProvider>();
    final reports = reportProvider.reports;
    final familyProvider = context.read<FamilyProvider>();
    final members = familyProvider.members;

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
          style: TextStyle(color: FrontUtil.textColor, fontWeight: FontWeight.bold, fontSize: 20),
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
      body: Column(
        children: [
          // 上方家庭資訊區塊
          Container(
            padding: const EdgeInsets.fromLTRB(23, 20, 23, 0),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
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
                          '家庭人數：${members.length}',
                          style: TextStyle(color: FrontUtil.textColor),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => MemberDialog(
                            userFamily: members,
                          ),
                        );
                        // showDialog(
                        //   context:context,
                        //   builder:(context) => const MemberDialog()
                        // );
                      },
                      icon: Icon(Icons.groups_rounded, color: FrontUtil.textColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 主體內容區
          Expanded(
            child: _selectedTopIndex == 0
                ? _buildReportGrid(reports, members)
                : _selectedTopIndex == 1
                    ? const RemindPart()
                    : const HealedPart(),
          ),

          // 底部三個 icon + 文字按鈕
          Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTopButton('報告', Icons.article, 0),
                _buildTopButton('提醒', Icons.alarm, 1),
                _buildTopButton('癒合', Icons.healing, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 底部選項按鈕
  Widget _buildTopButton(String text, IconData icon, int index) {
    final isSelected = _selectedTopIndex == index;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF9FC3C6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: const Color(0xFF669FA5).withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
        border: Border.all(color: const Color(0xFF669FA5), width: 1),
      ),
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            _selectedTopIndex = index;
          });
        },
        icon: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF669FA5),
          size: 20,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF669FA5),
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // 報告頁 GridView
  Widget _buildReportGrid(List<UserReport> reports, List<UserFamily> members) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 25),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        final dateTime = DateTime.parse(report.date);
        String date = '${dateTime.month}/${dateTime.day}';
        String role = '';
        for (var member in members) {
          if (member.memberId == report.memberId) {
            role = member.role;
          }
        }
        return FamilyRecordCard(
          imageUrl: report.photo,
          date: date,
          woundType: report.type,
          role: role[0],
        );
      },
    );
  }
}
