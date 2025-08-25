import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/frontend/headers/header3.dart';
import 'package:drw/frontend/pages/gallerypages/showreport_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/pages/remind_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TotalPage extends StatefulWidget {
  final List<UserReport> yearlyReports;

  const TotalPage({super.key, required this.yearlyReports});

  @override
  State<TotalPage> createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
  late Map<String, List<UserReport>> monthlyReports;
  late String year;

  @override
  void initState() {
    super.initState();
    _groupImagesByMonth();
  }

  void _groupImagesByMonth() {
    monthlyReports = {};
    if (widget.yearlyReports.isNotEmpty) {
      // 取出第一筆的年份 (因為這頁就是單一年份的紀錄)
      year = widget.yearlyReports.first.date.substring(0, 4);
    } else {
      year = "";
    }

    for (UserReport report in widget.yearlyReports) {
      DateTime date = DateTime.parse(report.date);
      String monthKey = DateFormat('MM月').format(date);

      monthlyReports.putIfAbsent(monthKey, () => []);
      monthlyReports[monthKey]!.add(report);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      body: Column(
        children: [
          const Header3(
            title: "傷口紀錄冊",
            icon: Icon(
              Icons.notifications,
              size: 23,
              color: Color(0xFF589399),
            ),
            targetPage: RemindPage(),
          ),
          Container(
            padding: const EdgeInsets.only(right: 38),
            color: const Color(0xFFCBF0F4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF04555D),
                  ),
                ),
                Text(
                  "$year年",
                  style: const TextStyle(
                      color: Color(0xFF04555D),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 月份由新到舊排序
                    for (var month
                        in monthlyReports.keys.toList()
                          ..sort((a, b) => b.compareTo(a)))
                      _buildMonth(month, monthlyReports[month]!),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonth(String month, List<UserReport> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            month,
            style: const TextStyle(
              height: 3,
              fontSize: 14,
              color: Color(0xFF589399),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4, // 一列4張
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: records.map((record) => _buildImage(record)).toList(),
        ),
      ],
    );
  }

  // Widget _buildImage(UserReport userReport) {
  //   return GestureDetector(
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.grey,
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(10),
  //         child: Image.network(
  //           userReport.photo.toString(),
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     onTap: () {
  //       final extra = isExtra(userReport);
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => ShowReportPage(
  //                     report: userReport,
  //                     isExtra: extra,
  //                   )));
  //     },
  //   );
  // }

  Widget _buildImage(UserReport userReport) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            userReport.photo.toString(),
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: () {
        final extra = isExtra(userReport);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowReportPage(
              report: userReport,
              isExtra: extra,
            ),
          ),
        );
      },
      // onLongPress: () {
      //   FrontUtil.showConfirmDialog(
      //     context,
      //     Colors.red,
      //     "確定要刪除此紀錄嗎？",
      //     null,
      //     "取消",
      //     "刪除",
      //     () {
      //       context.read<ReportProvider>().deleteReport(userReport.id);
      //       FrontUtil.showSuccess('紀錄已刪除!');
      //       setState(() {
      //         _groupImagesByMonth(); // 重新整理 UI
      //       });
      //     },
      //   );
      // },
    );
  }

  bool isExtra(UserReport report) {
    int groupId = report.groupId;
    UserReport? compareReport;
    List<UserReport> userReports = [];
    final reportProvider = context.read<ReportProvider>();
    final reports = reportProvider.reports;
    if (groupId == 0) {
      return false;
    } else {
      for (var r in reports) {
        if (r.groupId == groupId) {
          userReports.add(r);
        }
      }
    }
    compareReport = userReports.first;
    if (report.id == compareReport.id) {
      return false;
    } else {
      return true;
    }
  }
}
