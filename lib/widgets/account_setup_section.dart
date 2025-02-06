import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountSetupSection extends StatefulWidget {
  const AccountSetupSection({super.key});

  @override
  _AccountSetupSectionState createState() => _AccountSetupSectionState();
}

class _AccountSetupSectionState extends State<AccountSetupSection> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isVerificationEnabled = false; // 控制驗證碼輸入框

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // 綁定表單
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '帳密設置',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF669FA5),
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
                  validator: _validateEmail,
                ),
              ),
              const SizedBox(width: 9),
              ElevatedButton(
                onPressed: () {
                  final emailError = _validateEmail(_emailController.text);
                  if (emailError == null) {
                    setState(() {
                      _isVerificationEnabled = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('驗證碼已發送')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(emailError)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF669FA5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 11),
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '傳送驗證碼',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// 驗證碼輸入欄位
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: '驗證碼',
                  hint: '請輸入驗證碼',
                  controller: _verificationCodeController,
                  isNumeric: true,
                  isEnabled: _isVerificationEnabled, // 只有點擊「傳送驗證碼」後才能輸入
                  validator: _validateVerificationCode,
                ),
              ),
              const SizedBox(width: 9),
              ElevatedButton(
                onPressed: _isVerificationEnabled
                    ? () {
                        // 這裡可以加上驗證碼檢查邏輯
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('驗證碼驗證成功')),
                        );
                      }
                    : null, // 沒有啟用時按鈕無效
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isVerificationEnabled
                      ? const Color(0xFF669FA5)
                      : Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.25,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '驗證',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// 密碼輸入欄位  
          /// 密碼的防呆機制要再重新用
          _buildTextField(
            label: '密碼',
            hint: '請設定8-16個英文/數字',
            controller: _passwordController,
            isPassword: true,
            validator: _validatePassword,
            onChanged: (value) {
              final validationMessage = _validatePassword(value);
              if (validationMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(validationMessage)),
                );
              }
            },
          ),
          const SizedBox(height: 16),

          /// 確認密碼輸入欄位
          _buildTextField(
            label: '確認密碼',
            hint: '需與上面密碼一致',
            controller: _confirmPasswordController,
            isPassword: true,
            validator: (value) =>
                _validateConfirmPassword(value, _passwordController.text),
            onChanged: (value) {
              final validationMessage =
                  _validateConfirmPassword(value, _passwordController.text);
              if (validationMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(validationMessage)),
                );
              }
            },
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
    void Function(String)? onChanged, // 新增的回調
    void Function(String)? onFieldSubmitted, // 新增的回調
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft, // 讓標籤靠左
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF669FA5),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Align(
              alignment: Alignment.center, // 讓輸入框內容與標籤對齊
              child: TextFormField(
                controller: controller,
                obscureText: isPassword,
                enabled: isEnabled,
                keyboardType:
                    isNumeric ? TextInputType.number : TextInputType.text,
                inputFormatters:
                    isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
                style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 61, 103, 108)), // 調整輸入文字大小與標籤一致
                textAlignVertical: TextAlignVertical.center, // 讓輸入內容垂直居中
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Color(0xFFA5A1A1),
                    fontSize: 14, // 設定與標籤相同的大小
                  ),
                  border: InputBorder.none,
                  isCollapsed: true, // 讓 hintText 緊貼 TextFormField，防止偏移
                ),
                validator: validator,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 驗證 Email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入 Email';
    }
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(value)) {
      return '請輸入有效的 Email 格式';
    }
    return null;
  }

  /// 驗證驗證碼（需為 6 位數字）
  String? _validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入驗證碼';
    }
    if (value.length != 6) {
      return '驗證碼需為 6 位數';
    }
    return null;
  }

  /// 驗證密碼
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入密碼';
    }
    if (value.length < 8 || value.length > 16) {
      return '密碼長度需為 8-16 個字符';
    }
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$');
    if (!passwordRegex.hasMatch(value)) {
      return '密碼需包含英文字母與數字';
    }
    return null;
  }

  /// 驗證確認密碼
  String? _validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '請輸入確認密碼';
    }
    if (value != password) {
      return '密碼不一致，請重新輸入';
    }
    return null;
  }
}
