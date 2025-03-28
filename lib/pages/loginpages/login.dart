import 'package:flutter/material.dart';
import '../registerpage.dart';
import '../tabs.dart';
import 'reset_password.dart'; // ✅ 引入變更密碼畫面

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo 圖片與標題
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    // borderRadius: BorderRadius.circular(20), // 設置圓角
                    child: Image.asset(
                      'images/icon_2.png',
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Log in",
                        style: TextStyle(
                          fontFamily: 'Rubik Dirt',
                          fontSize: 45,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF669FA5),
                        ),
                      ),
                      Text(
                        " Dr.W",
                        style: TextStyle(
                          fontFamily: 'Rubik Dirt',
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF669FA5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 帳號輸入框
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "帳號",
                    hintText: "example@gmail.com",
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF669FA5),
                    ),
                    floatingLabelBehavior:
                        FloatingLabelBehavior.never, // 標籤固定在輸入框內
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 密碼輸入框
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "密碼",
                    hintText: "XXXXXXXXXXXX",
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF669FA5),
                    ),
                    floatingLabelBehavior:
                        FloatingLabelBehavior.never, // 標籤固定在輸入框內
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 忘記密碼 / 訪客登入
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen()),
                        );
                      },
                      child: const Text(
                        "忘記密碼？",
                        style: TextStyle(color: Color(0xFF669FA5)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Tabs()),
                        );
                      },
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
              ),

              // 登入按鈕
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Tabs()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF669FA5),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "登入",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 分隔線
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[400],
                      thickness: 1,
                      indent: 30,
                      endIndent: 10,
                    ),
                  ),
                  const Text(
                    "其他方式",
                    style: TextStyle(color: Color(0xFF4C7488)),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[400],
                      thickness: 1,
                      indent: 10,
                      endIndent: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 社群登入按鈕
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton('assets/line.png'),
                  _buildSocialButton('assets/google.png'),
                  _buildSocialButton('assets/facebook.png'),
                ],
              ),

              // 註冊新帳號
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: const Text(
                  "註冊新帳號",
                  style: TextStyle(
                    color: Color(0xFF4C7488),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String asset) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipOval(
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                asset,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
