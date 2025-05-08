import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //匯入 http 套件
import 'package:wounddetection/font_awesome5_icons.dart';
import '../registerpage.dart';
import '../tabs.dart';
import 'reset_password.dart'; // ✅ 引入變更密碼畫面
import '../headers/header_widget.dart';
import '../../font_awesome5_icons.dart';
import 'package:wounddetection/feature/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

// 要能取得 email 和 password，需要用 TextEditingController
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ✅ 登入 API 邏輯
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("請輸入帳號與密碼")),
      );
      return;
    }

    final url = Uri.parse('${DatabaseHelper.baseUrl}/loginUser');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String userID = responseData['userID'].toString();
        print("登入成功，使用者 ID：$userID");

        // ✅ 先存 userID 到 SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userID);

        // ✅ 再撈使用者資訊
        DatabaseHelper.userInfo = (await DatabaseHelper.getUserInfo())!;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Tabs()),
        );
      } else {
        String errorMessage = '登入失敗';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('發生錯誤：$e')),
      );
    }
  }

  // ✅ 錯誤訊息彈窗
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('登入失敗'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F8F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HeaderWidget(
                title: "Welcome",
                subtitle: ' to Dr.W',
              ),
              const SizedBox(height: 30),

              // ✅ 帳號輸入
              TextField(
                controller: _emailController,
                decoration:
                    _inputDecoration(label: "帳號", hint: "example@gmail.com"),
              ),
              const SizedBox(height: 10),

              // ✅ 密碼輸入
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: _inputDecoration(label: "密碼", hint: "XXXXXXXXXXXX")
                    .copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromRGBO(135, 135, 135, 0.5)),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 忘記密碼 / 訪客登入
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen()),
                    ),
                    child: const Text("忘記密碼？",
                        style: TextStyle(color: Color(0xFF669FA5))),
                  ),
                  // TextButton(
                  //   onPressed: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const Tabs(
                  //               userID: '',
                  //             )),
                  //   ),
                  //   child: const Text(
                  //     "訪客登入",
                  //     style: TextStyle(
                  //       color: Color(0xFF4C7488),
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Tabs(), // 移除 userID
                      ),
                    ),
                    child: const Text(
                      "訪客登入",
                      style: TextStyle(
                        color: Color(0xFF4C7488),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),

              // ✅ 登入按鈕
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF669FA5),
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("登入",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),

              // 分隔線
              const Row(
                children: [
                  Expanded(
                      child: Divider(
                          color: Color(0xFF4C7488),
                          thickness: 1,
                          indent: 10,
                          endIndent: 10)),
                  Text("其他方式",
                      style: TextStyle(fontSize: 12, color: Color(0xFF4C7488))),
                  Expanded(
                      child: Divider(
                          color: Color(0xFF4C7488),
                          thickness: 1,
                          indent: 10,
                          endIndent: 10)),
                ],
              ),
              const SizedBox(height: 20),

              // 社群登入按鈕
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(
                      FontAwesome5.facebook_square, const Color(0xFF4C7488)),
                  _buildSocialButton(
                      FontAwesome5.google_plus_square, const Color(0xFF4C7488)),
                  _buildSocialButton(
                      FontAwesome5.line, const Color(0xFF4C7488)),
                ],
              ),
              const SizedBox(height: 15),

              // 註冊新帳號
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                ),
                child: const Text(
                  "註冊新帳號",
                  style: TextStyle(
                    color: Color(0xFF4C7488),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 共用輸入框樣式
  InputDecoration _inputDecoration(
      {required String label, required String hint}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(
          color: Color.fromRGBO(135, 135, 135, 0.4), fontSize: 14),
      labelStyle: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF669FA5)),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    );
  }

  /// 社群登入按鈕
  Widget _buildSocialButton(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {}, // 這裡可以串接社群登入
        borderRadius: BorderRadius.circular(25),
        child: Ink(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 30, color: color),
        ),
      ),
    );
  }
}
