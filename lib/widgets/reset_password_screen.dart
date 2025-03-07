import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Color(0xFF83B6BB),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "變更密碼成功",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Password changed successfully",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 圖片與標題
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/logo.jpeg',
                      width: 194,
                      height: 181,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rubik Dirt',
                          color: Color(0xFF669FA5),
                        ),
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rubik Dirt',
                          color: Color(0xFF669FA5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 帳號輸入框
              buildInputField(
                label: "帳號",
                hint: "example@gmail.com",
                suffix: buildButton("傳送驗證碼"),
              ),

              // 驗證碼輸入框
              buildInputField(
                label: "驗證碼",
                hint: "請至電子郵件中取得驗證碼",
                suffix: buildButton("驗證"),
              ),

              // 新密碼輸入框
              buildPasswordField(
                label: "新密碼",
                hint: "輸入 8-16 個英文/數字",
                isVisible: _isPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),

              // 確認密碼輸入框
              buildPasswordField(
                label: "確認密碼",
                hint: "需與上面的密碼一致",
                isVisible: _isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),

              const SizedBox(height: 20),

              // 變更密碼按鈕
              SizedBox(
                width: 372,
                height: 45,
                child: ElevatedButton(
                  onPressed: _showSuccessDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF669FA5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "變更密碼",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),

              // 返回登入畫面按鈕
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text(
                  "返回登入畫面",
                  style: TextStyle(
                    color: Color(0xFF669FA5),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
  required String label,
  required String hint,
  Widget? suffix,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        labelText: label, // 讓標籤顯示在輸入框內
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF669FA5),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never, // 防止標籤浮動到上方
        hintText: hint, // 顯示提示文字
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: suffix,
      ),
    ),
  );
}


  Widget buildPasswordField({
  required String label,
  required String hint,
  required bool isVisible,
  required VoidCallback toggleVisibility,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: TextField(
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label, // 讓標籤顯示在輸入框內
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF669FA5),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never, // 防止標籤浮動到上方
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    ),
  );
}


  Widget buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF669FA5),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
