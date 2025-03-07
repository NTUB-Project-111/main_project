import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF669FA5)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "註冊帳戶",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF669FA5),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildTitle("個人資料"),
            _buildTextField(label: "姓名", hintText: "本名 or 暱稱"),
            const SizedBox(height: 10),
            _buildTextField(label: "生日", hintText: "XXXX/XX/XX"),
            const SizedBox(height: 10),
            _buildGenderSelection(),
            const SizedBox(height: 20),
            _buildDivider(),
            _buildTitle("帳密設定"),
            _buildTextField(label: "Email", hintText: "example@gmail.com"),
            const SizedBox(height: 10),
            _buildEmailVerification(),
            const SizedBox(height: 10),
            _buildPasswordField(label: "密碼", isConfirm: false),
            const SizedBox(height: 10),
            _buildPasswordField(label: "確認密碼", isConfirm: true),
            const SizedBox(height: 20),
            _buildDivider(),
            _buildTitle("驗證碼"),
            _buildVerificationCodeField(),
            const SizedBox(height: 20),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  // **標題**
  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF669FA5),
      ),
    );
  }

  // **輸入框**
  Widget _buildTextField({required String label, required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF669FA5)),
        ),
        const SizedBox(height: 5),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  // **密碼輸入框**
  Widget _buildPasswordField({required String label, required bool isConfirm}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF669FA5)),
        ),
        const SizedBox(height: 5),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: TextField(
            obscureText:
                isConfirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "請設定 8-16 個英文/數字",
              hintStyle: const TextStyle(color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  isConfirm
                      ? (_isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off)
                      : (_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (isConfirm) {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    } else {
                      _isPasswordVisible = !_isPasswordVisible;
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // **性別選擇**
  Widget _buildGenderSelection() {
    return Row(
      children: [
        _buildGenderOption("女"),
        _buildGenderOption("男"),
        _buildGenderOption("其他"),
      ],
    );
  }

  Widget _buildGenderOption(String text) {
    return Row(
      children: [
        Radio(value: text, groupValue: "性別", onChanged: (value) {}),
        Text(text),
        const SizedBox(width: 10),
      ],
    );
  }

  // **Email 驗證**
  Widget _buildEmailVerification() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(label: "驗證碼", hintText: "請輸入驗證碼"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF669FA5),
          ),
          onPressed: () {
            print("發送驗證碼");
          },
          child: const Text("發送驗證碼", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // **驗證碼輸入框**
  Widget _buildVerificationCodeField() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "請輸入右側驗證碼",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Image.asset(
          'assets/captcha.png',
          width: 100,
          height: 50,
        ),
      ],
    );
  }

  // **註冊按鈕**
  Widget _buildRegisterButton() {
    return Center(
      child: Container(
        width: 372,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFF669FA5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () {
            print("註冊");
          },
          child: const Text("註冊",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }

  // **分隔線**
  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF669FA5),
      thickness: 1.5,
    );
  }
}
