import 'package:flutter/material.dart';

class FamilyDialog extends StatefulWidget {
  const FamilyDialog({super.key});

  @override
  State<FamilyDialog> createState() => _FamilyDialogState();
}

class _FamilyDialogState extends State<FamilyDialog> {
  @override
  Widget build(BuildContext context) {
    final members = [
      {'name': '我滴家', 'icon': Icons.home_filled, 'isMain': true},
      {'name': '媽媽'},
      {'name': '爸爸'},
      {'name': '哥哥'},
      {'name': '叔叔'},
      {'name': '奶奶'},
    ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
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
              '請選擇要切換的角色',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF326A6A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

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
                return Column(
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
                        if (member['isMain'] == true)
                          const Icon(Icons.home, size: 14, color: Color(0xFF589399)),
                        if (member['isMain'] == true) const SizedBox(width: 3),
                        Text(
                          member['name'] as String,
                          style: const TextStyle(
                            color: Color(0xFF589399),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // 新增家庭成員按鈕
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // TODO: 新增家庭成員的行為
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
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 30, 50, 20),
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
                _editableRow(label: "出生年份", value: "2025", icon: Icons.calendar_today),
                const Divider(color: Color(0xFF669FA5)),
                const SizedBox(height: 10),
                _editableRow(
                    label: "個人習慣",
                    value: "未填寫",
                    icon: Icons.edit,
                    onTap: () => _showHabitDialog(context)),
                const Divider(color: Color(0xFF669FA5)),
                const SizedBox(height: 10),
                _editableRow(label: "特殊疾病", value: "未填寫", icon: Icons.edit),
                const Divider(color: Color(0xFF669FA5)),
                // const SizedBox(height: 12),
                IconButton(
                  onPressed: () {
                    debugPrint('新成員名稱：${nameController.text}');
                    Navigator.pop(context);
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, color: Color(0xFF2E6D74), fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        InkWell(
          onTap: onTap ?? () {},
          child: Icon(icon, size: 18, color: const Color(0xFF2E6D74)),
        )
      ],
    );
  }

  void _showHabitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        //用 Map 儲存每一項習慣的選擇
        Map<String, String> habits = {
          '抽菸': '無',
          '喝酒': '無',
          '嚼檳榔': '無',
        };

        //建立選項組件
        Widget buildHabitRow(String title, List<String> options) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
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
                            groupValue: habits[title],
                            activeColor: const Color(0xFF2E6D74),
                            visualDensity:
                                const VisualDensity(horizontal: -4, vertical: -4), // 減少 Radio 佔據的空間
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 去除多餘空白點擊範圍
                            onChanged: (value) {
                              habits[title] = value!;
                              (context as Element).markNeedsBuild();
                            },
                          ),
                          Text(
                            option,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2E6D74),
                            ),
                          ),
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
                buildHabitRow("抽菸", ["無", "偶爾(每周1～6根)", "經常"]),
                buildHabitRow("喝酒", ["無", "偶爾(每月1～3次)", "經常"]),
                buildHabitRow("嚼檳榔", ["無", "偶爾(每月1～5次)", "經常"]),
                const SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: () {
                //     debugPrint("個人習慣選擇：$habits");
                //     Navigator.pop(context);
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color(0xFF5A7C7C),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     minimumSize: const Size(100, 40),
                //   ),
                //   child: const Text(
                //     "完成",
                //     style: TextStyle(color: Colors.white, fontSize: 16),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
