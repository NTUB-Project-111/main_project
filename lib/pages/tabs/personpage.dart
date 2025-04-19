import 'package:flutter/material.dart';
import 'package:wounddetection/my_flutter_app_icons.dart';
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
  @override
  void initState() {
    super.initState();
  }

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
                    Text(
                      userInfo?['name'],
                      style: const TextStyle(
                        color: Color(0xFF669FA5),
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.8,
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
                  const PersonalContainPage()),
              _buildDetailItem(
                  const Icon(
                    Icons.lock,
                    color: Color(0xFF669FA5),
                    size: 30,
                  ),
                  "變更密碼",
                  ChangePsPage(
                    userPassword: userInfo?['password'],
                  )),
              _buildDetailItem(
                  const Icon(
                    Icons.settings,
                    color: Color(0xFF669FA5),
                    size: 30,
                  ),
                  "更多設定",
                  const Settings()),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDetailItem(Icon icon, String title, Widget targetPage) {
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
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
        },
        label: Text(title,
            style: const TextStyle(
              color: Color(0xFF669FA5),
              fontSize: 14,
            )),
        icon: icon,
        style: OutlinedButton.styleFrom(
            alignment: Alignment.centerLeft,
            side: BorderSide.none, // 移除框線
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
      ),
    );
  }
}
