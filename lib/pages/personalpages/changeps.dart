import 'package:flutter/material.dart';
import 'package:wounddetection/pages/tabs.dart';
import 'package:wounddetection/pages/tabs/personpage.dart';
import '../headers/header_2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../feature/database.dart';

class ChangePsPage extends StatefulWidget {
  final String userPassword;
  const ChangePsPage({super.key, required this.userPassword});

  @override
  State<ChangePsPage> createState() => _ChangePsPageState();
}

class _ChangePsPageState extends State<ChangePsPage> {
  bool _obscureText = true;
  final List<String> _title = ["請輸入密碼", "請輸入新密碼", "請再次輸入密碼"];
  final List<String> _hint = ["請先輸入原始密碼以確認身份", "輸入8~16英文加數字", "需與上一步密碼相同"];
  int _index = 0;
  String _errorMessage = "";
  final TextEditingController _textController = TextEditingController(); // 新增 Controller
  final List<String> _password = ["", "", ""];
  bool _isLoading = false;

  // 密碼驗證函式
  bool _isValidPassword(String password) {
    final RegExp regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$');
    return regex.hasMatch(password);
  }

  Future<void> _updatePassword() async {
    setState(() {
      _isLoading = true;
    });

    String? userId = await DatabaseHelper.getUserId();
    String newPassword = _password[_index];

    if (userId == null) {
      Fluttertoast.showToast(msg: "無法獲取使用者 ID，請重新登入");
      setState(() => _isLoading = false);
      return;
    }

    bool success = await DatabaseHelper.updatePassword(userId, newPassword);

    if (!mounted) return; // 防止異步錯誤

    setState(() => _isLoading = false);

    if (success) {
      DatabaseHelper.userInfo['password'] = newPassword;
      Fluttertoast.showToast(msg: "修改成功");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Tabs(currentIndex: 4,)),
      );
    } else {
      Fluttertoast.showToast(msg: "修改失敗，請稍後再試");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FEFF),
      body: Column(
        children: [
          const HeaderPage2(title: "變更密碼"),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    _title[_index],
                    style: const TextStyle(
                      height: 3,
                      fontSize: 25,
                      color: Color(0xFF669FA5),
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 對齊左側，確保錯誤訊息對齊輸入框
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // 背景色
                        borderRadius: BorderRadius.circular(10), // 圓角
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _textController,
                        obscureText: _obscureText,
                        onChanged: (value) {
                          _password[_index] = value;
                          setState(() {
                            if (_index == 1) {
                              if (_isValidPassword(value)) {
                                _errorMessage = ""; // 驗證成功
                              } else {
                                _errorMessage = "密碼需包含英文字母及數字，且長度為 8~16 位";
                              }
                            } else {
                              _errorMessage = ""; // 其他情況不顯示錯誤訊息
                            }
                          });
                        },
                        decoration: InputDecoration(
                          hintText: _hint[_index],
                          hintStyle: TextStyle(color: Colors.grey[400]), // 提示文字顏色
                          filled: true, // 使填充顏色生效
                          fillColor: Colors.white, // 背景顏色
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), // 圓角
                            borderSide: BorderSide.none, // 移除邊框
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText; // 切換顯示/隱藏密碼
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty) // 如果有錯誤訊息才顯示，避免多餘空間
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 5), // 稍微內縮與間距
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF669FA5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_index == 0) {
                              if (_password[_index] != widget.userPassword) {
                                _errorMessage = "密碼錯誤";
                              } else {
                                _index += 1;
                                _textController.clear();
                              }
                            } else if (_index == 1) {
                              if (_isValidPassword(_password[_index])) {
                                _index += 1;
                                _textController.clear();
                              } else {
                                _errorMessage = "密碼需包含英文字母及數字，且長度為 8~16 位";
                              }
                            } else if (_index == 2) {
                              if (_password[_index] == _password[_index - 1]) {
                                _updatePassword();
                              } else {
                                _errorMessage = "密碼錯誤";
                              }
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "確定",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
