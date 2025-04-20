import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wounddetection/feature/database.dart';

class AccountSetupSection extends StatefulWidget {
  const AccountSetupSection({super.key});

  @override
  _AccountSetupSectionState createState() => _AccountSetupSectionState();
}

class _AccountSetupSectionState extends State<AccountSetupSection> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isVerificationEnabled = false;

  @override
  void initState() {
    super.initState();
    DatabaseHelper.userInfo["email"] = "";
    DatabaseHelper.userInfo["password"] = "";
    DatabaseHelper.userInfo["confirm"] = "";
    _emailController.addListener(() {
      DatabaseHelper.userInfo["email"] = _emailController.text;
    });
    _passwordController.addListener(() {
      DatabaseHelper.userInfo["password"] = _passwordController.text;
    });
    _confirmPasswordController.addListener(() {
      DatabaseHelper.userInfo["confirm"] = _confirmPasswordController.text;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '帳密設置',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF669FA5),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Email',
                  hint: 'example@gmail.com',
                  controller: _emailController,
                ),
              ),
              const SizedBox(width: 9),
              ElevatedButton(
                onPressed: () {
                  // if (emailError == null) {
                  //   setState(() {
                  //     _isVerificationEnabled = true;
                  //   });
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('驗證碼已發送')),
                  //   );
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text(emailError)),
                  //   );
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF669FA5),
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 11),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('傳送驗證碼', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: '驗證碼',
                  hint: '請輸入驗證碼',
                  controller: _verificationCodeController,
                  isNumeric: true,
                  isEnabled: _isVerificationEnabled,
                  validator: _validateVerificationCode,
                ),
              ),
              const SizedBox(width: 9),
              ElevatedButton(
                onPressed: _isVerificationEnabled
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('驗證碼驗證成功')),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isVerificationEnabled ? const Color(0xFF669FA5) : Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 2.25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('驗證', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: '密碼',
            hint: '請設定8-16個英文/數字',
            controller: _passwordController,
            isPassword: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: '確認密碼',
            hint: '需與上面密碼一致',
            controller: _confirmPasswordController,
            isPassword: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool isNumeric = false,
    bool isEnabled = true,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF669FA5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF669FA5),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isPassword,
              enabled: isEnabled,
              keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
              inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
              style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 61, 103, 108)),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFFA5A1A1), fontSize: 14),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              validator: validator,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
            ),
          ),
        ],
      ),
    );
  }

  String? _validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) return '請輸入驗證碼';
    if (value.length != 6) return '驗證碼需為 6 位數';
    return null;
  }
}
