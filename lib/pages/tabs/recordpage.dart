import 'package:flutter/material.dart';
import 'package:wounddetection/my_flutter_app_icons.dart';
import 'package:wounddetection/pages/recordpage/recordtotal.dart';
import '../headers/header_1.dart';
import '../recordpage/reportpage.dart';
import '../remindpage.dart';
import '../../feature/database.dart';

// import 'package:cached_network_image/cached_network_image.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with SingleTickerProviderStateMixin {
  late TabController _tabController; //等一下才要賦予值，所以是late型態
  List<Map<String, dynamic>>? userRecords = DatabaseHelper.allRecords.reversed.toList();
  // bool isLoading = true;

  //是生命週期函數
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // _getRecords();
  }

  // Future<void> _getRecords() async {
  //   List<Map<String, dynamic>>? records = await DatabaseHelper.getUserRecords();

  //   setState(() {
  //     userRecords = records ?? [];
  //     userRecords != [] ? userRecords!.sort((a, b) => b['date'].compareTo(a['date'])) : null;
  //     // print(userRecords);
  //     isLoading = false;
  //   });
  // }

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
    // 分類 userRecords
    List<Map<String, dynamic>> cutWounds = [];
    List<Map<String, dynamic>> abrasions = [];
    List<Map<String, dynamic>> bruises = [];
    List<Map<String, dynamic>> burns = [];

    if (userRecords != null) {
      for (var record in userRecords!) {
        switch (record['type']) {
          case '割傷':
            cutWounds.add(record);
            break;
          case '擦傷':
            abrasions.add(record);
            break;
          case '瘀青':
            bruises.add(record);
            break;
          case '燒傷':
            burns.add(record);
            break;
        }
      }
    }

    return Column(
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
          color: const Color(0xFFCBF0F4),
          child: TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            labelColor: const Color(0xFF04555D),
            unselectedLabelColor: Colors.blueGrey,
            controller: _tabController,
            indicatorColor: const Color(0xFF04555D),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            tabs: const [
              Tab(text: ("全部")),
              Tab(text: ("割傷")),
              Tab(text: ("擦傷")),
              Tab(text: ("瘀青")),
              Tab(text: ("燒傷")),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              _buildImagePage(userRecords), // 全部
              _buildImagePage(cutWounds), // 割傷
              _buildImagePage(abrasions), // 擦傷
              _buildImagePage(bruises), // 瘀青
              _buildImagePage(burns), // 燒傷
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePage(List<Map<String, dynamic>>? records) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "近期傷口",
              style: TextStyle(color: Color(0xFF589399), fontWeight: FontWeight.w700, height: 3),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: records?.map((record) => _buildRecentImage(record)).toList() ?? [],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFF589399)),
            _buildYearlyImage('2025', records),
            _buildYearlyImage('2024', records),
            _buildYearlyImage('2023', records),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentImage(Map<String, dynamic> record) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          GestureDetector(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 82,
                height: 82,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // 設定圓角半徑 (可自行調整)
                    child: Image.network(
                      Uri.parse(DatabaseHelper.baseUrl).resolve(record['photo']).toString(),
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                    )
                    )),
            onLongPress: () {
              _showConfirmationDialog(record['photo'], record['type']);
              // _showWoundDialog();
            },
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReportPage(
                            record: record,
                          )));
            },
          ),
          Text(
            record['date'],
            style: const TextStyle(
              color: Color(0xFF589399),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildYearlyImage(String y, List<Map<String, dynamic>>? records) {
    // 篩選出該年份的記錄
    List<Map<String, dynamic>> yearlyRecords = records?.where((record) {
          return record['date'].toString().startsWith(y);
        }).toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$y年',
              style: const TextStyle(color: Color(0xFF589399), fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TotalPage(
                              yearlyImage: yearlyRecords,
                            )));
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(70, 25),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "更多",
                    style: TextStyle(
                      color: Color(0xFF589399),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF589399),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height: 200,
          child: yearlyRecords.isEmpty
              ? Center(
                  child: Text(
                    '無 $y 年的傷口紀錄',
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                )
              : Row(
                  children: [
                    // 左側大圖片
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (yearlyRecords.isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportPage(
                                          record: yearlyRecords[0],
                                        )));
                          }
                        },
                        onLongPress: () {
                          _showConfirmationDialog(
                              yearlyRecords[0]['photo'], yearlyRecords[0]['type']);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              Uri.parse(DatabaseHelper.baseUrl)
                                  .resolve(yearlyRecords[0]['photo'])
                                  .toString(),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 右側小圖片區域
                    Expanded(
                      child: yearlyRecords.length > 1
                          ? Column(
                              children: [
                                // 右側上方兩張圖片
                                Expanded(
                                  child: Row(
                                    children: [
                                      if (yearlyRecords.length > 1)
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ReportPage(
                                                            record: yearlyRecords[1],
                                                          )));
                                            },
                                            onLongPress: () {
                                              _showConfirmationDialog(yearlyRecords[1]['photo'],
                                                  yearlyRecords[1]['type']);
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                Uri.parse(DatabaseHelper.baseUrl)
                                                    .resolve(yearlyRecords[1]['photo'])
                                                    .toString(),
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (yearlyRecords.length > 2) const SizedBox(width: 10),
                                      if (yearlyRecords.length > 2)
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ReportPage(
                                                            record: yearlyRecords[2],
                                                          )));
                                            },
                                            onLongPress: () {
                                              _showConfirmationDialog(yearlyRecords[2]['photo'],
                                                  yearlyRecords[2]['type']);
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                Uri.parse(DatabaseHelper.baseUrl)
                                                    .resolve(yearlyRecords[2]['photo'])
                                                    .toString(),
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10), // 間距
                                // 右側下方單獨一張圖片
                                if (yearlyRecords.length > 3)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ReportPage(
                                                      record: yearlyRecords[3],
                                                    )));
                                      },
                                      onLongPress: () {
                                        _showConfirmationDialog(
                                            yearlyRecords[3]['photo'], yearlyRecords[3]['type']);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          Uri.parse(DatabaseHelper.baseUrl)
                                              .resolve(yearlyRecords[3]['photo'])
                                              .toString(),
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : const Center(
                              // 若只有一筆資料，右側顯示 "無其他紀錄"
                              child: Text(
                                '無更多記錄',
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
