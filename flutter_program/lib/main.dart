import 'package:drw/backend/models/report_model.dart';
import 'package:drw/backend/provider/remind_provider.dart'; //
import 'package:drw/backend/provider/report_provider.dart'; //
import 'package:drw/backend/provider/user_provider.dart'; //
import 'package:drw/backend/viewmodels/register_view_model.dart';
import 'package:drw/frontend/pages/registerpages/account_page.dart';
import 'package:drw/frontend/pages/registerpages/birthday_page.dart';
import 'package:drw/frontend/pages/registerpages/disease_page.dart';
import 'package:drw/frontend/pages/registerpages/habit_page.dart';
import 'package:drw/frontend/pages/registerpages/information2_page.dart';
import 'package:drw/frontend/pages/registerpages/information_page.dart';
import 'package:drw/frontend/pages/registerpages/register_flow.dart';
import 'package:drw/frontend/pages/registerpages/username_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'frontend/pages/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // 初始化 .env 檔案
  await dotenv.load(fileName: ".env");

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: LoginPage(),
        home: RegisterFlow()
        // home: AccountPage()
        // home : InformationPage()
        // home:BirthdayPage()
        // home:HabitPage()
        // home : DiseasePage()
        // home:Information2Page()
        );
  }
}
