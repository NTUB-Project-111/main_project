import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool showExtraButtons = false;
  bool showWoundChooser = false;
  Set<String> selectedWounds = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: List.generate(7, (_) => _buildWoundSection()),
                ),
              ),
              Visibility(
                visible: showWoundChooser,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 90),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x4D2E6D74),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 13,
                      runSpacing: 8,
                      children: [
                        _buildWoundButton("擦傷"),
                        _buildWoundButton("割傷"),
                        _buildWoundButton("痔傷"),
                        _buildWoundButton("燒傷"),
                        _buildWoundButton("刺傷"),
                        _buildWoundButton("手術傷口"),
                      ],
                    ),
                  ),
                ),
              ),
              // 1. 日曆按鈕（最底層）
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                right: showExtraButtons ? 155 : 15,
                bottom: 18, // 隱藏時往下滑出畫面外
                child: AnimatedOpacity(
                  opacity: showExtraButtons ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: !showExtraButtons,
                    child: _buildCircleButton(
                      icon: Icons.calendar_month,
                      onTap: () {
                        _showDatePicker();
                      },
                    ),
                  ),
                ),
              ),

              // 2. 儀表板按鈕（中間層）
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                right: showExtraButtons ? 90 : 15, // 拉出畫面外
                bottom: 18,
                child: AnimatedOpacity(
                  opacity: showExtraButtons ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: !showExtraButtons,
                    child: _buildCircleButton(
                      icon: Icons.space_dashboard_rounded,
                      onTap: () {
                        setState(() {
                          showWoundChooser = !showWoundChooser;
                        });
                      },
                    ),
                  ),
                ),
              ),

              // 3. 搜尋按鈕（最上層）
              Positioned(
                right: 15,
                bottom: 15,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showExtraButtons = !showExtraButtons;
                      showWoundChooser = false;
                    });
                    debugPrint(showExtraButtons.toString());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: FrontUtil.textColor, width: 2),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x4D2E6D74),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.search,
                      color: FrontUtil.textColor,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildWoundSection() {
    return Container(
      // color: FrontUtil.bkColor,
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 82,
            height: 82,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '使用者取的傷口名稱',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: FrontUtil.textColor, // 深藍綠
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '2025/07/20',
                  style: TextStyle(
                    fontSize: 14,
                    color: FrontUtil.textColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5),
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
            decoration: const BoxDecoration(
              color: Color(0xFF86BCA1), // 綠色背景
              shape: BoxShape.circle,
            ),
            child: const Text(
              '擦',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x4D2E6D74),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: FrontUtil.textColor,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildWoundButton(String text) {
    final isSelected = selectedWounds.contains(text);

    return SizedBox(
      width: 150,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            if (isSelected) {
              selectedWounds.remove(text); // 取消選擇
            } else {
              selectedWounds.add(text); // 加入選擇
            }
          });
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: FrontUtil.textColor,
          ),
          backgroundColor: isSelected ? FrontUtil.textColor : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 5),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : FrontUtil.textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: FrontUtil.textColor, // 主色（選擇日期的圓圈、按鈕）
              onPrimary: Colors.white, // 主色文字（日期數字）
              onSurface: Colors.black87, // 主要文字色（年、月、日）
            ),
            dialogBackgroundColor: Colors.white, // 日期選擇器背景
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      print("選擇的日期為：$pickedDate");
    }
  }
}
