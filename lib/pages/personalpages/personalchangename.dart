import 'package:flutter/material.dart';
import '../headers/header_2.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({super.key});

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FEFF),
      body: Column(
        children: [
          const HeaderPage2(title: "我的暱稱"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    "修改暱稱",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFF669FA5),
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF669FA5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                        onPressed: () {
                          Fluttertoast.showToast(
                            msg: "修改成功",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: const Color.fromARGB(255, 106, 216, 110),
                            textColor: const Color.fromARGB(255, 38, 82, 40),
                            fontSize: 16.0,
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "確定",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
