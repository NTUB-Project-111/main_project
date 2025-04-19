import 'package:flutter/material.dart';
import '../headers/header_2.dart';
import 'changename.dart';
import '../../my_flutter_app_icons.dart';
import 'dart:io';
import './takepicture.dart';
import '../tabs.dart';
import '../../feature/database.dart';
import 'package:image_picker/image_picker.dart';

class PersonalContainPage extends StatefulWidget {
  const PersonalContainPage({super.key});

  @override
  State<PersonalContainPage> createState() => _PersonalContainPageState();
}

class _PersonalContainPageState extends State<PersonalContainPage> {
  // String? userId = '';
  Map<String, dynamic>? userInfo = DatabaseHelper.userInfo;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickPicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
      _showConfirmationDialog(); // 顯示確認對話框
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF589399),
            width: 2,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          '確認照片',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF589399),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                _image!,
                width: 200,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                backgroundColor: const Color(0xFF589399),
                side: BorderSide.none,
              ),
              onPressed: () async {
                if (_image != null) {
                  try {
                    await DatabaseHelper.updateImage(userInfo!['id'].toString(), _image!);
                    DatabaseHelper.userInfo = (await DatabaseHelper.getUserInfo())!;
                    print("成功更新圖片到資料庫");
                  } catch (e) {
                    print("更新圖片失敗: $e");
                  }
                }
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const PersonalContainPage()));
              },
              child: const Text(
                '確認',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                side: const BorderSide(
                  width: 2,
                  color: Color(0xFF589399),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // 關閉對話框
              },
              child: const Text(
                '取消',
                style: TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showButtonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color(0xFF589399),
            width: 2,
          ),
        ),
        backgroundColor: const Color(0xFFF5FEFF),
        contentPadding: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TakePicturePage(
                            userId: userInfo!['id'].toString(),
                          )),
                );
              },

              splashColor: const Color(0xFFDFF6F7), // 點擊時的顏色
              highlightColor: const Color(0xFFDFF6F7), // 長按時的顏色
              borderRadius: BorderRadius.circular(15), // 可選，讓漣漪圓角更自然
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFF669FA5)))),
                width: double.infinity,
                child: const Row(
                  children: [
                    Icon(MyFlutterApp.camera, color: Color(0xFF589399)),
                    SizedBox(width: 15),
                    Text("相機拍攝", style: TextStyle(color: Color(0xFF589399), fontSize: 14)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _pickPicture();
              },
              splashColor: const Color(0xFFDFF6F7), // 點擊時的顏色
              highlightColor: const Color(0xFFDFF6F7), // 長按時的顏色
              borderRadius: BorderRadius.circular(15), // 可選，讓漣漪圓角更自然
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: double.infinity,
                child: const Row(
                  children: [
                    Icon(MyFlutterApp.picture, color: Color(0xFF589399)),
                    SizedBox(width: 15),
                    Text("相簿選擇", style: TextStyle(color: Color(0xFF589399), fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPicture = userInfo != null &&
        userInfo!['picture'] != null &&
        userInfo!['picture'].toString().isNotEmpty &&
        userInfo!['picture'] != 'null';
    return Scaffold(
        backgroundColor: const Color(0xFFF2FEFF),
        body: Column(
          children: [
            const HeaderPage2(title: "個人基本資料", nextPage: Tabs(currentIndex: 4)),
            Column(
              children: [
                //使用者頭像
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 22),
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 1,
                      ),
                    ],
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
                //換頭像按鈕
                ElevatedButton(
                  onPressed: () {
                    _showButtonDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color.fromRGBO(102, 159, 165, 1),
                  ),
                  child: const Text("更換頭像",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      )),
                ),

                //使用者資訊表
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
                            border: Border(
                                bottom: BorderSide(color: Color.fromRGBO(242, 254, 255, 1)))),
                        padding: const EdgeInsets.fromLTRB(28, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('我的暱稱',
                                style: TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
                            Row(
                              children: [
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 120), // 設定最大寬度以防止溢出
                                  child: Text(
                                    userInfo?['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 140, 140, 140),
                                    ),
                                    overflow: TextOverflow.ellipsis, // 超出顯示「...」
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const ChangeNamePage()));
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
                            Text(userInfo?['birthday'],
                                style: const TextStyle(
                                    fontSize: 13, color: Color.fromARGB(255, 140, 140, 140))),
                          ],
                        ),
                      ),
                      Container(
                        height: 60,
                        decoration: const BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Color.fromRGBO(242, 254, 255, 1)))),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('電子信箱',
                                style: TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
                            Row(
                              children: [
                                Text(userInfo?['email'],
                                    style: const TextStyle(
                                        fontSize: 13, color: Color.fromARGB(255, 140, 140, 140))),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
