import 'package:drw/frontend/headers/header2.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/forget_model.dart';
import 'login_page.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  late BuildContext myContext;
  @override
  Widget build(BuildContext context) {
    myContext = context;
    return ChangeNotifierProvider(
        create: (context) => Forget(),
        child: Builder(builder: (context) {
          final forget = Provider.of<Forget>(context);
          return Scaffold(
            backgroundColor: const Color(0xFFEAF8FA),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Header2(title: '忘記密碼'),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '帳號',
                            style: TextStyle(
                              color: Color(0xFF4A8C8F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (value) => forget.setEmail(value),
                              controller: _emailController,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: forget.isSending
                                ? null
                                : () async {
                                    final error = await forget.sendCode();
                                    if (error == null) {
                                      forget.showVerification = true;
                                      FrontUtil.showError(
                                          '驗證碼已寄出，請於電子郵件查看', Colors.green, Colors.white);
                                    } else {
                                      FrontUtil.showError(error, Colors.red, Colors.white);
                                    }
                                  },
                            style: TextButton.styleFrom(
                              backgroundColor: forget.isSending
                                  ? const Color.fromARGB(255, 189, 226, 231)
                                  : const Color(0xFF669FA5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            child: forget.isSending
                                ? const Text("傳送中...", style: TextStyle(color: Colors.white))
                                : const Text("傳送驗證碼", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: forget.showVerification ? Colors.white : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '驗證碼',
                            style: TextStyle(
                              color: Color(0xFF4A8C8F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              enabled: forget.showVerification,
                              onChanged: (value) => forget.setCode(value),
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: forget.showVerification
                                  ? () async {
                                      final error = await forget.verifyCode();
                                      if (error == null) {
                                        forget.showPassword = true;
                                        FrontUtil.showError(
                                            '驗證成功，請輸入新密碼', Colors.green, Colors.white);
                                      } else {
                                        FrontUtil.showError(error, Colors.red, Colors.white);
                                      }
                                    }
                                  : null,
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF669FA5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              child: const Text("驗證", style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: forget.showPassword ? Colors.white : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '新密碼',
                            style: TextStyle(
                              color: Color(0xFF4A8C8F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              obscureText: forget.hiddenPassword,
                              enabled: forget.showPassword,
                              onChanged: (value) => forget.setNewPassword(value),
                              controller: _rePasswordController,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              forget.hiddenPassword ? Icons.visibility_off : Icons.visibility,
                              color: const Color.fromRGBO(135, 135, 135, 0.5),
                            ),
                            onPressed: () {
                              forget.togglePasswordVisibility(); // 你要在 Forget class 裡定義這個方法
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: forget.showPassword ? Colors.white : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '確認密碼',
                            style: TextStyle(
                              color: Color(0xFF4A8C8F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              obscureText: forget.hiddenRePassword,
                              enabled: forget.showPassword,
                              onChanged: (value) => forget.setRePassword(value),
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                hintText: '',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              forget.hiddenRePassword ? Icons.visibility_off : Icons.visibility,
                              color: const Color.fromRGBO(135, 135, 135, 0.5),
                            ),
                            onPressed: () {
                              forget.toggleRePasswordVisibility(); // 你要在 Forget class 裡定義這個方法
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!forget.isFilled()) {
                            debugPrint("欄位未填寫");
                            FrontUtil.showError('尚有欄位未填寫', Colors.red, Colors.white);
                            return;
                          }

                          debugPrint("正在呼叫 resetPassword");
                          final error = await forget.resetPassword();

                          if (!mounted) return;

                          if (error == null) {
                            debugPrint("密碼修改成功，跳轉頁面");
                            Navigator.pushReplacement(
                              myContext,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                            FrontUtil.showError('密碼修改成功!', Colors.green, Colors.white);
                          } else {
                            debugPrint("重設密碼失敗：$error");
                            FrontUtil.showError(error, Colors.red, Colors.white);
                          }

                          debugPrint("forget 狀態：${forget.toString()}");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF669FA5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child:
                            const Text("變更密碼", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
