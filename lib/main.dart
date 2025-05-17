import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wounddetection/feature/notifer.dart';
import './pages/tabs.dart';
import './pages/registerpage.dart';
import './feature/database.dart';
import 'feature/ApiHelper.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Widget> _initialPageFuture;

  @override
  void initState() {
    super.initState();
    _initialPageFuture = _getInitialPage();
  }

  Future<Widget> _getInitialPage() async {
    try {
      var userId = await DatabaseHelper.getUserId();
      Notifier.debugPrintAllScheduledReminders();

      if (userId == null) {
        debugPrint('沒有 userId，導向登入頁');
        return const LoginScreen();
      } else {
        debugPrint('已有 userId，嘗試載入使用者資料');
        bool loadSuccess = await _loadUserData(userId);
        if (!loadSuccess) {
          debugPrint('載入使用者資訊失敗，可能 token 過期或無效');
          // 載入失敗，導回登入頁
          return const LoginScreen();
        }
        return const Tabs();
      }
    } catch (e) {
      debugPrint('初始化失敗: $e');
      return const Scaffold(
        body: Center(child: Text('發生錯誤，請稍後再試')),
      );
    }
  }

  Future<bool> _loadUserData(String userID) async {
    final response = await ApiHelper.get('/getUserInfo');
    if (response == null || response.statusCode != 200) {
      return false;
    }
    try {
      final userInfo = jsonDecode(response.body);
      DatabaseHelper.userInfo = userInfo;
      debugPrint('使用者資訊載入成功');

      final records = await DatabaseHelper.getUserRecords();
      if (records != null) {
        DatabaseHelper.allRecords = records;
        checkRecord(records);
        debugPrint('診斷紀錄載入成功');
      }
      final calls = await DatabaseHelper.getReminds();
      if (calls != null) {
        DatabaseHelper.allCalls = calls;
        debugPrint('護理提醒載入成功');
      }
      final remindRecord = await DatabaseHelper.getRemindRecord();
      if (remindRecord != null) {
        DatabaseHelper.remindRecords = remindRecord;
        debugPrint('提醒紀錄載入成功');
      }
      final homeRemind = await DatabaseHelper.getHomeRemind();
      if (homeRemind != null) {
        DatabaseHelper.homeRemind = homeRemind;
        debugPrint('首頁提醒載入成功');
      }
      return true;
    } catch (e) {
      debugPrint('解析使用者資料時發生錯誤: $e');
      return false;
    }
  }

  Future<void> checkRecord(List<dynamic> userRecords) async {
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    for (var record in userRecords) {
      if (record["ifcall"] == "Y") {
        List<String> oktimeList = record["oktime"].split("~");
        DateTime startDate = DateTime.parse(record["date"]);
        int durationDays = int.parse(oktimeList[1]);
        DateTime endTime = startDate.add(Duration(days: durationDays));
        if (today.isAfter(endTime)) {
          record["ifcall"] = "N";
          await DatabaseHelper.deleteRemind(
              record["fk_userid"].toString(), record["id_record"].toString());
          await DatabaseHelper.updateRecord(
              record["id_record"].toString(), record["fk_userid"].toString(), "N");
          await Notifier.cancelAllReminders();
          await Notifier.debugPrintAllScheduledReminders();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _initialPageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('發生錯誤，請稍後再試')),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
