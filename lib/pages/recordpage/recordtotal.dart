import 'package:flutter/material.dart';
import 'package:wounddetection/my_flutter_app_icons.dart';
import '../../feature/database.dart';
import '../headers/header_1.dart';
import '../remindpage.dart';
import 'package:intl/intl.dart';

import 'reportpage.dart';

class TotalPage extends StatefulWidget {
  final List<Map<String, dynamic>> yearlyImage;

  const TotalPage({super.key, required this.yearlyImage});

  @override
  State<TotalPage> createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
  late Map<String, List<Map<String, dynamic>>> monthlyImages;

  @override
  void initState() {
    super.initState();
    _groupImagesByMonth();
  }

  void _groupImagesByMonth() {
    monthlyImages = {};
    for (var image in widget.yearlyImage) {
      DateTime date = DateTime.parse(image['date']);
      String monthKey = DateFormat('MM月').format(date);

      if (!monthlyImages.containsKey(monthKey)) {
        monthlyImages[monthKey] = [];
      }
      monthlyImages[monthKey]!.add(image);
    }
  }

  void _showConfirmationDialog(String img, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: const Color(0xFFF5FEFF),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    Uri.parse(DatabaseHelper.baseUrl).resolve(img).toString(),
                    height: 300,
                    width: 280,
                    fit: BoxFit.cover,
                  )),
              Wrap(
                children: [
                  Text(
                    "#$type",
                    style: const TextStyle(
                        color: Color(0xFF589399), height: 3, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      body: Column(
        children: [
          const HeaderPage1(
              title: "傷口紀錄冊",
              icon: Icon(
                MyFlutterApp.bell,
                size: 23,
                color: Color(0xFF589399),
              ),
              targetPage: RemindPage()),
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
                    MyFlutterApp.icon_park_solid__back,
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
                    for (var month in monthlyImages.keys.toList()..sort())
                      _buildMonth(month, monthlyImages[month]!),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonth(String month, List<Map<String, dynamic>> images) {
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
          children: images.map((image) => _buildImage(image['photo'], image)).toList(),
        ),
      ],
    );
  }

  Widget _buildImage(String imageUrl, Map<String, dynamic> record) {
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
              Uri.parse(DatabaseHelper.baseUrl).resolve(imageUrl).toString(),
              width: 82,
              height: 82,
              fit: BoxFit.cover,
            )),
      ),
      onLongPress: () {
        _showConfirmationDialog(imageUrl, record['type']);
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportPage(
                      record: record,
                    )));
      },
    );
  }
}
