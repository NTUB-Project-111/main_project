
import 'package:drw/backend/viewmodels/register_view_model.dart';
import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/registerpages/birthday_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
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
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/nurse_bear.png',
                    width: 150,
                    height: 150,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: FrontUtil.textColor, width: 1.5),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Text(
                      '為了讓未來的護體建議更加準確!\n先讓我來認識你吧!',
                      style: TextStyle(
                        color: FrontUtil.textColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
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
                            child: const BirthdayPage(),
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
