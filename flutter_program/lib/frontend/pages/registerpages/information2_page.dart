import 'package:drw/backend/viewmodels/register_view_model.dart';
import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/login_page.dart';
import 'package:drw/frontend/pages/registerpages/disease_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Information2Page extends StatefulWidget {
  const Information2Page({super.key});

  @override
  State<Information2Page> createState() => _Information2PageState();
}

enum SpecialCondition { has, none }

class _Information2PageState extends State<Information2Page> {
  SpecialCondition? condition = SpecialCondition.none;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor2,
      body: Column(
        children: [
          Header6(
            title: '註冊帳號',
            icon: Icon(Icons.arrow_back, color: FrontUtil.textColor),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/nurse_bear.png',
                    width: 100,
                    height: 100,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: FrontUtil.textColor, width: 1.5),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Text(
                      '請問您有以下特殊症狀嗎?',
                      style: TextStyle(
                        color: FrontUtil.textColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRadioOption('有', SpecialCondition.has),
                      const SizedBox(width: 30),
                      _buildRadioOption('沒有', SpecialCondition.none),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 白底說明框
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '↓ 『特殊症狀』 ↓',
                          style: TextStyle(
                            color: Color(0xFF2E6D74),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '慢性病（糖尿病、高血糖、高血脂等）\n、癌症、愛滋病、貧血等。',
                          style: TextStyle(
                            color: Color(0xFF2E6D74),
                            fontSize: 14,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      if (condition == SpecialCondition.none) {
                        // 選擇「沒有」→ 跳轉到 LoginPage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      } else if (condition == SpecialCondition.has) {
                        // 選擇「有」→ 跳轉到 DiseasePage
                        final register = context.read<Register>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: register,
                              child: const DiseasePage(),
                            ),
                          ),
                        );
                      } else {
                        // 尚未選擇 → 顯示錯誤提示
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('請先選擇是否有特殊症狀'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
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

  Widget _buildRadioOption(String label, SpecialCondition value) {
    return Row(
      children: [
        Radio<SpecialCondition>(
          value: value,
          groupValue: condition,
          onChanged: (SpecialCondition? newValue) {
            setState(() {
              condition = newValue; // ✅ 只更新狀態，不跳頁
            });
          },
          activeColor: const Color(0xFF5E9CA0),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2E6D74),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
