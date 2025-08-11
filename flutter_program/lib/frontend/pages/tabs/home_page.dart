import 'package:carousel_slider/carousel_slider.dart';
import 'package:drw/backend/models/home_remind.dart';
import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/pages/remind_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<HomeRemind> reminds = [];
  String today = DateTime.now().toLocal().toString().split(' ')[0];
  bool _isInitialized = false;

  final List<String> imageUrls = [
    'images/bruise.png',
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

  Future<void> loadHomeReminds() async {
    final userInfo = Provider.of<UserProvider>(context, listen: false).user;
    if (userInfo != null) {
      final userReports = userInfo.reports;
      if (userReports.isNotEmpty) {
        final List<HomeRemind> newReminds = [];
        for (var report in userReports) {
          newReminds.addAll(
            report.reminds
                .where((r) => r.date == today)
                .map((r) => HomeRemind.fromReport(report, r))
                .whereType<HomeRemind>(),
          );
        }
        setState(() {
          reminds
            ..clear()
            ..addAll(newReminds);
        });
      }
    }

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    loadHomeReminds();
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 3),
          child: AppBar(
            backgroundColor: FrontUtil.bkColor,
            leading: Image.asset('images/icon.png'),
            title: Text(
              'Dr.W',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                height: 2.5,
                color: FrontUtil.textColor,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: FrontUtil.textColor),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RemindPage()),
                  );
                  await loadHomeReminds(); //重新載入提醒
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
          )
        ],
      ),
    );
  }

  List<Widget> buildReminderTiles() {
    if (reminds.isEmpty) {
      return []; // 或回傳 [Text("今日無提醒")]
    }
    return reminds
        .map((remind) =>
            remindeTile(remind.time, "換藥", remind.woundType, remind.imagePath)) // 生成 widget
        .toList(); // 轉換為 List<Widget>
  }

  Widget remindeTile(String time, String description, String type, String img) {
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
                    Uri.parse(ApiBase.baseUrl).resolve(img).toString(),
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
