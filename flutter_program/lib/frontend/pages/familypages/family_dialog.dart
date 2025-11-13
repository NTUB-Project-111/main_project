import 'package:drw/backend/models/family.dart';
import 'package:drw/backend/provider/family_provider.dart';
// import 'package:drw/backend/models/user.dart';
// import 'package:drw/backend/services/auth_service.dart';
import 'package:drw/backend/services/family_service.dart';
import 'package:drw/frontend/pages/registerpages/birthday_year_selector_part.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FamilyDialog extends StatefulWidget {
  final List<UserFamily> userFamily;
  final Widget? nextPage;
  // final List<String> userRole;
  const FamilyDialog({super.key, this.nextPage, required this.userFamily});

  @override
  State<FamilyDialog> createState() => _FamilyDialogState();
}

class _FamilyDialogState extends State<FamilyDialog> {
  final TextEditingController nameController = TextEditingController();
  int selectedYear = DateTime.now().year;
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
  List<String> selectedFreqs = ['無', '無', '無'];
  List<String> selectedSymptoms = [];
  String selectedYearText = "未填寫";
  String selectedHabitText = "未填寫";
  String selectedDiseaseText = "未填寫";
  // AuthService authService = AuthService();
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
    // final members = [
    //   {'name': '我滴家', 'icon': Icons.home_filled, 'isMain': true},
    //   {'name': '媽媽'},
    //   {'name': '爸爸'},
    //   {'name': '哥哥'},
    //   {'name': '叔叔'},
    //   {'name': '奶奶'},
    // ];

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
                final member = members[index];
                return InkWell(
                  onTap: () {
                    widget.nextPage == null
                        ? {debugPrint(member), Navigator.pop(context)}
                        : Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => widget.nextPage!),
                          );
                  },
                  child: Column(
                    children: [
                      // 熊頭圖片
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/icon.png'), // 你自己的熊圖
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // if (member['isMain'] == true)
                          //   const Icon(Icons.home, size: 14, color: Color(0xFF589399)),
                          // if (member['isMain'] == true) const SizedBox(width: 3),
                          Text(
                            member,
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
                    _addMember();
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

  void _addMember() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 5, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "填寫新成員資料",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E6D74),
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset("images/icon.png", height: 80),
                const SizedBox(height: 6),
                IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 18),
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
                      const SizedBox(width: 4),
                      const Icon(Icons.edit, size: 18, color: Color(0xFF2E6D74)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _editableRow(
                  label: "出生年份",
                  value: selectedYearText,
                  icon: Icons.calendar_today,
                  onTap: () => _selectYear(),
                ),
                const Divider(color: Color(0xFF669FA5)),
                const SizedBox(height: 10),
                _editableRow(
                  label: "個人習慣",
                  value: selectedHabitText,
                  icon: Icons.edit,
                  onTap: () => _showHabitDialog(context),
                ),
                const Divider(color: Color(0xFF669FA5)),
                const SizedBox(height: 10),
                _editableRow(
                  label: "特殊疾病",
                  value: selectedDiseaseText,
                  icon: Icons.edit,
                  onTap: () => _showMultiSelect(),
                ),

                const Divider(color: Color(0xFF669FA5)),
                // const SizedBox(height: 12),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      selectedHabitText = selectedFreqs.join("、");
                    });
                    debugPrint(selectedDiseaseText);
                    debugPrint(selectedFreqs.toString());
                    debugPrint(selectedYearText);
                    final response = await familyService.addMember(
                        userId: widget.userFamily[0].userId,
                        role: nameController.text,
                        birthyear: selectedYear,
                        disease: selectedDiseaseText,
                        freq: selectedHabitText);
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
                  icon: const Icon(Icons.check_circle, color: Color(0xFF2E6D74), size: 30),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _editableRow(
      {required String label, required String value, required IconData icon, VoidCallback? onTap}) {
    String str = '';
    return InkWell(
        onTap: onTap ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF2E6D74), fontWeight: FontWeight.bold)),
            str == ''
                ? Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[500]))
                : Text(str, style: const TextStyle(fontSize: 14, color: Color(0xFF2E6D74))),
            Icon(icon, size: 18, color: const Color(0xFF2E6D74)),
          ],
        ));
  }

  void _showHabitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        //建立選項組件
        Widget buildHabitRow(int index, List<String> options, String text) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                index == 0
                    ? "抽菸"
                    : index == 1
                        ? "喝酒"
                        : "嚼檳榔",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E6D74),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: options.map((option) {
                  return Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: option,
                            groupValue: selectedFreqs[index],
                            activeColor: const Color(0xFF2E6D74),
                            visualDensity:
                                const VisualDensity(horizontal: -4, vertical: -4), // 減少 Radio 佔據的空間
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 去除多餘空白點擊範圍
                            onChanged: (value) {
                              selectedFreqs[index] = value!;
                              (context as Element).markNeedsBuild();
                              setState(() {
                                selectedHabitText = selectedFreqs.toString();
                              });
                            },
                          ),
                          Text(
                            option,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2E6D74),
                            ),
                          ),
                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 10),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          );
        }

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "個人習慣",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E6D74),
                  ),
                ),
                const SizedBox(height: 20),

                //三組習慣選項
                buildHabitRow(0, ["無", "偶爾", "經常"], "每週1～6根"),
                buildHabitRow(1, ["無", "偶爾", "經常"], "每月1～3次"),
                buildHabitRow(2, ["無", "偶爾", "經常"], "每月1～5次"),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectYear() async {
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
      setState(() {
        selectedYear = picked;
        selectedYearText = "$picked 年";
      });
    }
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), // 外框 padding
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
                        color: isSelected ? const Color(0xFF5E9CA0) : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF5E9CA0) : Colors.grey[400]!,
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
                        setState(() {
                          selectedDiseaseText = selectedSymptoms.toString();
                        });
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
}
