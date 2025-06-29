import 'package:drw/backend/viewmodels/register_view_model.dart';
import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/registerpages/account_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNamePage extends StatefulWidget {
  const UserNamePage({super.key});

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final TextEditingController _nameController = TextEditingController();
  bool showButton = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        showButton = _nameController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final register = Provider.of<Register>(context);
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.all(5),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: FrontUtil.textColor, width: 1.5),
                    ),
                    child: ClipOval(
                      child: Image.asset('images/register_icon.png'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    width: 200,
                    child: TextField(
                      controller: _nameController,
                      onChanged: (value) => register.setName(value),
                      style: const TextStyle(
                        color: Color(0xCC669FA5),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        hintText: '輸入名稱',
                        hintStyle: const TextStyle(
                          color: Color(0xCC669FA5),
                          fontWeight: FontWeight.bold,
                        ),
                        suffixIcon: const Icon(
                          Icons.edit,
                          color: Color(0xCC669FA5),
                          size: 20,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: FrontUtil.textColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: FrontUtil.textColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      cursorColor: FrontUtil.textColor,
                    ),
                  ),
                  if (showButton)
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value( //register內容傳到下個頁面
                              value: register,
                              child: const AccountPage(),
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
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor:FrontUtil.textColor
                //   ),
                //     onPressed: () {},
                //     child: const Text('設定帳號密碼', style: TextStyle(color: Colors.white))),