import 'package:flutter/material.dart';
import '../registerpage.dart';
import 'login.dart';
import '../headers/header_widget.dart';
import '../../feature/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // 定義 TextEditingController
  TextEditingController _emailController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  //驗證碼傳送
  void _sendVerificationCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage("請輸入 Email");
      return;
    }

    final result = await AuthService.sendVerificationCode(email);
    _showMessage(result);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Color.fromARGB(255, 30, 104, 96)),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  //驗證 驗證碼。
  void _verifyCode() async {
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();

    if (email.isEmpty || code.isEmpty) {
      _showMessage("請輸入 Email 和 驗證碼");
      return;
    }

    final result = await AuthService.verifyCode(email, code);

    if (result == '驗證碼正確') {
      _showMessage("驗證成功，請輸入新密碼");
      // setState(() {
      //   // 顯示密碼欄位與變更密碼按鈕
      //   _isCodeVerified = true;
      // });
    } else {
      _showMessage(result);
    }
  }

  // 密碼變更成功畫面
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF83B6BB),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "變更密碼成功",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(
              "Password changed successfully",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
              const HeaderWidget(title: "忘記密碼"),
              const SizedBox(height: 20),
              buildInputField(
                  label: "帳號",
                  hint: "example@gmail.com",
                  suffix: buildButton("傳送驗證碼", onPressed: _sendVerificationCode),
                  controller: _emailController), // 這裡傳遞 controller
              buildInputField(
                  label: "驗證碼",
                  hint: "請至電子郵件中取得驗證碼",
                  suffix: buildButton("驗證", onPressed: _verifyCode),
                  controller: _codeController), // 這裡傳遞 controller
              buildPasswordField(
                label: "新密碼",
                hint: "輸入 8-16 個英文/數字",
                isVisible: _isPasswordVisible,
                toggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                controller: _newPasswordController, // 這裡傳遞 controller
              ),
              buildPasswordField(
                label: "確認密碼",
                hint: "需與上面的密碼一致",
                isVisible: _isConfirmPasswordVisible,
                toggleVisibility: () =>
                    setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                controller: _confirmPasswordController, // 這裡傳遞 controller
              ),
              const SizedBox(height: 20),
              buildChangePasswordButton(),
              buildBackToLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// **變更密碼按鈕**
  Widget buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () async {
          final newPassword = _newPasswordController.text;
          final confirmPassword = _confirmPasswordController.text;

          if (newPassword != confirmPassword) {
            _showMessage("密碼不一致");
            return;
          }

          if (newPassword.length < 8 || newPassword.length > 16) {
            _showMessage("密碼長度需為 8-16 字元");
            return;
          }

          final result = await AuthService.resetPassword(
            _emailController.text.trim(),
            _codeController.text.trim(),
            newPassword,
          );

          if (result.contains("已更新")) {
            _showSuccessDialog();
          } else {
            _showMessage(result);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF669FA5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text("變更密碼", style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  /// **返回登入畫面按鈕**
  Widget buildBackToLoginButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        ),
        child: RichText(
          text: const TextSpan(
            text: "返回登入畫面",
            style: TextStyle(
              color: Color(0xFF669FA5),
              fontSize: 13,
              decoration: TextDecoration.underline, // 加上底線
              decorationColor: Color(0xFF669FA5), // 設定底線顏色
            ),
          ),
        ),
      ),
    );
  }

  /// **一般輸入框**
  Widget buildInputField({
    required String label,
    required String hint,
    Widget? suffix,
    required TextEditingController controller, // 新增 controller
  }) {
    return buildTextField(
      label: label,
      hint: hint,
      suffix: suffix,
      controller: controller, // 傳遞給 buildTextField
    );
  }

  /// **密碼輸入框**
  Widget buildPasswordField({
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    required TextEditingController controller, // 這裡也要傳遞 controller
  }) {
    return buildTextField(
      label: label,
      hint: hint,
      obscureText: !isVisible,
      suffix: IconButton(
        icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color.fromRGBO(135, 135, 135, 0.5)),
        onPressed: toggleVisibility,
      ),
      controller: controller, // 傳遞給 buildTextField
    );
  }

  /// **通用輸入框**
  Widget buildTextField({
    required String label,
    required String hint,
    bool obscureText = false,
    Widget? suffix,
    required TextEditingController controller, // 新增 controller
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller, // 綁定 controller
        obscureText: obscureText,
        style: const TextStyle(
          color: Color(0xFF669FA5),
          fontSize: 15,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF669FA5)),
          hintText: hint,
          hintStyle: const TextStyle(color: Color.fromRGBO(135, 135, 135, 0.4), fontSize: 14),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Colors.white,
          border: _inputBorder(),
          enabledBorder: _inputBorder(),
          focusedBorder: _inputBorder(),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  /// **輸入框邊框樣式**
  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }

  /// **可點擊按鈕**
  Widget buildButton(String text, {VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextButton(
        onPressed: onPressed ?? () {},
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 125, 182, 189),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
