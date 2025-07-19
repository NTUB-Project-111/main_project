import 'package:drw/backend/viewmodels/register_view_model.dart';
// import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/registerpages/habit_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/utility/bear_message.dart';
import 'package:drw/frontend/pages/registerpages/birthday_year_selector_part.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BirthdayPage extends StatefulWidget {
  const BirthdayPage({super.key});

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  int selectedYear = DateTime.now().year;

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
      final register = context.read<Register>();
      register.setBirthday(picked);
      setState(() {
        selectedYear = picked;
      });
    }
  }

  // ⭐ 改寫為 Stateful 內部方法，能讀取 selectedYear
  Widget _buildButton() {
    return GestureDetector(
      onTap: _selectYear,
      child: Container(
        margin: const EdgeInsets.only(top: 40, bottom: 20),
        width: 150,
        height: 80,
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0x80589399), offset: Offset(0, -1)), //
            BoxShadow(
              color: Colors.white,
              spreadRadius: -0.5,
              blurRadius: 1.5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            selectedYear.toString(),
            style: TextStyle(
              color: FrontUtil.textColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                  const BearWithTextBox(text: '請問您出生的西元年份為?'),
                  _buildButton(), // ⭐ 用內部方法
                  IconButton(
                    onPressed: () {
                      // 可取 selectedYear 來傳到下一頁
                      final register = context.read<Register>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: register,
                            child: const HabitPage(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_circle_right_sharp,
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
