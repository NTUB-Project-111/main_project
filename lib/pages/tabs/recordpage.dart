import 'package:flutter/material.dart';
import 'package:wounddetection/my_flutter_app_icons.dart';
import 'package:wounddetection/pages/recordpage/recordtotal.dart';
import '../headers/header_1.dart';
import '../recordpage/reportpage.dart';
import '../remindpage.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with SingleTickerProviderStateMixin {
  late TabController _tabController; //等一下才要賦予值，所以是late型態

  //是生命週期函數
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void _showConfirmationDialog() {
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
                child: Image.asset(
                  // width: double.maxFinite,
                  height: 300,
                  'images/1.png',
                  fit: BoxFit.cover, // 讓圖片完全填滿
                ),
              ),
              const Wrap(
                children: [
                  Text(
                    "#Tag",
                    style:
                        TextStyle(color: Color(0xFF589399), height: 3, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// 標籤小元件
  Widget _buildTag(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.blueGrey,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const HeaderPage1(
        title: "傷口紀錄冊",
        icon: Icon(
          MyFlutterApp.bell,
          size: 23,
          color: Color(0xFF589399),
        ),
        targetPage: RemindPage(),
      ),
      Container(
        color: const Color(0xFFCBF0F4),
        child: TabBar(
          // isScrollable: true,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          labelColor: const Color(0xFF04555D),
          unselectedLabelColor: Colors.blueGrey,
          controller: _tabController,
          indicatorColor: const Color(0xFF04555D),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          // indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(
              text: ("全部"),
            ),
            Tab(
              text: ("割傷"),
            ),
            Tab(
              text: ("擦傷"),
            ),
            Tab(
              text: ("瘀傷"),
            ),
            Tab(
              text: ("燒傷"),
            ),
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // 取消滑動切換
          controller: _tabController,
          children: [
            _buildImagePage(),
            _buildImagePage(),
            _buildImagePage(),
            _buildImagePage(),
            _buildImagePage(),
          ],
        ),
      ),
    ]);
  }

  Widget _buildImagePage() {
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
              // padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  _buildRecentImage('2025/01/01'),
                  _buildRecentImage('2025/01/01'),
                  _buildRecentImage('2025/01/01'),
                  _buildRecentImage('2025/01/01'),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(color: Color(0xFF589399)),
            _buildYearlyImage('2025'),
            _buildYearlyImage('2024'),
            _buildYearlyImage('2023'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentImage(String time) {
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
                  child: Image.asset(
                    'images/1.png',
                    fit: BoxFit.cover,
                  ),
                )),
            onLongPress: () {
              _showConfirmationDialog();
              // _showWoundDialog();
            },
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage()));
            },
          ),
          Text(
            time,
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

  Widget _buildYearlyImage(String y) {
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TotalPage()));
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(70, 25),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min, // 讓內容寬度剛好包住文字和箭頭
                children: [
                  Text(
                    "更多",
                    style: TextStyle(
                      color: Color(0xFF589399),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4), // 調整文字與箭頭間距
                  Icon(
                    Icons.arrow_forward_ios, // 這裡可以改成其他箭頭圖示
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
          // margin: const EdgeInsets.only(top: 5, bottom: 8),
          width: double.infinity,
          height: 200,
          // child: _buildYearlyImage(5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(right: 10),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),

                              // margin: const EdgeInsets.only(right: 5),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(top: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
