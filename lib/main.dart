import 'package:flutter/material.dart';
import './pages/tabs.dart';
import './pages/registerpage.dart';
import './feature/database.dart';
import 'pages/loginpages/login.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // home: Tabs(),
//       home: TestPage(),
//     );
//   }
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialPage() async {
    var userId = await DatabaseHelper.getUserId();
    userId = null;
    if (userId != null) {
      final userInfo = await DatabaseHelper.getUserInfo();
      final userRecords = await DatabaseHelper.getUserRecords();
      final userCalls = await DatabaseHelper.getReminds();
      final remindRecord = await DatabaseHelper.getRemindRecord();
      final homeRemind = await DatabaseHelper.getHomeRemind();
      if (userInfo != null) {
        DatabaseHelper.userInfo = userInfo;
        debugPrint('User Info Loaded: $userInfo');
        debugPrint('成功載入使用者資料');
      } else {
        return const RegistrationPage();
      }
      if (userRecords != null) {
        DatabaseHelper.allRecords = userRecords;
        // debugPrint('User Records Loaded: $userRecords');
        debugPrint('成功載入使用者診斷紀錄');
      }
      if (userCalls != null) {
        DatabaseHelper.allCalls = userCalls;
        // debugPrint('User Records Loaded: $userCalls');
        debugPrint('成功載入護理提醒');
      }
      if (remindRecord != null) {
        DatabaseHelper.remindRecords = remindRecord;
        debugPrint('成功載入診斷紀錄跟提醒');
        // debugPrint('remindRecords Loaded: $remindRecord');
      }
      if (homeRemind != null) {
        DatabaseHelper.homeRemind = homeRemind;
        debugPrint('成功載入首頁提醒');
        // debugPrint('homeRemind Loaded: $homeRemind');
      }
      debugPrint('User ID: $userId');
      return const Tabs(); // 回傳主頁
    } else {
      // debugPrint('沒有 userId，導向註冊頁');
      // return const RegistrationPage();
      debugPrint('沒有 userId，導向登入頁');
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 等待資料載入時顯示 loading 畫面
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            // 若發生錯誤
            return const Scaffold(
              body: Center(child: Text('發生錯誤，請稍後再試')),
            );
          } else {
            // 資料載入成功，顯示對應頁面
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
