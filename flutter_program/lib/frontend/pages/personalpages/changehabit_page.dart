import 'package:collection/collection.dart';
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
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF5A8A90);

  final List<String> habitList = ['抽菸', '喝酒', '嚼檳榔'];
  final List<String> freqOptions = ['無', '偶爾', '經常'];

  int selectedHabitIndex = 0; // 目前選到哪個習慣
  List<int> selectedFrequencyIndex = [0, 0, 0]; // 每個習慣的頻率
  List<int> originalFrequencyIndex = [0, 0, 0]; // 初始值（用來判斷是否修改）

  UserService userService = UserService();

  String getRemarkText() {
    switch (selectedHabitIndex) {
      case 0: // 抽菸
        return "※ 偶爾：每周 1~6 根";
      case 1: // 喝酒
        return "※ 偶爾：每月 1~3 次";
      case 2: // 嚼檳榔
        return "※ 偶爾：每月 1~5 次";
      default:
        return "";
    }
  }

  /// 判斷是否有修改
  bool get hasChanged => !const ListEquality()
      .equals(selectedFrequencyIndex, originalFrequencyIndex);

  /// 儲存更新
  Future<void> _saveFreq(UserProvider userProvider) async {
    final user = userProvider.user!;
    final freq =
        selectedFrequencyIndex.map((i) => freqOptions[i]).toList().join('、');

    final success = await userService.updateFreq(id: user.id, freq: freq);

    if (success) {
      final updatedUser = user.copyWith(freq: freq);
      userProvider.setUserInfo(updatedUser);
      FrontUtil.showSuccess('修改成功');
      Navigator.pop(context);
    } else {
      FrontUtil.showFail('修改失敗');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserProvider>().user;
      if (user != null) {
        final freq = user.freq.split('、');
        for (int i = 0; i < freq.length; i++) {
          if (freq[i].contains('無')) {
            selectedFrequencyIndex[i] = 0;
          } else if (freq[i].contains('偶爾')) {
            selectedFrequencyIndex[i] = 1;
          } else {
            selectedFrequencyIndex[i] = 2;
          }
        }
        originalFrequencyIndex = List.from(selectedFrequencyIndex);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      if (hasChanged) {
                        FrontUtil.showConfirmDialog(
                          context,
                          FrontUtil.textColor,
                          '要儲存修改嗎?',
                          null,
                          '取消',
                          '確定',
                          () => _saveFreq(userProvider),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(Icons.arrow_back, color: textColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "個人習慣",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        height: 2),
                  ),
                  const Spacer(),
                  Icon(Icons.info_outline, color: textColor),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 上半部：三個習慣選項
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                      physics: const NeverScrollableScrollPhysics(),
                      children: habitList.asMap().entries.map((entry) {
                        final i = entry.key;
                        final habit = entry.value;
                        final isSelected = selectedHabitIndex == i;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedHabitIndex = i;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(188, 128, 179, 185)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x40589399),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  habit,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF669FA5),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  freqOptions[selectedFrequencyIndex[i]],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF669FA5),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 50),

                    // 標題
                    Center(
                      child: Text(
                        "變更『${habitList[selectedHabitIndex]}』頻率",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 下半部：頻率選項
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                      physics: const NeverScrollableScrollPhysics(),
                      children: freqOptions.asMap().entries.map((entry) {
                        final i = entry.key;
                        final option = entry.value;
                        final isSelected =
                            selectedFrequencyIndex[selectedHabitIndex] ==
                                i; // ✅ 判斷選中
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFrequencyIndex[selectedHabitIndex] = i;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(188, 128, 179, 185)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x40589399),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF669FA5), // ✅ 這裡改對
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: Text(
                        getRemarkText(),
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 確認 / 取消按鈕
            if (hasChanged)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      FrontUtil.showConfirmDialog(
                        context,
                        FrontUtil.textColor,
                        '取消修改嗎?',
                        null,
                        '取消',
                        '確定',
                        () => Navigator.pop(context),
                      );
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Color(0xFF83B6BB),
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    onPressed: () => _saveFreq(userProvider),
                    icon: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF2E6D74),
                      size: 40,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 60),
            Center(child: Image.asset("images/nursebear.png", height: 160)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
