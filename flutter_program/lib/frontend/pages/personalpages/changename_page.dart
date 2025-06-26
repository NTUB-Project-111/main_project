import 'package:drw/backend/models/profiles_model.dart';
import 'package:drw/backend/models/user_model.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:drw/frontend/headers/header4.dart';
import 'package:provider/provider.dart';

import 'profiles_page.dart';

class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({super.key});
  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Profiles(),
        child: Builder(builder: (context) {
          final profiles = Provider.of<Profiles>(context);
          return Scaffold(
            backgroundColor: const Color(0xFFF2FEFF),
            body: Column(
              children: [
                const Header4(title: "我的暱稱", nextPage: ProfilesPage()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "修改暱稱",
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF669FA5),
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
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
                          child: TextField(
                            onChanged: (value) => profiles.setName(value),
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: "輸入新暱稱",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            ),
                          )),
                      const SizedBox(height: 20),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!profiles.isFilled()) {
                                FrontUtil.showError('請填寫新暱稱', Colors.red, Colors.white);
                                return;
                              }
                              final user = Provider.of<User>(context, listen: false);
                              final success = await profiles.updateUserName(user.id, profiles.name);
                              if (success) {
                                user.name = profiles.name;
                                FrontUtil.showError('名稱更新成功', Colors.green, Colors.white);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfilesPage(),
                                  ),
                                );
                              } else {
                                FrontUtil.showError('名稱更新失敗', Colors.red, Colors.white);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF669FA5),
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
