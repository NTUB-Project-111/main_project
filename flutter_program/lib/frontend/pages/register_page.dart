import 'package:drw/frontend/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/register_model.dart';
import '../headers/header1.dart';
import '../tools/front_tool.dart';
import 'registerpages/personal_part.dart';
import 'registerpages/account_part.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => Register(),
        child: Scaffold(
            backgroundColor: const Color(0xFFEBFEFF),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Header1(
                    title: "註冊帳戶",
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF669FA5),
                    ),
                    targetPage: LoginPage(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const PersonalInfo(),
                        FrontTool.dash(MediaQuery.of(context).size.width),
                        const AccountSetup()
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
