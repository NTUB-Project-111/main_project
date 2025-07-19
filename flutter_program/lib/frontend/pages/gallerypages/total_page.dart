import 'package:drw/backend/models/report.dart';
// import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/headers/header3.dart';
import 'package:drw/frontend/pages/gallerypages/showreport_page.dart';
import 'package:drw/frontend/pages/remind_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalPage extends StatefulWidget {
  final List<UserReport> yearlyReports;

  const TotalPage({super.key, required this.yearlyReports});

  @override
  State<TotalPage> createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
  late Map<String, List<UserReport>> monthlyReports;

  @override
  void initState() {
    super.initState();
    _groupImagesByMonth();
  }

  void _groupImagesByMonth() {
    monthlyReports = {};
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
                const Text(
                  "2025年",
                  style: TextStyle(
                      color: Color(0xFF04555D), fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var month in monthlyReports.keys.toList()..sort())
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
        Text(
          month,
          style: const TextStyle(
            height: 3,
            fontSize: 14,
            color: Color(0xFF589399),
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          children: records.map((record) => _buildImage(record.photo, record)).toList(),
        ),
      ],
    );
  }

  Widget _buildImage(String imageUrl, UserReport userReport) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 82,
        width: 82,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl.toString(),
            width: 82,
            height: 82,
            fit: BoxFit.cover,
          ),
          // child: Image.network(
          //   Uri.parse(ApiBase.baseUrl).resolve(imageUrl).toString(),
          //   width: 82,
          //   height: 82,
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowReportPage(report: userReport),
          ),
        );
      },
    );
  }
}
