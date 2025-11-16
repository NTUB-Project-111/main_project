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

                    _infoRow(
                      label: '個人習慣',
                      value: '未填寫',
                      icon: Icons.edit,
                      onTap: () {},
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
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: value == '未填寫' ? Colors.grey : Colors.black87,
                ),
              ),
              const Spacer(),
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
}
