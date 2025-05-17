import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wounddetection/my_flutter_app_icons.dart';
import 'package:wounddetection/pages/loginpages/login.dart';
import 'package:wounddetection/pages/personalpages/personalcontain.dart';
import '../headers/header_1.dart';
import '../personalpages/changeps.dart';
import '../remindpage.dart';
import '../personalpages/setting.dart';
import '../../feature/database.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  String? userId = '';
  Map<String, dynamic>? userInfo = DatabaseHelper.userInfo;
  @override //更新資訊，卻保有抓到資料。
  void initState() {
    super.initState();
    // _loadUserInfo();
  }

  // Future<void> _loadUserInfo() async {
  //   final info = await DatabaseHelper.getUserInfo();
  //   setState(() {
  //     userInfo = info;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final hasPicture = userInfo != null &&
        userInfo!['picture'] != null &&
        userInfo!['picture'].toString().isNotEmpty &&
        userInfo!['picture'] != 'null';

    return Column(
      children: [
        const HeaderPage1(
            title: "我的",
            icon: Icon(MyFlutterApp.bell, size: 23, color: Color(0xFF589399)),
            targetPage: RemindPage()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 23),
                margin: const EdgeInsets.fromLTRB(0, 40, 0, 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF669FA5).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: hasPicture
                            ? Image.network(
                                Uri.parse(DatabaseHelper.baseUrl)
                                    .resolve(userInfo!['picture'])
                                    .toString(),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(child: Text("圖片載入失敗"));
                                },
                              )
                            : const Icon(
                                Icons.person,
                                color: Color(0xFF669FA5),
                                size: 80,
                              ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        userInfo?['name'] ?? '',
                        style: const TextStyle(
                          color: Color(0xFF669FA5),
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.8,
                        ),
                        overflow: TextOverflow.ellipsis, // 過長時顯示省略號
                        maxLines: 1, // 限制為單行
                        softWrap: false, // 不換行
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset('images/line.png'),
              const SizedBox(
                height: 8,
              ),
              _buildDetailItem(
                  const Icon(
                    Icons.person,
                    color: Color(0xFF669FA5),
                    size: 30,
                  ),
                  "個人基本資料",
                  targetPage: const PersonalContainPage()),
              _buildDetailItem(
                  const Icon(
                    Icons.lock,
                    color: Color(0xFF669FA5),
                    size: 30,
                  ),
                  "變更密碼",
                  targetPage: ChangePsPage(
                    userPassword: userInfo?['password'],
                  )),
              _buildDetailItem(
                  const Icon(
                    Icons.settings,
                    color: Color(0xFF669FA5),
                    size: 30,
                  ),
                  "更多設定",
                  targetPage: const Settings()),
              _buildDetailItem(
                const Icon(Icons.logout, color: Color(0xFF669FA5), size: 30),
                "登出",
                targetPage: null,
                onPressed: _logout,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDetailItem(Icon icon, String title, {Widget? targetPage, VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 1,
          ),
        ],
      ),
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed ??
            () {
              if (targetPage != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => targetPage),
                );
              }
            },
        label: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF669FA5),
            fontSize: 14,
          ),
        ),
        icon: icon,
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  void _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 248, 254, 255), // 背景顏色
          title: const Text(
            '確定要登出嗎？',
            style: TextStyle(
              color: Color(0xFF669FA5), // 標題文字顏色
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '登出後需重新登入才能繼續使用應用程式。',
            style: TextStyle(
              color: Color(0xFF669FA5), // 內文文字顏色
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                '取消',
                style: TextStyle(color: Color.fromARGB(255, 94, 105, 103)),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text(
                '登出',
                style: TextStyle(color: Color.fromARGB(255, 13, 128, 108)), // 紅色登出按鈕
              ),
              onPressed: () async {
                Navigator.of(context).pop(true);
                await DatabaseHelper.clearUserId();
              },
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwtToken');
      await prefs.remove('userId');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}
