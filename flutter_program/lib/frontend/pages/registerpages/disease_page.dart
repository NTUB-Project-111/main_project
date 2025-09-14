import 'package:drw/backend/viewmodels/register_view_model.dart';
// import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/login_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/widgets/bear_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiseasePage extends StatefulWidget {
  const DiseasePage({super.key});

  @override
  State<DiseasePage> createState() => _DiseasePageState();
}

class _DiseasePageState extends State<DiseasePage> {
  final List<String> symptoms = [
    "高血壓",
    "高血脂",
    "糖尿病",
    "愛滋病",
    "壞血病",
    "白血病",
    "敗血病",
    "血友病",
    "貧血",
    "肝病",
    "腎病",
    "癌症",
    "靜脈功能不全",
    "周邊動脈阻塞"
  ];
  List<String> selectedSymptoms = [];

  // void _showMultiSelect() {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) {
  //       // final register = context.read<Register>();
  //       return StatefulBuilder(builder: (context, setModalState) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const SizedBox(height: 12),
  //             const Text(
  //               '選擇症狀',
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF5E9CA0)),
  //             ),
  //             const Divider(
  //               color: Color(0xFF5E9CA0),
  //             ),
  //             ...symptoms.map((symptom) {
  //               return CheckboxListTile(
  //                 title: Text(
  //                   symptom,
  //                   style: const TextStyle(color: Color(0xFF5E9CA0)),
  //                 ),
  //                 activeColor: const Color(0xFF5E9CA0),
  //                 value: selectedSymptoms.contains(symptom),
  //                 onChanged: (bool? value) {
  //                   setModalState(() {
  //                     if (value == true) {
  //                       selectedSymptoms.add(symptom);
  //                     } else {
  //                       selectedSymptoms.remove(symptom);
  //                     }
  //                   });

  //                   setState(() {}); // 更新主畫面顯示
  //                 },
  //               );
  //             }),
  //             const SizedBox(height: 10),
  //           ],
  //         );
  //       });
  //     },
  //   );
  // }

  void _showMultiSelect() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 24), // ⬅️ 外框 padding
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  '選擇症狀',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E9CA0),
                  ),
                ),
                const SizedBox(height: 16), // ⬅️ 標題和 chips 間距
                Wrap(
                  spacing: 8, // ⬅️ chips 左右間距
                  runSpacing: 8, // ⬅️ chips 上下間距
                  children: symptoms.map((symptom) {
                    final isSelected = selectedSymptoms.contains(symptom);
                    return FilterChip(
                      label: Text(symptom),
                      selected: isSelected,
                      selectedColor: const Color(0xFFE5F8F8),
                      checkmarkColor: const Color(0xFF5E9CA0),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFF5E9CA0)
                            : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF5E9CA0)
                              : Colors.grey[400]!,
                        ),
                      ),
                      onSelected: (bool value) {
                        setModalState(() {
                          if (value) {
                            selectedSymptoms.add(symptom);
                          } else {
                            selectedSymptoms.remove(symptom);
                          }
                        });
                        setState(() {});
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24), // ⬅️ chips 和底部間距
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildTag(String tag) {
    return Chip(
      label: Text(
        tag,
        style: const TextStyle(
          color: Color(0xFF669FA5),
          fontWeight: FontWeight.bold,
        ),
      ),
      deleteIcon: const Icon(Icons.close, size: 16, color: Color(0xFF669FA5)),
      onDeleted: () {
        setState(() {
          selectedSymptoms.remove(tag);
        });
      },
      backgroundColor: const Color(0xFFE5F8F8), // 淺底
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF669FA5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor2,
      body: Column(
        children: [
          // Header6(
          //   title: '註冊帳號',
          //   icon: Icon(Icons.arrow_back, color: FrontUtil.textColor),
          // ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BearWithTextBox(text: '請問您有哪些症狀呢?'),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _showMultiSelect,
                          child: Container(
                            width: 180,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0xFF5E9CA0), width: 1),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '選擇症狀',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down,
                                    color: Color(0xFF5E9CA0)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8, // ➝ 水平方向 chip 間距
                            runSpacing: 8, // ➝ 換行時 chip 的上下間距
                            children: selectedSymptoms.map(_buildTag).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    onPressed: () async {
                      final register = context.read<Register>();
                      register.setDisease(selectedSymptoms);
                      final error = await register.register();
                      if (error == null) {
                        FrontUtil.showSuccess('註冊成功!請登入帳號');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      } else {
                        FrontUtil.showFail(error);
                      }
                    },
                    icon: Icon(
                      Icons.check_circle_rounded,
                      size: 40,
                      color: FrontUtil.textColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
