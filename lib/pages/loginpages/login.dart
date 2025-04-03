import 'package:flutter/material.dart';
import 'package:wounddetection/font_awesome5_icons.dart';
import '../registerpage.dart';
import '../tabs.dart';
import 'reset_password.dart'; // ✅ 引入變更密碼畫面
import '../headers/header_widget.dart';
import '../../font_awesome5_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

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

              // **帳號與密碼輸入框**
              buildInputField(label: "帳號", hint: "example@gmail.com"),
              const SizedBox(height: 10),
              buildPasswordField(),

              const SizedBox(height: 10),

              // **忘記密碼 / 訪客登入**
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
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Tabs()),
                    ),
                    child: const Text(
                      "訪客登入",
                      style: TextStyle(
                        color: Color(0xFF4C7488),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // **登入按鈕**
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tabs()),
                  ),
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

              // **分隔線**
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

              // **社群登入**
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

              // **註冊新帳號**
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

  /// **帳號輸入框**
  Widget buildInputField({required String label, required String hint}) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        hintText: hint,
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 20, horizontal: 10), // 調整高度
        hintStyle: const TextStyle(
            color: Color.fromRGBO(135, 135, 135, 0.4), fontSize: 14),
        labelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF669FA5)),
        floatingLabelBehavior: FloatingLabelBehavior.never, // 標籤固定在輸入框內
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
    );
  }

  /// **密碼輸入框**
  Widget buildPasswordField() {
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "密碼",
        hintText: "XXXXXXXXXXXX",
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 20, horizontal: 10), // 調整高度
        hintStyle: const TextStyle(
            color: Color.fromRGBO(135, 135, 135, 0.4), fontSize: 14),
        labelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF669FA5)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color.fromRGBO(135, 135, 135, 0.5)),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
    );
  }

  /// **社群登入按鈕**
  Widget _buildSocialButton(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {}, // 這裡可以填入登入邏輯
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
          child: Icon(icon, size: 30, color: color), // 這裡改用 `Icons`
        ),
      ),
    );
  }
}
