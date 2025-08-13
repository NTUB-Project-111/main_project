import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/headers/header4.dart';
import 'package:drw/frontend/pages/personalpages/changehabit_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tabs/tabs.dart';
import 'changename_page.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FEFF),
      body: Column(
        children: [
          const Header4(title: "個人基本資料", nextPage: Tabs(currentIndex: 4)),
          Column(
            children: [
              // 使用者頭像（靜態）
              Consumer<UserProvider>(builder: (context, userProvider, _) {
                final user = userProvider.user;
                return Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 22),
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    // color: Colors.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withOpacity(0.35),
                    //     blurRadius: 1,
                    //   ),
                    // ],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                      child: user!.picture.isNotEmpty
                          ? Image.network(
                              Uri.parse(ApiBase.baseUrl).resolve(user.picture).toString(),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Text("圖片載入失敗"));
                              },
                            )
                          : Image.asset(
                              "images/register_icon.png",
                              fit: BoxFit.contain,
                            )),
                );
              }),

              // // 更換頭像按鈕（無動作）
              // ElevatedButton(
              //   onPressed: () async {
              //     // final userProvider = context.read<UserProvider>();
              //     // final user = userProvider.user;
              //     // final message = await UserService.updateImage(userId: user!.id, imageFile: imageFile);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     elevation: 0,
              //     backgroundColor: const Color.fromRGBO(102, 159, 165, 1),
              //   ),
              //   child: const Text(
              //     "更換頭像",
              //     style: TextStyle(
              //       fontSize: 15,
              //       color: Colors.white,
              //       letterSpacing: 1.5,
              //     ),
              //   ),
              // ),

              // 使用者資訊表（靜態假資料）
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Color.fromRGBO(242, 254, 255, 1)))),
                      padding: const EdgeInsets.fromLTRB(28, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('我的暱稱',
                              style: TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
                          Row(
                            children: [
                              Consumer<UserProvider>(builder: (context, userProvider, _) {
                                final user = userProvider.user;
                                return Text(
                                  user!.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 140, 140, 140),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
                                );
                              }),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ChangeNamePage(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Color(0xFF669FA5),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('生日',
                              style: TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
                          Consumer<UserProvider>(builder: (context, userProvider, _) {
                            final user = userProvider.user;
                            return Text(
                              user!.birthday,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 140, 140, 140),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Color.fromRGBO(242, 254, 255, 1)))),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('電子信箱',
                              style: TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
                          Consumer<UserProvider>(builder: (context, userProvider, _) {
                            final user = userProvider.user;
                            return Text(
                              user!.email,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 140, 140, 140),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Color.fromRGBO(242, 254, 255, 1)))),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('個人習慣',
                              style: TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
                          IconButton(
                            padding: const EdgeInsets.only(left: 35),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChangeHabitPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Color(0xFF669FA5),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Color.fromRGBO(242, 254, 255, 1)))),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('特殊疾病',
                              style: TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
                          IconButton(
                            padding: const EdgeInsets.only(left: 35),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChangeHabitPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Color(0xFF669FA5),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
