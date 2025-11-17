import 'package:drw/backend/models/family.dart';
import 'package:drw/backend/provider/family_provider.dart';
import 'package:drw/backend/services/family_service.dart';
import 'package:drw/frontend/pages/registerpages/birthday_year_selector_part.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberDialog extends StatefulWidget {
  final List<UserFamily> userFamily;
  const MemberDialog({super.key, required this.userFamily});

  @override
  State<MemberDialog> createState() => _MemberDialogState();
}

class _MemberDialogState extends State<MemberDialog> {
  final TextEditingController nameController = TextEditingController();
  // List<String> members = ['爸爸', '媽媽', '哥哥', '姊姊', '弟弟', '妹妹'];
  int selectedYear = DateTime.now().year;
  String yearText = '未填寫';
  String selectedYearText = '';
  List<String> selectedHabitText = ['', '', ''];
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
  String selectedDiseaseText = '未填寫';
  FamilyService familyService = FamilyService();
  List<String> members = [];
  @override
  void initState() {
    super.initState();
    for (var member in widget.userFamily) {
      members.add(member.role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '請選擇身分',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF326A6A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // 家庭成員方格
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: members.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 100,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      // 熊頭圖片
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/icon.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            members[index],
                            style: const TextStyle(
                              color: Color(0xFF589399),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 新增家庭成員按鈕
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: TextButton(
                  onPressed: () {
                    showAddMemberDialog(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Color(0xFF589399)),
                      Text(
                        '新增家庭成員',
                        style: TextStyle(
                          color: Color(0xFF589399),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '填寫新成員資料',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2F6F6F),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Image.asset('images/icon.png', height: 90),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "成員名稱",
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2E6D74),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // const SizedBox(width: 6),
                        Icon(Icons.edit, size: 18, color: Colors.grey[600]),
                      ],
                    ),

                    const SizedBox(height: 26),

                    // ===== 出生年份 =====
                    _infoRow(
                      label: '出生年份',
                      value: selectedYearText == '' ? yearText : selectedYearText,
                      icon: Icons.calendar_today_outlined,
                      onTap: () async {
                        final picked = await _selectYear();
                        if (picked != null) {
                          setState(() {
                            // selectedYear = picked;
                            selectedYearText = picked.toString();
                          });
                          setStateDialog(() {}); // ← 重新刷新 Dialog 的 UI
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _infoRow(
                      label: '個人習慣',
                      value: selectedHabitText.every((e) => e.isEmpty)
                          ? '未填寫'
                          : "抽菸：${selectedHabitText[0]}，喝酒：${selectedHabitText[1]}，嚼檳榔：${selectedHabitText[2]}",
                      icon: Icons.edit,
                      onTap: () async {
                        final result = await _showHabitDialog(context);
                        if (result != null) {
                          setState(() {
                            selectedHabitText = result;
                          });
                          setStateDialog(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _infoRow(
                      label: '特殊疾病',
                      value: selectedDiseaseText,
                      icon: Icons.edit,
                      onTap: () async {
                        final result = await _showMultiSelect();
                        // debugPrint(result.toString());
                        if (result != null) {
                          setState(() {
                            selectedSymptoms = result;
                            selectedDiseaseText =
                                selectedSymptoms.isEmpty ? '未填寫' : selectedSymptoms.join('、');
                          });
                          setStateDialog(() {});
                        }
                      },
                    ),

                    const SizedBox(height: 15),
                    (selectedYearText.isNotEmpty &&
                            selectedHabitText.every((e) => e.isNotEmpty) &&
                            selectedSymptoms.isNotEmpty &&
                            selectedDiseaseText != '未填寫')
                        ? IconButton(
                            onPressed: () async {
                              final habitfreq =
                                  '${selectedHabitText[0]}、${selectedHabitText[1]}、${selectedHabitText[2]}';
                              final response = await familyService.addMember(
                                  userId: widget.userFamily[0].userId,
                                  role: nameController.text,
                                  birthyear: selectedYear,
                                  disease: selectedDiseaseText,
                                  freq: habitfreq);
                              final familyProvider = context.read<FamilyProvider>();
                              // debugPrint(message);
                              if (response!['result'] == null) {
                                familyProvider.addMember(UserFamily.fromJson(response['member']));
                                setState(() {
                                  members.add(
                                    nameController.text,
                                  );
                                });
                                Navigator.pop(context);
                              } else if (response['result'] == '該成員已存在') {
                                FrontUtil.showError('該成員已存在', Colors.red, Colors.white);
                              } else {
                                FrontUtil.showError('成員新增失敗', Colors.red, Colors.white);
                              }
                            },
                            icon:
                                const Icon(Icons.check_circle, color: Color(0xFF2E6D74), size: 30),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff2F6F6F),
                ),
              ),
              SizedBox(
                width: 80, // 自訂寬度
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: value == '未填寫' ? Colors.grey : Colors.black87,
                  ),
                ),
              ),

              // const Spacer(),
              Icon(icon, size: 18, color: const Color(0xff2F6F6F)),
            ],
          ),

          const SizedBox(height: 6),

          // 底線
          Container(
            height: 1,
            color: const Color(0xff2F6F6F),
          ),
        ],
      ),
    );
  }

  Future<int?> _selectYear() async {
    final picked = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: YearSelectorDialog(
          selectedYear: selectedYear,
          maxYear: DateTime.now().year,
          minYear: 1900,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );

    if (picked != null && picked != selectedYear) {
      return picked;
    }
    return null;
  }

  Future<List<String>?> _showHabitDialog(BuildContext context) async {
    List<String> tempSelection = ['無', '無', '無'];
    String smoke = "無", drink = "無", betel = "無";
    if (selectedHabitText[0] != '') {
      tempSelection[0] = selectedHabitText[0];
      smoke = selectedHabitText[0];
    }
    if (selectedHabitText[1] != '') {
      tempSelection[1] = selectedHabitText[1];
      drink = selectedHabitText[1];
    }
    if (selectedHabitText[2] != '') {
      tempSelection[2] = selectedHabitText[2];
      betel = selectedHabitText[2];
    }

    return showDialog<List<String>>(
      context: context,
      barrierDismissible: true, // 點外面也可以關閉
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget buildSectionTitle(String text) => Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E6D74),
                    ),
                  ),
                );

            Widget buildRadioItem(String label, String value, String groupValue,
                    void Function(String?) onChanged) =>
                Row(
                  children: [
                    Radio(
                      value: value,
                      groupValue: groupValue,
                      activeColor: const Color(0xFF669FA5),
                      onChanged: onChanged,
                    ),
                    Text(label, style: const TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
                  ],
                );

            Widget buildRadioRow({
              required String groupValue,
              required void Function(String?) onChanged,
            }) =>
                Row(
                  children: [
                    buildRadioItem("無", "無", groupValue, onChanged),
                    const SizedBox(width: 20),
                    buildRadioItem("偶爾", "偶爾", groupValue, onChanged),
                    const SizedBox(width: 20),
                    buildRadioItem("經常", "經常", groupValue, onChanged),
                  ],
                );

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "個人習慣",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF2E6D74)),
                    ),
                    // 抽菸
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      buildSectionTitle("抽菸"),
                      buildRadioRow(
                          groupValue: smoke,
                          onChanged: (v) => setState(() {
                                smoke = v!;
                                tempSelection[0] = smoke;
                              })),
                      // 喝酒
                      buildSectionTitle("喝酒"),
                      buildRadioRow(
                          groupValue: drink,
                          onChanged: (v) => setState(() {
                                drink = v!;
                                tempSelection[1] = drink;
                              })),
                      // 嚼檳榔
                      buildSectionTitle("嚼檳榔"),
                      buildRadioRow(
                          groupValue: betel,
                          onChanged: (v) => setState(() {
                                betel = v!;
                                tempSelection[2] = betel;
                              })),
                    ]),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, tempSelection),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E6D74)),
                      child: const Text("確定", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<String>?> _showMultiSelect() async {
    return await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        List<String> tempSelection = List.from(selectedSymptoms); // 先複製一份目前的選項

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: symptoms.map((symptom) {
                      final isSelected = tempSelection.contains(symptom);
                      return FilterChip(
                        label: Text(symptom),
                        selected: isSelected,
                        selectedColor: const Color(0xFFE5F8F8),
                        checkmarkColor: const Color(0xFF5E9CA0),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF5E9CA0) : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF5E9CA0) : Colors.grey[400]!,
                          ),
                        ),
                        onSelected: (value) {
                          setModalState(() {
                            if (value) {
                              tempSelection.add(symptom);
                            } else {
                              tempSelection.remove(symptom);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // 確定按鈕：關閉 BottomSheet，並把選擇傳回外層
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, tempSelection); // 回傳值
                      },
                      child: const Text("確定"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // void _showMultiSelect() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(builder: (context, setModalState) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), // 外框 padding
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // drag handle
  //               Center(
  //                 child: Container(
  //                   width: 40,
  //                   height: 4,
  //                   margin: const EdgeInsets.only(bottom: 20),
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[300],
  //                     borderRadius: BorderRadius.circular(2),
  //                   ),
  //                 ),
  //               ),
  //               const Text(
  //                 '選擇症狀',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF5E9CA0),
  //                 ),
  //               ),
  //               const SizedBox(height: 16), // ⬅️ 標題和 chips 間距
  //               Wrap(
  //                 spacing: 8, // ⬅️ chips 左右間距
  //                 runSpacing: 8, // ⬅️ chips 上下間距
  //                 children: symptoms.map((symptom) {
  //                   final isSelected = selectedSymptoms.contains(symptom);
  //                   return FilterChip(
  //                     label: Text(symptom),
  //                     selected: isSelected,
  //                     selectedColor: const Color(0xFFE5F8F8),
  //                     checkmarkColor: const Color(0xFF5E9CA0),
  //                     labelStyle: TextStyle(
  //                       color: isSelected ? const Color(0xFF5E9CA0) : Colors.grey[700],
  //                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //                     ),
  //                     shape: StadiumBorder(
  //                       side: BorderSide(
  //                         color: isSelected ? const Color(0xFF5E9CA0) : Colors.grey[400]!,
  //                       ),
  //                     ),
  //                     // onSelected: (bool value) {
  //                     //   setModalState(() {
  //                     //     if (value) {
  //                     //       selectedSymptoms.add(symptom);
  //                     //     } else {
  //                     //       selectedSymptoms.remove(symptom);
  //                     //     }
  //                     //   });
  //                     //   setState(() {
  //                     //     // selectedDiseaseText = selectedSymptoms.toString();
  //                     //   });
  //                     // },
  //                     onSelected: (bool value) {
  //                       setModalState(() {
  //                         if (value) {
  //                           selectedSymptoms.add(symptom);
  //                         } else {
  //                           selectedSymptoms.remove(symptom);
  //                         }
  //                       });

  //                       // 同步更新外層畫面
  //                       setState(() {
  //                         selectedDiseaseText =
  //                             selectedSymptoms.isEmpty ? '未填寫' : selectedSymptoms.join('、');
  //                       });
  //                     },
  //                   );
  //                 }).toList(),
  //               ),
  //               const SizedBox(height: 24), // ⬅️ chips 和底部間距
  //             ],
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }
}
