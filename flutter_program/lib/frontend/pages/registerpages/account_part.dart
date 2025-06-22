import 'package:drw/frontend/tools/front_tool.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; //用於顯示數字鍵盤
import '../../../backend/models/register_model.dart';
import '../login_page.dart';

class AccountSetup extends StatefulWidget {
  const AccountSetup({super.key});

  @override
  State<AccountSetup> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final register = Provider.of<Register>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '帳密設置',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF669FA5),
            letterSpacing: 2,
            height: 3.5,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFB2DFDB)),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF669FA5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        onChanged: (value) => register.setEmail(value),
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'example@gmail.com',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Consumer<Register>(builder: (context, register, _) {
              return ElevatedButton(
                onPressed: register.isSending
                    ? null
                    : () async {
                        final error = await register.sendCode();
                        if (error == null) {
                          register.showVerification = true;
                          FrontTool.showError('驗證碼已寄出，請於電子郵件查看', Colors.green, Colors.white);
                        } else {
                          FrontTool.showError(error, Colors.red, Colors.white);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF669FA5),
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 14),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  register.isSending ? '傳送中...' : '傳送驗證碼',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            })
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: Consumer<Register>(builder: (context, register, _) {
              return Container(
                decoration: BoxDecoration(
                  color: register.showVerification ? Colors.white : Colors.grey[200],
                  border: Border.all(color: const Color(0xFFB2DFDB)),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Text(
                      '驗證碼',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF669FA5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: TextField(
                      enabled: register.showVerification,
                      controller: _codeController,
                      onChanged: (value) => register.setCode(value),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: '輸入驗證碼',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                    ))
                  ],
                ),
              );
            })),
            const SizedBox(width: 8),
            Consumer<Register>(builder: (context, register, _) {
              return ElevatedButton(
                onPressed: register.showVerification
                    ? () async {
                        final error = await register.verifyCode();
                        if (error == null) {
                          register.showPassword = true;
                          FrontTool.showError('驗證碼成功!請設定密碼', Colors.green, Colors.white);
                        } else {
                          FrontTool.showError(error, Colors.red, Colors.white);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF669FA5),
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 14),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  '驗證',
                  style: TextStyle(color: Colors.white),
                ),
              );
            })
          ],
        ),
        const SizedBox(height: 15),
        Consumer<Register>(builder: (context, register, _) {
          return Container(
            decoration: BoxDecoration(
              color: register.showPassword ? Colors.white : Colors.grey[200],
              border: Border.all(color: const Color(0xFFB2DFDB)),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  '密碼',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF669FA5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: TextField(
                  enabled: register.showPassword,
                  controller: _passwordController,
                  onChanged: (value) => register.setPassword(value),
                  obscureText: register.hiddenPassword,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: '請輸入8至16位的英文及數字',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.only(top: 12),
                    border: InputBorder.none,
                    isCollapsed: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        register.hiddenPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: register.togglehiddenPassword,
                    ),
                  ),
                )),
              ],
            ),
          );
        }),
        const SizedBox(height: 15),
        Consumer<Register>(builder: (context, register, _) {
          return Container(
            decoration: BoxDecoration(
              color: register.showPassword ? Colors.white : Colors.grey[200],
              border: Border.all(color: const Color(0xFFB2DFDB)),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  '確認密碼',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF669FA5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: TextField(
                  enabled: register.showPassword,
                  controller: _rePasswordController,
                  onChanged: (value) => register.setrePassword(value),
                  obscureText: register.hiddenrePassword,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: '需與上方密碼一致',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.only(top: 12),
                    border: InputBorder.none,
                    isCollapsed: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        register.hiddenrePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: register.togglehiddenRePassword,
                    ),
                  ),
                )),
              ],
            ),
          );
        }),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
            width: double.infinity,
            child: Consumer<Register>(builder: (context, register, _) {
              return ElevatedButton(
                  onPressed: register.isRegistering
                      ? null
                      : () async {
                          if (!register.isFilled()) {
                            FrontTool.showError('尚有欄位未填寫', Colors.red, Colors.white);
                            return;
                          }
                          final error = await register.register();
                          if (!context.mounted) return; //確認 widget 還在畫面上，才繼續操作 context
                          if (error == null) {
                            FrontTool.showError('註冊成功!請登入帳號', Colors.green, Colors.white);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const LoginPage()));
                          } else {
                            FrontTool.showError(error, Colors.red, Colors.white);
                          }
                          debugPrint(register.toString());
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF669FA5),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    minimumSize: const Size(100, 20), // 設定按鈕最小寬度 200，高度 50
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: register.isRegistering
                      ? const Text(
                          '註冊中...',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          '註冊',
                          style: TextStyle(color: Colors.white),
                        ));
            })),
      ],
    );
  }
}
