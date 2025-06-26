import 'package:drw/backend/models/changepwd_model.dart';
import 'package:drw/backend/models/user_model.dart';
import 'package:drw/frontend/headers/header4.dart';
import 'package:drw/frontend/pages/tabs/personal_page.dart';
import 'package:drw/frontend/pages/tabs/tabs.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/views/auth_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePwdPage extends StatefulWidget {
  final String userPassword;
  const ChangePwdPage({super.key, required this.userPassword});

  @override
  State<ChangePwdPage> createState() => _ChangePwdPageState();
}

class _ChangePwdPageState extends State<ChangePwdPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ChangePwd(),
        child: Builder(
          builder: (context) {
            final changePwd = Provider.of<ChangePwd>(context);
            return Scaffold(
              backgroundColor: const Color(0xFFF2FEFF),
              body: Column(
                children: [
                  const Header4(title: "變更密碼", nextPage: PersonalPage()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                    child: Column(
                      children: [
                        // 原密碼欄位
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '密碼',
                                style: TextStyle(
                                  color: Color(0xFF4A8C8F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  onChanged: (value) => changePwd.setPwd(value),
                                  obscureText: changePwd.hiddenPassword,
                                  decoration: const InputDecoration(
                                    hintText: '請先輸入原始密碼以確認身份',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    changePwd.hiddenPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color.fromRGBO(135, 135, 135, 0.5),
                                  ),
                                  onPressed: () {
                                    changePwd.togglePwdVisibility();
                                  }),
                            ],
                          ),
                        ),

                        // 新密碼欄位
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                              ),
                            ],
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
                                  controller: _newPasswordController,
                                  onChanged: (value) => changePwd.setNewPwd(value),
                                  obscureText: changePwd.hiddenNewPassword,
                                  decoration: const InputDecoration(
                                    hintText: '輸入8~16英文加數字',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  changePwd.hiddenNewPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color.fromRGBO(135, 135, 135, 0.5),
                                ),
                                onPressed: () {
                                  changePwd.toggleNewPwdVisibility();
                                },
                              ),
                            ],
                          ),
                        ),

                        // 再次輸入密碼欄位
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                              ),
                            ],
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
                                  controller: _rePasswordController,
                                  onChanged: (value) => changePwd.setRePwd(value),
                                  obscureText: changePwd.hiddenRePassword,
                                  decoration: const InputDecoration(
                                    hintText: '需與新密碼相同',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  changePwd.hiddenRePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color.fromRGBO(135, 135, 135, 0.5),
                                ),
                                onPressed: () {
                                  changePwd.toggleRePwdVisibility();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!changePwd.isFilled()) {
                                FrontUtil.showError('請填寫完所有欄位', Colors.red, Colors.white);
                                return;
                              }
                              final user = Provider.of<User>(context, listen: false);
                              String? error;
                              error = await changePwd.verifyPassword(user.id);
                              if (error == null) {
                                if (!Auth.validatePassword(changePwd.newPwd)) {
                                  FrontUtil.showError(
                                      '新密碼請設定長度為8-16的英文加數字組合', Colors.red, Colors.white);
                                  return;
                                }
                                if (!Auth.verifyPassword(changePwd.newPwd, changePwd.rePwd)) {
                                  FrontUtil.showError('密碼不一致', Colors.red, Colors.white);
                                  return;
                                }
                                error = await changePwd.updatePassword(user.id);
                                if (error == null) {
                                  FrontUtil.showError('密碼修改成功!', Colors.green, Colors.white);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Tabs(
                                        currentIndex: 4,
                                      ),
                                    ),
                                  );
                                } else {
                                  FrontUtil.showError(error, Colors.red, Colors.white);
                                }
                              } else {
                                FrontUtil.showError(error, Colors.red, Colors.white);
                              }
                              debugPrint(changePwd.toString());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF669FA5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "確定",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                letterSpacing: 1.8,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
