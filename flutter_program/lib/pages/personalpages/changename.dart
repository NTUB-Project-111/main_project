import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../feature/database.dart';
import '../headers/header_2.dart';
import 'package:wounddetection/pages/personalpages/personalcontain.dart';

class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({super.key});
  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _updateUserName() async {
    setState(() {
      _isLoading = true;
    });

    String? userId = await DatabaseHelper.getUserId();
    String newName = _nameController.text.trim();

    if (userId == null) {
      Fluttertoast.showToast(msg: "無法獲取使用者 ID，請重新登入");
      setState(() => _isLoading = false);
      return;
    }

    if (newName.isEmpty) {
      Fluttertoast.showToast(msg: "名稱不能為空");
      setState(() => _isLoading = false);
      return;
    }

    if (newName.length > 100) {
      Fluttertoast.showToast(msg: "暱稱長度請勿超過 100 字");
      setState(() => _isLoading = false);
      return;
    }

    bool success = await DatabaseHelper.updateName(userId, newName);

    if (!mounted) return; // 防止異步錯誤

    setState(() => _isLoading = false);

    if (success) {
      DatabaseHelper.userInfo['name'] = newName;
      Fluttertoast.showToast(msg: "名稱修改成功");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PersonalContainPage()),
      );
    } else {
      Fluttertoast.showToast(msg: "名稱修改失敗，請稍後再試");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FEFF),
      body: Column(
        children: [
          const HeaderPage2(title: "我的暱稱"),
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
                    color: Colors.white, // 背景色
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: TextField(
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateUserName,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF669FA5),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "確定",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.8,
                                color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
