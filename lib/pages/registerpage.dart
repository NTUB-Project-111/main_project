import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

import 'loginpages/login.dart';
import 'registerpages/account_setup.dart';
import 'registerpages/captcha_section.dart';
import 'registerpages/personal_info_section.dart';
import '../my_flutter_app_icons.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF), // 設定 Scaffold 背景顏色
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
                    bottom: BorderSide(
                        color: Color(0xFF589399), width: 2), // 只加底部邊框
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        // child: Image.asset('images/icon/back.png', width: 30, height: 30),
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()));
                            },
                            icon: const Icon(
                              MyFlutterApp.icon_park_solid__back,
                              color: const Color(0xFF589399),
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
              const Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PersonalInfoSection(), //個人資訊輸入區
                    SizedBox(height: 25),

                    DottedDivider(), // 直接使用即可，長度會根據螢幕寬度自適應

                    SizedBox(height: 15),
                    AccountSetupSection(), //帳戶設定區
                    SizedBox(height: 25),

                    // DottedDivider(), // 直接使用即可，長度會根據螢幕寬度自適應

                    // SizedBox(height: 15),
                    CaptchaSection(), //驗證碼區
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
