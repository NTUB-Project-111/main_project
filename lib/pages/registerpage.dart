import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'registerpages/account_setup.dart';
import 'registerpages/captcha_section.dart';
import 'registerpages/personal_info_section.dart';
import '../my_flutter_app_icons.dart';
import '../feature/database.dart';
import 'tabs.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String _errorMessage = "";

  //驗證電子郵件格式
  bool _validateEmail(String value) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(value)) {
      return false;
    }
    return true;
  }
  //驗證密碼格式
  bool _validatePassword(String value) {
    if (value.length < 8 || value.length > 16) {
      _errorMessage = '密碼長度需為 8-16 個字符';
      return false;
    }
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$');
    if (!passwordRegex.hasMatch(value)) {
      _errorMessage = '密碼需包含英文字母與數字';
      return false;
    }
    return true;
  }
  //驗證密碼是否一致
  bool _confirmPassword(String value1, String value2) {
    if (value1 != value2) {
      return false;
    }
    return true;
  }
  //顯示錯誤訊息
  void _showError(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEBFEFF),
          ),
          constraints: const BoxConstraints(maxWidth: 412),
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
                    const PersonalInfoSection(),
                    const SizedBox(height: 25),
                    const DottedDivider(), // 直接使用即可，長度會根據螢幕寬度自適應
                    const SizedBox(height: 15),
                    const AccountSetupSection(), //帳戶設定區
                    const SizedBox(height: 25),
                    // const DottedDivider(), // 直接使用即可，長度會根據螢幕寬度自適應
                    // const SizedBox(height: 15),
                    // const CaptchaSection(), //驗證碼區
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final user = DatabaseHelper.userInfo;
                          // 基本欄位檢查
                          if (user["name"]?.isEmpty ||
                              user["gender"]?.isEmpty ||
                              user["birthday"]?.isEmpty ||
                              user["email"]?.isEmpty ||
                              user["password"]?.isEmpty ||
                              user["confirm"]?.isEmpty) {
                            _showError("請填寫完整個人資料");
                            return;
                          }
                          // Email 格式驗證
                          if (!_validateEmail(user["email"])) {
                            _showError("無效的電子郵件");
                            return;
                          }
                          // 密碼格式驗證
                          if (!_validatePassword(user["password"])) {
                            _showError(_errorMessage);
                            return;
                          }
                          // 密碼確認
                          if (!_confirmPassword(user["password"], user["confirm"])) {
                            _showError("密碼不一致");
                            return;
                          }
                          // 新增使用者
                          bool userAdded = await DatabaseHelper.addUser(
                            user["name"],
                            user["email"],
                            user["password"],
                            user["gender"],
                            user["birthday"],
                            user["picture"] != null ? user["picture"] as File : null,
                          );
                          if (!userAdded) {
                            _showError("註冊失敗，請稍後再試");
                            return;
                          }
                          // 儲存 userId
                          bool saved = await DatabaseHelper.saveUserId(user["email"]);
                          if (!saved) {
                            _showError("註冊成功但無法儲存使用者資訊");
                            return;
                          }
                          String? userId = await DatabaseHelper.getUserId();
                          DatabaseHelper.userInfo = (await DatabaseHelper.getUserInfo())!;
                          print("獲取的 User ID: $userId");
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const Tabs()));
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
