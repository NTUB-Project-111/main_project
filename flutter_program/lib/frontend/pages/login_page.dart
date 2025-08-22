import 'package:drw/backend/provider/remind_provider.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/frontend/utility/notifier_util.dart';
import 'forget_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/login_model.dart';
import '../headers/header2.dart';
import 'registerpages/disclaimer_page.dart';
import 'tabs/tabs.dart';
import '../../backend/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  late BuildContext myContext;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myContext = context;
    return ChangeNotifierProvider(
        create: (context) => Login(),
        child: Builder(builder: (context) {
          final login = Provider.of<Login>(context);
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 229, 248, 248),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Header2(
                      title: "Dr.W",
                      subtitle: '一拍即知，智慧照護',
                    ),
                    const SizedBox(height: 15),

                    // 帳號輸入
                    TextField(
                      controller: _emailController,
                      onChanged: (value) => login.setEmail(value),
                      style: const TextStyle(
                        color: Color(0xFF669FA5),
                      ),
                      decoration: _inputDecoration(label: "帳號", hint: "example@gmail.com"),
                    ),
                    const SizedBox(height: 10),

                    // 密碼輸入
                    TextField(
                      controller: _passwordController,
                      onChanged: (value) => login.setPassword(value),
                      obscureText: _obscureText,
                      style: const TextStyle(
                        color: Color(0xFF669FA5),
                      ),
                      decoration: _inputDecoration(label: "密碼", hint: "XXXXXXXXXXXX").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: const Color.fromRGBO(135, 135, 135, 0.5),
                          ),
                          onPressed: () => setState(() => _obscureText = !_obscureText),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 忘記密碼 / 訪客登入
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ForgetPage()),
                            );
                          },
                          child: const Text("忘記密碼？", style: TextStyle(color: Color(0xFF669FA5))),
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     final userProvider = Provider.of<UserProvider>(
                        //         context,
                        //         listen: false);

                        //     userProvider.setUserInfo(UserInfo(
                        //       id: -1,
                        //       name: '訪客',
                        //       gender: '未知',
                        //       birthday: '2000',
                        //       picture: '',
                        //       email: '',
                        //       disease: '無',
                        //       freq: '每天',
                        //       reports: [],
                        //     ));

                        //     // ✅ 新增：清空診斷報告與提醒
                        //     Provider.of<ReportProvider>(context, listen: false)
                        //         .setReports([]);
                        //     Provider.of<RemindProvider>(context, listen: false)
                        //         .setReminds([]);

                        //     Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => const Tabs()),
                        //     );
                        //   },
                        //   child: const Text(
                        //     "訪客登入",
                        //     style: TextStyle(
                        //       color: Color(0xFF4C7488),
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // )

                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DisclaimerPage()),
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

                    // 登入按鈕
                    Consumer<Login>(builder: (context, login, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: login.isLoading
                              ? null
                              : () async {
                                  if (!login.isFilled()) {
                                    FrontUtil.showFail('請填寫帳號及密碼');
                                    return;
                                  }
                                  final error = await login.login(login.email, login.password);
                                  if (!mounted) return;
                                  if (error) {
                                    // 1. 從後端取得完整使用者資料
                                    final userInfo =
                                        await UserService.fetchUserInfo(login.accessToken!);

                                    // 2. 儲存使用者資料
                                    Provider.of<UserProvider>(context, listen: false)
                                        .setUserInfo(userInfo);

                                    // 3. 儲存診斷報告
                                    Provider.of<ReportProvider>(context, listen: false)
                                        .setReports(userInfo.reports);

                                    // 4. 提取所有提醒並儲存
                                    final allReminds =
                                        userInfo.reports.expand((r) => r.reminds).toList();
                                    Provider.of<RemindProvider>(context, listen: false)
                                        .setReminds(allReminds);
                                    Notifier.setRemind(context);
                                    // 打印診斷報告與每筆報告底下的提醒
                                    debugPrint(userInfo.toString());
                                    for (var report in userInfo.reports) {
                                      debugPrint("====== 報告 ======");
                                      debugPrint("報告ID：${report.id}");
                                      debugPrint("日期：${report.date}");
                                      debugPrint("類型：${report.type}");
                                      debugPrint("照護方式：${report.caremode}");
                                      debugPrint("是否提醒：${report.ifcall}");
                                      debugPrint("備註：${report.recording}");

                                      // 每一筆提醒
                                      for (var remind in report.reminds) {
                                        debugPrint("  -> 提醒ID：${remind.id}");
                                        debugPrint("     日期：${remind.date}");
                                        debugPrint("     時間：${remind.time}");
                                        debugPrint("     頻率：${remind.freq}");
                                      }
                                    }

                                    FrontUtil.showSuccess('登入成功!');
                                    if (!mounted) return;
                                    Navigator.pushReplacement(
                                      myContext,
                                      MaterialPageRoute(builder: (context) => const Tabs()),
                                    );
                                  } else {
                                    debugPrint('email:${login.email} psd:${login.password}');
                                    FrontUtil.showFail(
                                      '登入失敗，帳號或密碼輸入錯誤',
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF669FA5),
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: login.isLoading
                              ? const Text("登入中...",
                                  style: TextStyle(color: Colors.white, fontSize: 16))
                              : const Text("登入",
                                  style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      );
                    }),
                    // const SizedBox(height: 15),
                    // TextButton(
                    //   onPressed: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const DisclaimerPage()),
                    //   ),
                    //   child: const Text(
                    //     "註冊新帳號",
                    //     style: TextStyle(
                    //       color: Color(0xFF4C7488),
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 14,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  InputDecoration _inputDecoration({required String label, required String hint}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(color: Color.fromRGBO(135, 135, 135, 0.4), fontSize: 14),
      labelStyle:
          const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF669FA5)),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    );
  }
}
