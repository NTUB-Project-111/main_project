import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/services/user_service.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeHabitPage extends StatefulWidget {
  const ChangeHabitPage({super.key});

  @override
  State<ChangeHabitPage> createState() => _ChangeHabitPageState();
}

class _ChangeHabitPageState extends State<ChangeHabitPage> {
  final Color backgroundColor = const Color(0xFFE5F7F9);
  final Color selectedColor = const Color(0xFFD0EAE9);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF5A8A90);

  // 記錄目前選擇狀態
  int selectedHabitIndex = 0; // 0: 抽菸, 1: 喝酒, 2: 嚼檳榔
  List<int> selectedFrequencyIndex = [0, 0, 0]; // 0: 無, 1: 偶爾, 2: 經常
  List<int> compareIndex = [0, 0, 0];
  String habit = '抽菸';
  bool showButton = false;
  List<String> freq = ['無', '無', '無'];
  UserService userService = UserService();

  Widget buildOption(String title, String subtitle, int index) {
    bool selected = selectedHabitIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedHabitIndex = index;
          if (selectedHabitIndex == 0) {
            habit = '抽菸';
          } else if (selectedHabitIndex == 1) {
            habit = '喝酒';
          } else {
            habit = '嚼檳榔';
          }
        });
      },
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: selected ? selectedColor : cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E6D74),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 18, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget buildFrequencyOption(String text, int index, int selectIndex) {
    bool selected = selectedFrequencyIndex[selectIndex] == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFrequencyIndex[selectIndex] = index;
          showButton = compare(selectedFrequencyIndex, compareIndex);
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: selected ? selectedColor : cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ),
      ),
    );
  }

  bool compare(List<int> list1, List<int> list2) {
    for (int index = 0; index < 3; index++) {
      if (list1[index] != list2[index]) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      final user = userProvider.user;
      List<String> freq = user!.freq.split('、');
      // debugPrint(freq.toString());
      for (int index = 0; index < freq.length; index++) {
        if (freq[index].contains('無')) {
          selectedFrequencyIndex[index] = 0;
          compareIndex[index] = 0;
        } else if (freq[index].contains('偶爾')) {
          selectedFrequencyIndex[index] = 1;
          compareIndex[index] = 1;
        } else {
          selectedFrequencyIndex[index] = 2;
          compareIndex[index] = 2;
        }
      }
      setState(() {}); // 更新 UI
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar 模擬
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      if (showButton) {
                        FrontUtil.showConfirmDialog(
                          context,
                          FrontUtil.textColor,
                          '要儲存修改嗎?',
                          null,
                          '取消',
                          '確定',
                          () async {
                            for (int i = 0; i < 3; i++) {
                              if (selectedFrequencyIndex[i] == 0) {
                                freq[i] = '無';
                              } else if (selectedFrequencyIndex[i] == 1) {
                                freq[i] = '偶爾';
                              } else {
                                freq[i] = '經常';
                              }
                            }

                            final freqString = freq.join('、');
                            final success = await userService.updateFreq(
                              id: user!.id,
                              freq: freqString,
                            );

                            if (success) {
                              final updatedUser =
                                  user.copyWith(freq: freqString);
                              context
                                  .read<UserProvider>()
                                  .setUserInfo(updatedUser);
                              FrontUtil.showSuccess('修改成功');
                              Navigator.pop(context);
                            } else {
                              FrontUtil.showFail('修改失敗');
                            }
                          },
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(Icons.arrow_back, color: textColor),
                  ),
                  const SizedBox(width: 8),
                  Text("個人習慣",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 2)),
                  const Spacer(),
                  Icon(Icons.info_outline, color: textColor),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 三個習慣選項
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildOption("抽菸", "無", 0),
                const SizedBox(width: 12),
                buildOption("喝酒", "偶爾", 1),
                const SizedBox(width: 12),
                buildOption("嚼檳榔", "經常", 2),
              ],
            ),

            const SizedBox(height: 50),

            // 標題
            Text("變更『$habit』頻率",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor)),

            const SizedBox(height: 25),

            // 頻率選項
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildFrequencyOption("無", 0, selectedHabitIndex),
                const SizedBox(width: 12),
                buildFrequencyOption("偶爾", 1, selectedHabitIndex),
                const SizedBox(width: 12),
                buildFrequencyOption("經常", 2, selectedHabitIndex),
              ],
            ),

            const SizedBox(height: 20),

            // 備註
            Text("＊偶爾：每天 1~10 支",
                style: TextStyle(fontSize: 14, color: textColor)),

            const SizedBox(height: 50),
            showButton
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            FrontUtil.showConfirmDialog(
                              context,
                              FrontUtil.textColor,
                              '取消修改?',
                              null,
                              '取消',
                              '確定',
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Color(0xFF83B6BB),
                            size: 40,
                          )),
                      const SizedBox(width: 30),
                      IconButton(
                          onPressed: () async {
                            FrontUtil.showConfirmDialog(
                                context,
                                FrontUtil.textColor,
                                '要儲存修改嗎?',
                                null,
                                '取消',
                                '確定', () async {
                              for (int i = 0; i < 3; i++) {
                                if (selectedFrequencyIndex[i] == 0) {
                                  freq[i] = '無';
                                } else if (selectedFrequencyIndex[i] == 1) {
                                  freq[i] = '偶爾';
                                } else {
                                  freq[i] = '經常';
                                }
                              }
                              final freqString = freq.join('、');
                              final success = await userService.updateFreq(
                                  id: user!.id, freq: freqString);
                              if (success) {
                                final updatedUser =
                                    user.copyWith(freq: freqString);
                                context
                                    .read<UserProvider>()
                                    .setUserInfo(updatedUser);
                                FrontUtil.showSuccess('修改成功');
                                Navigator.pop(context);
                              } else {
                                FrontUtil.showFail('修改失敗');
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF2E6D74),
                            size: 40,
                          ))
                    ],
                  )
                : const SizedBox(),
            const Spacer(),
            // 小熊護士圖片
            Image.asset(
              "images/nursebear.png",
              height: 160,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
