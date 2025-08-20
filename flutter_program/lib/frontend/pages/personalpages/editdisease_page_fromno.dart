import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/services/user_service.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDiseasePageFromno extends StatefulWidget {
  const EditDiseasePageFromno({super.key});

  @override
  State<EditDiseasePageFromno> createState() => _EditDiseasePageFromnoState();
}

class _EditDiseasePageFromnoState extends State<EditDiseasePageFromno> {
  List<String> mainConditions = [];
  List<String> compareList = [];
  bool showButton = false;
  UserService userService = UserService();

  final List<String> allConditions = [
    "貧血",
    "高血壓",
    "糖尿病",
    "壞血病",
    "白血病",
    "敗血病",
    "血友病",
    "肝病",
    "腎病",
    "癌症",
    "靜脈功能不全",
    "周邊動脈阻塞"
  ];

  final Set<String> selectedConditions = {};

  bool compare(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return true;
    List<String> sorted1 = List.from(list1)..sort();
    List<String> sorted2 = List.from(list2)..sort();
    for (int i = 0; i < sorted1.length; i++) {
      if (sorted1[i] != sorted2[i]) return true;
    }
    return false;
  }

  void toggleCondition(String condition) {
    setState(() {
      if (selectedConditions.contains(condition)) {
        selectedConditions.remove(condition);
      } else {
        selectedConditions.add(condition);
      }
      mainConditions = selectedConditions.toList();
      showButton = compare(mainConditions, compareList);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      final user = userProvider.user;
      final disease =
          user?.disease.replaceAll("[", "").replaceAll("]", "") ?? "";
      mainConditions = disease.isEmpty
          ? []
          : disease
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      compareList = List.from(mainConditions);
      selectedConditions.addAll(mainConditions);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFFE6FAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5C9EA0)),
          onPressed: () async {
            if (showButton) {
              FrontUtil.showConfirmDialog(
                context,
                FrontUtil.textColor,
                '放棄修改嗎?',
                null,
                '取消',
                '確定',
                () async {
                  Navigator.pop(context);
                },
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          "特殊病症",
          style: TextStyle(
              color: Color(0xFF5C9EA0),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF5C9EA0)),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(38, 20, 38, 20),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 35,
                mainAxisSpacing: 35,
                children: allConditions.map((condition) {
                  final isSelected = selectedConditions.contains(condition);
                  return GestureDetector(
                    onTap: () => toggleCondition(condition),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(188, 128, 179, 185) // 選中的顏色
                            : Colors.white, // 未選中顏色
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40589399),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        condition,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color(0xFF669FA5),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ✅ 出現取消 & 確定按鈕
          if (showButton)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    if (showButton) {
                      FrontUtil.showConfirmDialog(
                        context,
                        FrontUtil.textColor, // ✅ 你想要的主題色
                        '要儲存修改嗎?',
                        null, // ✅ subTitle 如果沒有就傳 null
                        '取消',
                        '確定',
                        () async {
                          final success = await userService.updateDisease(
                            id: user!.id,
                            disease: mainConditions.toString(),
                          );
                          if (success) {
                            final updatedUser = user.copyWith(
                              disease: mainConditions.toString(),
                            );
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
                  icon: const Icon(Icons.check_circle,
                      color: Color(0xFF2E6D74), size: 35),
                ),
              ],
            ),

          // 小熊護士圖片
          const SizedBox(height: 20),
          Image.asset("images/nursebear.png", height: 160),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
