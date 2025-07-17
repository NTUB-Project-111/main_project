import 'package:drw/backend/viewmodels/register_view_model.dart';
import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/login_page.dart';
import 'package:drw/frontend/pages/registerpages/disease_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/utility/bear_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Information2Page extends StatefulWidget {
  const Information2Page({super.key});

  @override
  State<Information2Page> createState() => _Information2PageState();
}

enum SpecialCondition { has, none }

class _Information2PageState extends State<Information2Page> {
  SpecialCondition? condition = SpecialCondition.has;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor2,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BearWithTextBox(text: '請問您是否有特殊症狀嗎?'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRadioOption('有', SpecialCondition.has),
                      const SizedBox(width: 30),
                      _buildRadioOption('沒有', SpecialCondition.none),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 顯示「特殊症狀」資訊框與下一步按鈕（若 condition == has）
                  if (condition == SpecialCondition.has) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
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
                    const SizedBox(height: 20),
                    IconButton(
                      onPressed: () {
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
                      },
                      icon: Icon(
                        Icons.arrow_circle_right_sharp,
                        size: 40,
                        color: FrontUtil.textColor,
                      ),
                    ),
                  ],

                  // 顯示「完成註冊」icon（若 condition == none）
                  if (condition == SpecialCondition.none) ...[
                    IconButton(
                      onPressed: () async {
                        final register = context.read<Register>();
                        // register.setDisease(null);
                        final error = await register.register();
                        if (error == null) {
                          FrontUtil.showSuccess('註冊成功!請登入帳號');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                          );
                        } else {
                          FrontUtil.showFail(error);
                        }
                      },
                      icon: Icon(
                        Icons.check_circle_rounded,
                        size: 40,
                        color: FrontUtil.textColor,
                      ),
                    ),
                  ],
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
              condition = newValue;
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


// ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text('請先選擇是否有特殊症狀'),
                        //     backgroundColor: Colors.redAccent,
                        //   ),
                        // );