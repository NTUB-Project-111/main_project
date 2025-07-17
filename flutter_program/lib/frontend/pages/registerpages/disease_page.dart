import 'package:drw/backend/viewmodels/register_view_model.dart';
// import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/login_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/utility/bear_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiseasePage extends StatefulWidget {
  const DiseasePage({super.key});

  @override
  State<DiseasePage> createState() => _DiseasePageState();
}

class _DiseasePageState extends State<DiseasePage> {
  final List<String> symptoms = ['糖尿病', '高血糖', '高血脂', '癌症', '愛滋病', '貧血'];
  List<String> selectedSymptoms = [];

  void _showMultiSelect() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        // final register = context.read<Register>();
        return StatefulBuilder(builder: (context, setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                '選擇症狀',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E9CA0)),
              ),
              const Divider(
                color: Color(0xFF5E9CA0),
              ),
              ...symptoms.map((symptom) {
                return CheckboxListTile(
                  title: Text(
                    symptom,
                    style: const TextStyle(color: Color(0xFF5E9CA0)),
                  ),
                  activeColor: const Color(0xFF5E9CA0),
                  value: selectedSymptoms.contains(symptom),
                  onChanged: (bool? value) {
                    setModalState(() {
                      if (value == true) {
                        selectedSymptoms.add(symptom);
                      } else {
                        selectedSymptoms.remove(symptom);
                      }
                    });

                    setState(() {}); // 更新主畫面顯示
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
          );
        });
      },
    );
  }

  Widget _buildTag(String tag) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSymptoms.remove(tag);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: FrontUtil.textColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x80669FA5),
              offset: Offset(1, 2),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tag,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.close, color: Colors.white, size: 16),
          ],
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
                  const BearWithTextBox(text: '請問您有哪些症狀呢?'),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _showMultiSelect,
                          child: Container(
                            width: 180,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0xFF5E9CA0), width: 1),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '選擇症狀',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down,
                                    color: Color(0xFF5E9CA0)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: selectedSymptoms.map(_buildTag).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    onPressed: () async {
                      final register = context.read<Register>();
                      register.setDisease(selectedSymptoms);
                      final error = await register.register();
                      if (error == null) {
                        FrontUtil.showError(
                            '註冊成功!請登入帳號', Colors.green, Colors.white);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      } else {
                        FrontUtil.showError(error, Colors.red, Colors.white);
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
}
