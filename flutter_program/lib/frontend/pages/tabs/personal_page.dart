import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/widgets/headers/header3.dart';
import 'package:drw/frontend/pages/develop_page.dart';
import 'package:drw/frontend/pages/login_page.dart';
import 'package:drw/frontend/pages/personalpages/changepwd_page.dart';
import 'package:drw/frontend/pages/personalpages/profiles_page.dart';
import 'package:drw/frontend/pages/remind_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 248, 248),
      body: Column(
        children: [
          const Header3(
              title: "我的",
              icon:
                  Icon(Icons.notifications, size: 23, color: Color(0xFF589399)),
              targetPage: RemindPage()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 46, vertical: 23),
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
                    child: Consumer<UserProvider>(
                        builder: (context, userProvider, _) {
                      final user = userProvider.user;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              shape: BoxShape.circle,
                              // border: Border.all(
                              //   color: const Color(0xFF669FA5),
                              //   width: 2,
                              // )
                            ),
                            child: ClipOval(
                                child: user!.picture.isNotEmpty
                                    ? Image.network(
                                        Uri.parse(ApiBase.baseUrl)
                                            .resolve(user.picture)
                                            .toString(),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                              child: Text("圖片載入失敗"));
                                        },
                                      )
                                    : Image.asset(
                                        "images/register_icon.png",
                                        fit: BoxFit.contain,
                                      )),
                          ),
                          Expanded(
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                color: Color(0xFF669FA5),
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.8,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    })),
                Image.asset('images/line.png'),
                const SizedBox(height: 8),
                _buildDetailItem(
                  const Icon(Icons.person, color: Color(0xFF669FA5), size: 30),
                  "個人基本資料",
                  targetPage: const ProfilesPage(),
                ),
                _buildDetailItem(
                  const Icon(Icons.lock, color: Color(0xFF669FA5), size: 30),
                  "變更密碼",
                  targetPage: const ChangePwdPage(),
                ),
                _buildDetailItem(
                  const Icon(Icons.settings,
                      color: Color(0xFF669FA5), size: 30),
                  "更多設定",
                  targetPage: const DevelopPage(),
                ),
                _buildDetailItem(
                  const Icon(Icons.logout, color: Color(0xFF669FA5), size: 30),
                  "登出",
                  targetPage: null,
                  onPressed: () {
                    FrontUtil.showTextDialog(
                      context,
                      '確定要登出嗎？',
                      '確認',
                      '取消',
                      onConfirm: () {
                        // 你要執行的動作，例如：
                        context.read<UserProvider>().clearUser();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailItem(Icon icon, String title,
      {Widget? targetPage, VoidCallback? onPressed}) {
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
}
