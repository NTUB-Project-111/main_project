import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/frontend/widgets/wound_option_button.dart';
import 'package:drw/frontend/pages/guestblock_page.dart';
import 'package:drw/frontend/pages/selectimage_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'camera_page.dart';
import 'gallery_page.dart';
import 'hospital_page.dart';
import 'personal_page.dart';

class Tabs extends StatefulWidget {
  final int? currentIndex;
  const Tabs({super.key, this.currentIndex});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  late int _currentIndex; // 用 late 確保_currentIndex正確初始化
  final List<Widget> _pages = [
    const HomePage(),
    const HospitalPage(),
    const CameraPage(
      isExtra: false,
    ),
    const GalleryPage(),
    const PersonalPage(),
  ];

  @override
  void initState() {
    super.initState();
    // 如果 `currentIndex` 傳入的是 null，則使用 0
    _currentIndex = widget.currentIndex ?? 0;
    // loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      resizeToAvoidBottomInset: false, //讓floatingactionbottun不受鍵盤影響位置
      backgroundColor: const Color(0xFFEBFEFF),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF669FA5), width: 2), // 只設定上邊框
          ),
        ),
        child: BottomNavigationBar(
          onTap: (index) {
            final isGuest = Provider.of<UserProvider>(context, listen: false).isGuest;
            final restrictedIndexes = [1, 2, 3, 4];

            if (isGuest && restrictedIndexes.contains(index)) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GuestBlockPage()),
              );
              return;
            }

            setState(() {
              _currentIndex = index != 2 ? index : _currentIndex; //setState會重新跑build
            });
          },
          selectedFontSize: 13,
          unselectedFontSize: 11,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "首頁",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.local_hospital_rounded,
              ),
              label: "附近醫院",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: "傷口拍攝",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.my_library_books,
              ),
              label: "紀錄冊",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "我的",
            ),
          ],
          selectedItemColor: const Color(0xFF669FA5),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF669FA5),
          shape: const CircleBorder(
            side: BorderSide(color: Colors.white, width: 2.0),
          ),
          child: const Icon(Icons.camera_alt, size: 35),
          onPressed: () {
            showDialog(
              context: context,
              barrierColor: const Color.fromARGB(255, 154, 182, 187).withOpacity(0.4),
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  insetPadding: const EdgeInsets.symmetric(vertical: 250, horizontal: 40),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 新增的標題文字
                          Text(
                            "請選擇紀錄方式",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: FrontUtil.textColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: WoundOptionButton(
                                  label: "舊傷口追蹤",
                                  imagePath: 'images/old_photo_icon.png',
                                  backgroundColor: const Color.fromARGB(255, 242, 225, 217),
                                  borderColor: Colors.transparent,
                                  textColor: const Color.fromARGB(255, 155, 109, 87),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    user!.id != -1
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const SelectImagePage(),
                                            ),
                                          )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => const GuestBlockPage()),
                                          );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: WoundOptionButton(
                                  label: "新傷口拍攝",
                                  imagePath: 'images/new_photo_icon.png',
                                  backgroundColor: const Color.fromARGB(255, 92, 141, 147),
                                  borderColor: Colors.transparent,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CameraPage(isExtra: false),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
