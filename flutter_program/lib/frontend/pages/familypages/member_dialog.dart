import 'package:drw/frontend/pages/registerpages/birthday_year_selector_part.dart';
import 'package:flutter/material.dart';

class MemberDialog extends StatefulWidget {
  const MemberDialog({super.key});

  @override
  State<MemberDialog> createState() => _MemberDialogState();
}

class _MemberDialogState extends State<MemberDialog> {
  List<String> members = ['爸爸', '媽媽', '哥哥', '姊姊', '弟弟', '妹妹'];
  int selectedYear = DateTime.now().year;
  String yearText = '未填寫';
  String selectedYearText = '';
  List<String> selectedHabitText = ['', '', ''];
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
                            image: AssetImage('images/icon.png'), // 你自己的熊圖
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
                        const Text('成員名稱', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(width: 6),
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

                    // _infoRow(
                    //   label: '個人習慣',
                    //   value: selectedHabitText.every((e) => e.isEmpty)
                    //       ? '未填寫'
                    //       : "抽菸：${selectedHabitText[0]}，喝酒：${selectedHabitText[1]}，嚼檳榔：${selectedHabitText[2]}",
                    //   icon: Icons.edit,
                    //   onTap: () {
                    //     _showHabitDialog(context);
                    //   },
                    // ),
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
                      value: '未填寫',
                      icon: Icons.edit,
                      onTap: () {},
                    ),

                    const SizedBox(height: 24),
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
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, tempSelection),
                      child: const Text("確定"),
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
}
