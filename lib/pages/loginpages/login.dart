import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //匯入 http 套件
import 'package:wounddetection/font_awesome5_icons.dart';
import '../../feature/ApiHelper.dart';
import '../../feature/notifer.dart';
import '../registerpage.dart';
import '../tabs.dart';
import 'reset_password.dart'; // ✅ 引入變更密碼畫面
import '../headers/header_widget.dart';
import '../../font_awesome5_icons.dart';
import 'package:wounddetection/feature/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

// 要能取得 email 和 password，需要用 TextEditingController
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showMessage("請輸入帳號與密碼");
      return;
    }
    final url = Uri.parse('${DatabaseHelper.baseUrl}/loginUser');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // 從回傳資料抓 access token 與 refresh token
        final String token = responseData['token'];
        final String refreshToken = responseData['refreshToken'];

        // 儲存 access token 與 refresh token 到 SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwtToken', token);
        await prefs.setString('refreshToken', refreshToken);

        // 解 JWT 取得 userID
        Map<String, dynamic> payload;
        try {
          payload = _parseJwt(token);
        } catch (e) {
          _showMessage("無效的 token 格式");
          return;
        }
        final String userID = payload['userID'].toString();
        await prefs.setString('userId', userID);
        print("從 token 解出來的 userID: $userID");

        // 載入使用者資料
        await _loadUserData(userID);

        // 導向主頁
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
      } else {
        String errorMessage = '登入失敗';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {}
        _showMessage(errorMessage);
      }
    } catch (e) {
      _showMessage('發生錯誤：$e');
    }
  }

  Future<void> _loadUserData(String userID) async {
    // 先嘗試用 ApiHelper 的 get 方法（裡面會幫你自動檢查和續期 token）
    final response = await ApiHelper.get('/getUserInfo');

    if (response == null || response.statusCode != 200) {
      // token 過期且無法續期或其他錯誤，導向登入或註冊頁
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    final userInfo = jsonDecode(response.body);
    DatabaseHelper.userInfo = userInfo;
    debugPrint('使用者資訊載入成功');

    final records = await DatabaseHelper.getUserRecords();
    if (records != null) {
      DatabaseHelper.allRecords = records;
      checkRecord(records);
      debugPrint('診斷紀錄載入成功');
    }
    final calls = await DatabaseHelper.getReminds();
    if (calls != null) {
      DatabaseHelper.allCalls = calls;
      debugPrint('護理提醒載入成功');
    }
    final remindRecord = await DatabaseHelper.getRemindRecord();
    if (remindRecord != null) {
      DatabaseHelper.remindRecords = remindRecord;
      debugPrint('提醒紀錄載入成功');
    }
    final homeRemind = await DatabaseHelper.getHomeRemind();
    if (homeRemind != null) {
      DatabaseHelper.homeRemind = homeRemind;
      debugPrint('首頁提醒載入成功');
    }
  }

  Future<void> checkRecord(List<Map<String, dynamic>> userRecords) async {
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    for (int i = 0; i < userRecords.length; i++) {
      if (userRecords[i]["ifcall"] == "Y") {
        List<String> oktimeList = userRecords[i]["oktime"].split("~");
        DateTime startDate = DateTime.parse(userRecords[i]["date"]);
        int durationDays = int.parse(oktimeList[1]);
        DateTime endTime = startDate.add(Duration(days: durationDays));
        if (today.isAfter(endTime)) {
          userRecords[i]["ifcall"] = "N";
          await DatabaseHelper.deleteRemind(
              userRecords[i]["fk_userid"].toString(), userRecords[i]["id_record"].toString());
          await DatabaseHelper.updateRecord(
              userRecords[i]["id_record"].toString(), userRecords[i]["fk_userid"].toString(), "N");
          await Notifier.cancelAllReminders();
          await Notifier.debugPrintAllScheduledReminders();
        }
      }
    }
  }

  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('無效的 JWT');
    }

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return jsonDecode(payload);
  }

  // 錯誤訊息彈窗
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('登入失敗'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 248, 248),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HeaderWidget(
                title: "Dr.W",
                subtitle: '一拍即知，智慧照護',
              ),
              const SizedBox(height: 15),

              // ✅ 帳號輸入
              TextField(
                controller: _emailController,
                style: const TextStyle(
                  color: Color(0xFF669FA5),
                ),
                decoration: _inputDecoration(label: "帳號", hint: "example@gmail.com"),
              ),
              const SizedBox(height: 10),

              // ✅ 密碼輸入
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                style: const TextStyle(
                  color: Color(0xFF669FA5),
                ),
                decoration: _inputDecoration(label: "密碼", hint: "XXXXXXXXXXXX").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromRGBO(135, 135, 135, 0.5)),
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
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                    ),
                    child: const Text("忘記密碼？", style: TextStyle(color: Color(0xFF669FA5))),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Tabs(),
                      ),
                    ),
                    child: const Text(
                      "訪客登入",
                      style: TextStyle(
                        color: Color(0xFF4C7488),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),

              // ✅ 登入按鈕
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF669FA5),
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("登入", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),

              // 分隔線
              const Row(
                children: [
                  Expanded(
                      child: Divider(
                          color: Color(0xFF4C7488), thickness: 1, indent: 10, endIndent: 10)),
                  Text("其他方式", style: TextStyle(fontSize: 12, color: Color(0xFF4C7488))),
                  Expanded(
                      child: Divider(
                          color: Color(0xFF4C7488), thickness: 1, indent: 10, endIndent: 10)),
                ],
              ),
              const SizedBox(height: 20),

              // 社群登入按鈕
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(FontAwesome5.facebook_square, const Color(0xFF4C7488)),
                  _buildSocialButton(FontAwesome5.google_plus_square, const Color(0xFF4C7488)),
                  _buildSocialButton(FontAwesome5.line, const Color(0xFF4C7488)),
                ],
              ),
              const SizedBox(height: 15),

              // 註冊新帳號
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistrationPage()),
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
        ),
      ),
    );
  }

  /// 共用輸入框樣式
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

  /// 社群登入按鈕
  Widget _buildSocialButton(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {}, // 這裡可以串接社群登入
        borderRadius: BorderRadius.circular(25),
        child: Ink(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 30, color: color),
        ),
      ),
    );
  }
}
