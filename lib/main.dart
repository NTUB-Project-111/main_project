import 'package:flutter/material.dart';

// import './pages/tabs.dart';

// import './pages/registerpage.dart';
import 'package:wounddetection/pages/intropages/intro.dart';
// import 'package:wounddetection/pages/loginpages/login.dart';

import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  // @override
  // HttpClient createHttpClient(SecurityContext? context) {
  //   return super.createHttpClient(context)
  //     ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  // }
}

void main() {
  // HttpOverrides.global = MyHttpOverrides(); // 忽略 SSL 憑證
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home:HospitalListPage(),

      // home: Tabs(),
      // home : RemindPage(),
      // home: TotalPage(),
      // home: RecordPage(),
      // home: RegistrationPage(),
      // home: LoginScreen(),
      home: IntroScreen(),
    );
  }
}
