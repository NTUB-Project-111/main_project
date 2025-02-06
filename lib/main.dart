import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'widgets/personal_info_section.dart';
import 'widgets/account_setup_section.dart';
import 'widgets/captcha_section.dart';

void main() {
  runApp(MaterialApp(
    home: RegistrationScreen(),
  ));
}

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEBFEFF),
            // borderRadius: BorderRadius.circular(10), //邊緣圓弧狀
          ),
          constraints: const BoxConstraints(maxWidth: 412),
          //margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //註冊畫面標題區塊
              Container(
                padding: const EdgeInsets.fromLTRB(24, 45, 24, 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(
                    bottom: BorderSide(
                        color: Color(0xFF589399), width: 2), // 只加底部邊框
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset('images/icon/back.png',
                          width: 30, height: 30),
                    ),
                    Text(
                      '註冊帳戶',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF669FA5),
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
                  children: const [
                    PersonalInfoSection(), //個人資訊輸入區
                    SizedBox(height: 25),

                    DottedDivider(), // 直接使用即可，長度會根據螢幕寬度自適應

                    SizedBox(height: 15),
                    AccountSetupSection(), //帳戶設定區
                    SizedBox(height: 25),

                    DottedDivider(), // 直接使用即可，長度會根據螢幕寬度自適應

                    SizedBox(height: 15),
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


//想把驗證碼的這個區塊拿掉，改成按註冊之後，跳出診斷是否為機器人的機制，通過再跳出註冊成功。
