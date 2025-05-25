import 'package:flutter/material.dart';
import 'package:wounddetection/my_flutter_app_icons.dart';
import '../feature/database.dart';
import './tabs/homepage.dart';
import './tabs/hospitalpage.dart';
import './tabs/personpage.dart';
import './tabs/recordpage.dart';
import './tabs/screenpage.dart';
// import '../my_flutter_app_icons.dart';

class Tabs extends StatefulWidget {
  final int? currentIndex;
  const Tabs({super.key, this.currentIndex});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  late int _currentIndex; // 用 late 確保_currentIndex正確初始化
  final List<Widget> _pages = [
    //pages裡面的頁面都先讓他傳入空白的頁面就好
    const HomePage(),
    const HospitalPage(),
    const ScreenPage(),
    const RecordPage(),
    const PersonPage(),
  ];

  @override
  void initState() {
    super.initState();
    // 如果 `currentIndex` 傳入的是 null，則使用 0
    _currentIndex = widget.currentIndex ?? 0;
    // loadUserInfo();
  }

  // void loadUserInfo() async {
  //   final userInfo = await DatabaseHelper.getUserInfo();
  //   final userId = await DatabaseHelper.getUserId();
  //   if (userInfo != null) {
  //     DatabaseHelper.userInfo = userInfo;
  //     debugPrint('✅ User Info Loaded: $userInfo');
  //   } else {
  //     debugPrint('⚠️ 無法載入 userInfo');
  //   }
  //   debugPrint('User ID: $userId');
  //   // 若需要更新畫面（例如根據 userInfo 調整 UI）再呼叫 setState()
  //   // setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //讓floatingactionbottun不受鍵盤影響位置
      backgroundColor: const Color(0xFFEBFEFF),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF669FA5), width: 2), // 只設定上邊框
          ),
        ),
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex =
                  index != 2 ? index : _currentIndex; //setState會重新跑build
            });
          },
          selectedFontSize: 13,
          unselectedFontSize: 11,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(MyFlutterApp.home),
              label: "首頁",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MyFlutterApp.hospital,
              ),
              label: "附近醫院",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: "傷口拍攝",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MyFlutterApp.book_medical,
              ),
              label: "紀錄冊",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MyFlutterApp.user,
              ),
              label: "我的",
            ),
          ],
          selectedItemColor: const Color(0xFF669FA5),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF669FA5),
            shape: const CircleBorder(
                side: BorderSide(color: Colors.white, width: 2.0)),
            child: const Icon(MyFlutterApp.camera, size: 35),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScreenPage(),
                ),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
