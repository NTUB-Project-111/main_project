import 'package:drw/backend/models/records_model.dart';
import 'package:drw/backend/models/reminds_model.dart';
import 'package:drw/backend/models/report_model.dart';
import 'package:drw/frontend/pages/tabs/hospital_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend/models/user_model.dart';
import 'frontend/pages/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // 初始化 .env 檔案
  await dotenv.load(fileName: ".env");

  // 啟動 App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()),
        ChangeNotifierProvider(create: (_) => Report()),
        ChangeNotifierProvider(create: (_) => Records()),
        ChangeNotifierProvider(create: (_) => Reminds()),
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      // home: Tabs(),
      // home:RemindPage()
      home: HospitalPage(),
    );
  }
}
