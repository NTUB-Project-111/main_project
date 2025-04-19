import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'registerpages/account_setup.dart';
import 'registerpages/captcha_section.dart';
import 'registerpages/personal_info_section.dart';
import '../my_flutter_app_icons.dart';
import '../feature/database.dart';
import 'tabs.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final Map<String, dynamic> personalinfo = {};
  final Map<String, dynamic> accountinfo = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEBFEFF),
            // borderRadius: BorderRadius.circular(10), //邊緣圓弧狀
          ),
          constraints: const BoxConstraints(maxWidth: 412),
          //margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //註冊畫面標題區塊
              Container(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF589399), width: 2), // 只加底部邊框
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              MyFlutterApp.icon_park_solid__back,
                              color: Color(0xFF589399),
                            ))),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      '註冊帳戶',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF669FA5),
                      ),
                    ),
                  ],
                ),
              ),

              // 註冊表單內容
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PersonalInfoSection(onDataChanged: (data) {
                      setState(() {
                        personalinfo.clear();
                        personalinfo.addAll(data);
                      });
                    }), //個人資訊輸入區
                    const SizedBox(height: 25),

                    const DottedDivider(), // 直接使用即可，長度會根據螢幕寬度自適應

                    const SizedBox(height: 15),
                    AccountSetupSection(onDataChanged: (data) {
                      setState(() {
                        accountinfo.clear();
                        accountinfo.addAll(data);
                      });
                    }), //帳戶設定區
                    const SizedBox(height: 25),
                    // const DottedDivider(), // 直接使用即可，長度會根據螢幕寬度自適應
                    // const SizedBox(height: 15),
                    // const CaptchaSection(), //驗證碼區
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // print(personalinfo['name']);
                          // print(accountinfo['email']);
                          // print(accountinfo['password']);
                          // print(personalinfo['gender']);
                          // print(personalinfo['birthday']);
                          // print("image:${personalinfo['profileImage']}");
                          if (personalinfo['name'] == null ||
                              personalinfo['name'].isEmpty ||
                              personalinfo['birthday'] == null ||
                              personalinfo['birthday'].isEmpty ||
                              personalinfo['gender'] == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('請填寫完整個人資料'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // 終止註冊流程
                          }

                          if (accountinfo['email'] == null ||
                              accountinfo['email'].isEmpty ||
                              accountinfo['password'] == null ||
                              accountinfo['password'].isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('請填寫完整帳戶資訊'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // 終止註冊流程
                          }

                          bool userAdded = await DatabaseHelper.addUser(
                            personalinfo['name'],
                            accountinfo['email'],
                            accountinfo['password'],
                            personalinfo['gender'],
                            personalinfo['birthday'],
                            personalinfo['profileImage'] != null
                                ? personalinfo['profileImage'] as File
                                : null,
                          );

                          if (userAdded) {
                            print("使用者註冊成功，開始儲存 userId...");
                            bool saved = await DatabaseHelper.saveUserId(accountinfo['email']);
                            if (saved) {
                              String? userId = await DatabaseHelper.getUserId();
                              DatabaseHelper.userInfo = (await DatabaseHelper.getUserInfo())!;
                              print("獲取的 User ID: $userId");

                              // ✅ 真正跳轉頁面
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => const Tabs()));
                            } else {
                              print("無法儲存 User ID");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('註冊成功但無法儲存使用者資訊'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          } else {
                            print("使用者註冊失敗");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('註冊失敗，請稍後再試'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF669FA5),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          minimumSize: const Size(100, 20), // 設定按鈕最小寬度 200，高度 50
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          '註冊',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedDivider extends StatelessWidget {
  const DottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // 取得螢幕寬度

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Dash(
          direction: Axis.horizontal,
          length: screenWidth * 0.9, // 讓虛線佔螢幕 80% 寬度
          dashLength: 5,
          dashGap: 5,
          dashColor: const Color(0xFF669FA5),
          dashThickness: 2, // 使用正確的參數名稱（dashThickness）
        ),
      ),
    );
  }
}
