import 'package:drw/backend/viewmodels/register_view_model.dart';
// import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/registerpages/information2_page.dart';
import 'package:drw/frontend/utility/bear_message.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

enum HabitOption { none, occasional, frequent }

class _HabitPageState extends State<HabitPage> {
  HabitOption? smoking = HabitOption.none;
  HabitOption? drinking = HabitOption.none;
  HabitOption? betelNut = HabitOption.none;

  Widget buildOptionRow(
    String title,
    HabitOption? groupValue,
    void Function(HabitOption?) onChanged,
    List<String> options, {
    String? note,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2E6D74),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (note != null) ...[
              const SizedBox(width: 6),
              Text(
                note,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: HabitOption.values.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<HabitOption>(
                    value: value,
                    groupValue: groupValue,
                    onChanged: onChanged,
                    activeColor: const Color(0xFF5E9CA0),
                  ),
                  Text(
                    options[index],
                    style: const TextStyle(color: Color(0xFF5E9CA0)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final register = context.read<Register>();
    return Scaffold(
      backgroundColor: FrontUtil.bkColor2,
      body: Column(
        children: [
          // Header6(
          //   title: '註冊帳號',
          //   icon: Icon(
          //     Icons.arrow_back,
          //     color: FrontUtil.textColor,
          //   ),
          // ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const BearWithTextBox(text: '請問您有以下習慣嗎?'),
                                  const SizedBox(height: 40),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.88,
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 30, 20, 10),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color(0x80589399),
                                            offset: Offset(0, -1)),
                                        BoxShadow(
                                          color: Colors.white,
                                          spreadRadius: -0.5,
                                          blurRadius: 1.5,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildOptionRow(
                                          '抽菸',
                                          smoking,
                                          (value) => setState(() {
                                            smoking = value;
                                            if (value != null) {
                                              register.setSmokingFreq([
                                                '無',
                                                '偶爾',
                                                '經常'
                                              ][value.index]);
                                            }
                                          }),
                                          ['無', '偶爾', '經常'],
                                          note: '※偶爾：每周 1~6 根',
                                        ),
                                        buildOptionRow(
                                          '喝酒',
                                          drinking,
                                          (value) => setState(() {
                                            drinking = value;
                                            if (value != null) {
                                              register.setDrinkingFreq([
                                                '無',
                                                '偶爾',
                                                '經常'
                                              ][value.index]);
                                            }
                                          }),
                                          ['無', '偶爾', '經常'],
                                          note: '※偶爾：每月 1~3 次',
                                        ),
                                        buildOptionRow(
                                          '嚼檳榔',
                                          betelNut,
                                          (value) => setState(() {
                                            betelNut = value;
                                            if (value != null) {
                                              register.setBetelNutFreq([
                                                '無',
                                                '偶爾',
                                                '經常'
                                              ][value.index]);
                                            }
                                          }),
                                          ['無', '偶爾', '經常'],
                                          note: '※偶爾：每月 1~5 次',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider.value(
                                            value: register,
                                            child: const Information2Page(),
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
