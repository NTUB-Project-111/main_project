import 'package:drw/backend/viewmodels/register_view_model.dart';
import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/registerpages/information2_page.dart';
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

  Widget buildOptionRow(String title, HabitOption? groupValue,
      void Function(HabitOption?) onChanged, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2E6D74),
            fontWeight: FontWeight.bold,
          ),
        ),
        // const SizedBox(height: 6),
        Row(
          children: HabitOption.values.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            return Row(
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
                // const SizedBox(width: 10),
              ],
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
          Header6(
            title: '註冊帳號',
            icon: Icon(
              Icons.arrow_back,
              color: FrontUtil.textColor,
            ),
          ),
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
                                  const SizedBox(height: 30),
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 45), // 微調圖片下緣位置
                                        child: Image.asset(
                                          'images/nurse_bear.png',
                                          width: 110,
                                          height: 110,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 60), // 增加與圖片的間距（必要時微調）
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: FrontUtil.textColor,
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                        ),
                                        child: Text(
                                          '請問您有以下習慣嗎?',
                                          style: TextStyle(
                                            color: FrontUtil.textColor,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                                '偶爾 (每週1~6根)',
                                                '經常'
                                              ][value.index]);
                                            }
                                          }),
                                          ['無', '偶爾 (每週1~6根)', '經常'],
                                        ),
                                        buildOptionRow(
                                          '喝酒',
                                          drinking,
                                          (value) => setState(() {
                                            drinking = value;
                                            if (value != null) {
                                              register.setDrinkingFreq([
                                                '無',
                                                '偶爾 (每月1~3次)',
                                                '經常'
                                              ][value.index]);
                                            }
                                          }),
                                          ['無', '偶爾 (每月1~3次)', '經常'],
                                        ),
                                        buildOptionRow(
                                          '嚼檳榔',
                                          betelNut,
                                          (value) => setState(() {
                                            betelNut = value;
                                            if (value != null) {
                                              register.setBetelNutFreq([
                                                '無',
                                                '偶爾 (每月1~5次)',
                                                '經常'
                                              ][value.index]);
                                            }
                                          }),
                                          ['無', '偶爾 (每月1~5次)', '經常'],
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
