import 'package:drw/backend/viewmodels/report_view_model.dart';
import 'package:drw/backend/provider/remind_provider.dart'; //
import 'package:drw/backend/provider/report_provider.dart'; //
import 'package:drw/backend/provider/user_provider.dart'; //
import 'package:drw/backend/viewmodels/register_view_model.dart';
import 'package:drw/frontend/pages/login_page.dart';
import 'package:drw/frontend/pages/test_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/utility/notifier_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // 初始化 .env 檔案
  await dotenv.load(fileName: ".env");
  // 確保 Flutter 綁定已初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化通知系統
  await Notifier.initialize();
  // 啟動 App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Report()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => RemindProvider()),
        ChangeNotifierProvider(create: (_) => Register()),
        // ChangeNotifierProvider(create: (_) => ReportAnalyzer()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
            //時間選擇器 顏色設定
            backgroundColor: const Color(0xFFF7FCFD),
            dialHandColor: const Color(0xFF589399),
            dialTextColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const Color.fromARGB(255, 255, 255, 255); // 選中狀態下的數字
              }
              return const Color(0xFF2E6D74); // 未選中狀態下的數字
            }),
            // dialTextColor: const Color(0xFF2E6D74),
            dialBackgroundColor: Colors.white,
            // hourMinuteColor: const Color(0xFFBBD3D6),
            hourMinuteTextColor: const Color(0xFF164449),
            hourMinuteShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Color(0xFF589399), width: 2),
            ),
            dayPeriodColor: WidgetStateColor.resolveWith(
              (states) => const Color(0xFF589399),
            ),
            dayPeriodTextColor: Colors.white,
            // ... 其他可設定的屬性
            confirmButtonStyle: ButtonStyle(
              textStyle: WidgetStateProperty.all<TextStyle>(
                const TextStyle(fontWeight: FontWeight.bold), // 設定字體寬度
              ),
              foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFF589399)),
            ),
            helpTextStyle: const TextStyle(color: Color(0xFF589399)),
            cancelButtonStyle: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
            )),
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

