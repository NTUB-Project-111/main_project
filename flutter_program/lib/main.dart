import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:drw/backend/viewmodels/report_view_model.dart';
import 'package:drw/backend/provider/remind_provider.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/viewmodels/register_view_model.dart';
import 'package:drw/frontend/pages/login_page.dart';
import 'package:drw/frontend/pages/test_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/utility/notifier_util.dart';
import 'package:drw/plugins/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化 AlarmManager
  await AndroidAlarmManager.initialize();
  // 初始化通知系統（要在 Notifier.initialize() 裡面做 flutterLocalNotificationsPlugin.initialize）
  await Notifier.initialize();

  // await NotificationPlugin().init();
  // await Notifier.initialize(); // 這裡可以只初始化通知

  // 初始化 .env 檔案
  await dotenv.load(fileName: ".env");

  // 初始化時區
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Taipei')); // 將時區設定為台北標準時間

  // 啟動 App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Report()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => RemindProvider()),
        ChangeNotifierProvider(create: (_) => Register()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 176, 215, 219),
          onPrimary: Colors.white,
          onSurface: Color.fromARGB(255, 125, 173, 178),
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: const Color(0xFFF7FCFD),
          dialHandColor: const Color(0xFF589399),
          dialTextColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color.fromARGB(255, 255, 255, 255);
            }
            return const Color(0xFF2E6D74);
          }),
          dialBackgroundColor: Colors.white,
          hourMinuteTextColor: const Color(0xFF164449),
          hourMinuteShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFF589399), width: 2),
          ),
          dayPeriodColor: WidgetStateColor.resolveWith(
            (states) => const Color(0xFF589399),
          ),
          dayPeriodTextColor: Colors.white,
          confirmButtonStyle: ButtonStyle(
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(fontWeight: FontWeight.bold),
            ),
            foregroundColor:
                WidgetStateProperty.all<Color>(const Color(0xFF589399)),
          ),
          helpTextStyle: const TextStyle(color: Color(0xFF589399)),
          cancelButtonStyle: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: FrontUtil.bkColor,
          ),
        ),
        fontFamily: 'NotoSansTC',
      ),
      // home: const LoginPage(),
      home: const TestPage(),
    );
  }
}
