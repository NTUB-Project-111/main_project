import 'package:drw/frontend/widgets/headers/header2.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/viewmodels/forget_view_model.dart';
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Center(
                      child: Header2(title: '忘記密碼'),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 帳號欄位
                  _buildInputContainer(
                    child: Row(
                      children: [
                        const Text('帳號',
                            style: TextStyle(
                                color: Color(0xFF669FA5),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            onChanged: forget.setEmail,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 88, 136, 142),
                            ),
                            decoration: InputDecoration(
                              hintText: 'example@gmail.com',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.4),
                              ),
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
                                    FrontUtil.showSuccess('傳送成功');
                                  } else {
                                    FrontUtil.showFail("無法寄出，請確認帳號是否有誤");
                                  }
                                },
                          style: TextButton.styleFrom(
                            backgroundColor: forget.isSending
                                ? const Color(0xFFBDDEE2)
                                : const Color(0xFF669FA5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          child: Text(
                            forget.isSending ? '傳送中...' : '傳送驗證碼',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),

                  // 驗證碼欄位
                  _buildInputContainer(
                    backgroundColor: forget.showVerification
                        ? Colors.white
                        : Colors.grey[200],
                    child: Row(
                      children: [
                        const Text('驗證碼',
                            style: TextStyle(
                                color: Color(0xFF669FA5),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _codeController,
                            onChanged: forget.setCode,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 88, 136, 142),
                            ),
                            keyboardType: TextInputType.number,
                            enabled: forget.showVerification,
                            decoration: InputDecoration(
                              hintText: '請至電子郵件中取得驗證碼',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.4),
                              ),
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
                                    FrontUtil.showSuccess('驗證成功，請輸入新密碼');
                                  } else {
                                    FrontUtil.showFail("驗證失敗");
                                  }
                                }
                              : null,
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF669FA5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          child: const Text("驗證",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                        )
                      ],
                    ),
                  ),

                  // 新密碼欄位
                  _buildInputContainer(
                    backgroundColor:
                        forget.showPassword ? Colors.white : Colors.grey[200],
                    child: Row(
                      children: [
                        const Text('新密碼',
                            style: TextStyle(
                                color: Color(0xFF669FA5),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            onChanged: forget.setNewPassword,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 88, 136, 142),
                            ),
                            enabled: forget.showPassword,
                            obscureText: forget.hiddenPassword,
                            decoration: InputDecoration(
                              hintText: '輸入8-16個英文/數字',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            forget.hiddenPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color.fromRGBO(135, 135, 135, 0.5),
                          ),
                          onPressed: forget.togglePasswordVisibility,
                        )
                      ],
                    ),
                  ),

                  // 確認密碼欄位
                  _buildInputContainer(
                    backgroundColor:
                        forget.showPassword ? Colors.white : Colors.grey[200],
                    child: Row(
                      children: [
                        const Text('確認密碼',
                            style: TextStyle(
                                color: Color(0xFF669FA5),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _rePasswordController,
                            onChanged: forget.setRePassword,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 88, 136, 142),
                            ),
                            enabled: forget.showPassword,
                            obscureText: forget.hiddenRePassword,
                            decoration: InputDecoration(
                              hintText: '需與上面的密碼一致',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            forget.hiddenRePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color.fromRGBO(135, 135, 135, 0.5),
                          ),
                          onPressed: forget.toggleRePasswordVisibility,
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 變更密碼按鈕
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!forget.isFilled()) {
                            FrontUtil.showFail('尚有欄位未填寫');
                            return;
                          }
                          final error = await forget.resetPassword();
                          if (!mounted) return;

                          if (error == null) {
                            Navigator.pushReplacement(
                              myContext,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                            FrontUtil.showSuccess('密碼修改成功!');
                          } else {
                            FrontUtil.showFail('變更失敗!');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF669FA5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("變更密碼",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 靠右的返回登入按鈕
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        '返回登入畫面',
                        style: TextStyle(
                          color: Color(0xFF4A8C8F),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInputContainer({required Widget child, Color? backgroundColor}) {
    return FractionallySizedBox(
      widthFactor: 0.88,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}
