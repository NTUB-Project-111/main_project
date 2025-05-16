import 'package:flutter/material.dart';
import '../headers/header_3.dart';
import '../../my_flutter_app_icons.dart';
import '../../feature/database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>>? userCalls = DatabaseHelper.homeRemind;
  // List<Map<String, dynamic>>? userRecords = DatabaseHelper.allRecords;
  String day = DateTime.now().toLocal().toString().split(' ')[0];

  List<Widget> buildReminderTiles() {
    if (userCalls == null || userCalls!.isEmpty) {
      return []; // 或回傳 [Text("今日無提醒")]
    }
    return userCalls!
        .where((call) => call["date"] == day) // 篩選出符合今天日期的項目
        .map((call) => ReminderTile(
            call["time"]?.toString() ?? "", "換藥", call["type"], call["photo"])) // 生成 widget
        .toList(); // 轉換為 List<Widget>
  }

  final List<String> imageUrls = [
    'images/bruises.png',
    'images/burn.png',
    'images/cut.png',
  ];

  final List<String> links = [
    'https://frhosp.rghealth.com.tw/%E5%86%B0%E6%95%B7%E7%86%B1%E6%95%B7%E4%BD%BF%E7%94%A8%E6%99%82%E6%A9%9F/',
    'https://www.weigong.org.tw/HealthEdus/Detail?no=133',
    'https://www.nhi.gov.tw/ch/cp-2784-732cd-2951-1.html',
  ];

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw '無法開啟連結: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(children: [
      const HeaderPage3(
        icon: Icon(
          MyFlutterApp.bell,
          color: Color(0xFF669FA5),
          size: 23,
        ),
      ),
      CarouselSlider(
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          viewportFraction: 0.9,
        ),
        items: imageUrls.asMap().entries.map((entry) {
          int index = entry.key;
          String url = entry.value;

          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () => _launchUrl(links[index]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(url, fit: BoxFit.cover, width: double.infinity),
                ),
              );
            },
          );
        }).toList(),
      ),
      Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '今日',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFF669FA5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(3, 0, 5, 3),
                  child: Text(
                    '換藥提醒',
                    style: TextStyle(fontSize: 15, color: Color(0xFF669FA5)),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Divider(
                    color: Color(0xFF669FA5),
                    thickness: 1,
                  ),
                )),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buildReminderTiles(),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget ReminderTile(String time, String description, String type, String img) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(214, 242, 244, 0.3),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color.fromRGBO(133, 162, 164, 1.0)),
      ),
      child: Column(
        children: [
          Text(
            type,
            style: const TextStyle(fontSize: 15, color: Color(0xFF669FA5)),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 75,
              height: 75,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // 設定圓角半徑 (可自行調整)
                  child: Image.network(
                    Uri.parse(DatabaseHelper.baseUrl).resolve(img).toString(),
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                  ))),
          Row(
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 15, color: Color(0xFF669FA5)),
              ),
              const SizedBox(width: 13),
              Text(
                description,
                style: const TextStyle(fontSize: 15, color: Color(0xFF669FA5)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
