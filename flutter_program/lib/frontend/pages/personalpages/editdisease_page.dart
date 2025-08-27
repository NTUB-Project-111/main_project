import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/services/user_service.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDiseasePage extends StatefulWidget {
  const EditDiseasePage({super.key});

  @override
  State<EditDiseasePage> createState() => _EditDiseasePageState();
}

class _EditDiseasePageState extends State<EditDiseasePage> {
  List<String> mainConditions = [];
  List<String> compareList = [];
  bool showButton = false;
  UserService userService = UserService();
  final List<String> otherConditions = [
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

    // 複製並排序，避免改到原本的 list
    List<String> sorted1 = List.from(list1)..sort();
    List<String> sorted2 = List.from(list2)..sort();

    if (sorted1.length == sorted2.length) {
      for (int i = 0; i < sorted1.length; i++) {
        if (sorted1[i] != sorted2[i]) {
          return true; // 有不同的元素
        }
      }
    }
    return false; // 內容完全一樣
  }

  void toggleCondition(String condition) {
    setState(() {
      if (selectedConditions.contains(condition)) {
        selectedConditions.remove(condition);
      } else {
        selectedConditions.add(condition);
      }
    });
  }

  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      final user = userProvider.user;
      final disease = user!.disease.replaceAll("[", "").replaceAll("]", "");
      mainConditions = disease.split(',').map((e) => e.trim()).toList();
      compareList = List.from(mainConditions);
      for (int i = 0; i < mainConditions.length; i++) {
        otherConditions.remove(mainConditions[i]);
      }
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
                FrontUtil.textColor, // ✅ 你想要的主題色
                '放棄修改嗎?',
                null, // ✅ subTitle 如果沒有就傳 null
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(38, 20, 38, 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 35,
              mainAxisSpacing: 35,
              physics: const NeverScrollableScrollPhysics(),
              children: mainConditions.map((disease) {
                return _buildSeletedDisease(disease);
              }).toList(),
            ),
            // const SizedBox(height: 20),
            const Text(
              "其他",
              style: TextStyle(
                  color: Color(0xFF669FA5),
                  fontWeight: FontWeight.bold,
                  height: 5),
            ),
            // const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 35,
                mainAxisSpacing: 35,
                children: otherConditions.map((condition) {
                  final isSelected = selectedConditions.contains(condition);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        mainConditions.add(condition);
                        otherConditions.remove(condition);
                        showButton = compare(mainConditions, compareList);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFFB2E2E4) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40589399),
                            blurRadius: 5,
                            // offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        condition,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xFF669FA5),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // const Spacer(),
            showButton
                ? Row(
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
                                  final success =
                                      await userService.updateDisease(
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
                          icon: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF2E6D74),
                            size: 35,
                          ))
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildSeletedDisease(String disease) {
    return GestureDetector(
      onTap: () {
        setState(() {
          mainConditions.remove(disease);
          otherConditions.add(disease);
          showButton = compare(mainConditions, compareList);
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(188, 128, 179, 185),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40589399),
              blurRadius: 15,
            ),
          ],
        ),
        child: Text(
          disease,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
