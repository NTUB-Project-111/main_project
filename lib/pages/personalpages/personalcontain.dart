import 'package:flutter/material.dart';
import '../headers/header_2.dart';
import './personalchangename.dart';
import '../../my_flutter_app_icons.dart';
import 'dart:io';
import './takepicture.dart';
import '../tabs.dart';

class PersonalContainPage extends StatefulWidget {
  final File? image;
  const PersonalContainPage({super.key, this.image});

  @override
  State<PersonalContainPage> createState() => _PersonalContainPageState();
}

class _PersonalContainPageState extends State<PersonalContainPage> {
  void _showButtonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color(0xFF589399),
            width: 2,
          ),
        ),
        backgroundColor: const Color(0xFFF5FEFF),
        contentPadding: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TakePicuturePage()));
              },
              splashColor: const Color(0xFFDFF6F7), // 點擊時的顏色
              highlightColor: const Color(0xFFDFF6F7), // 長按時的顏色
              borderRadius: BorderRadius.circular(15), // 可選，讓漣漪圓角更自然
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Color(0xFF669FA5)))),
                width: double.infinity,
                child: const Row(
                  children: [
                    Icon(MyFlutterApp.camera, color: Color(0xFF589399)),
                    SizedBox(width: 15),
                    Text("相機拍攝",
                        style:
                            TextStyle(color: Color(0xFF589399), fontSize: 14)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                print("app");
              },
              splashColor: const Color(0xFFDFF6F7), // 點擊時的顏色
              highlightColor: const Color(0xFFDFF6F7), // 長按時的顏色
              borderRadius: BorderRadius.circular(15), // 可選，讓漣漪圓角更自然
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: double.infinity,
                child: const Row(
                  children: [
                    Icon(MyFlutterApp.picture, color: Color(0xFF589399)),
                    SizedBox(width: 15),
                    Text("相簿選擇",
                        style:
                            TextStyle(color: Color(0xFF589399), fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2FEFF),
      body: Column(
        children: [
          const HeaderPage2(title: "個人基本資料", nextPage: Tabs(currentIndex: 4)),
          Column(
            children: [
              //使用者頭像
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 22),
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 1,
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: widget.image != null
                    ? ClipOval(
                        child: Image.file(
                          widget.image!,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const SizedBox(),
              ),
              //換頭像按鈕
              ElevatedButton(
                onPressed: () {
                  _showButtonDialog();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromRGBO(102, 159, 165, 1),
                ),
                child: const Text("更換頭像",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    )),
              ),

              //使用者資訊表
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
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
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromRGBO(242, 254, 255, 1)))),
                      padding: const EdgeInsets.fromLTRB(28, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('我的暱稱',
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xFF669FA5))),
                          Row(
                            children: [
                              const Text('[使用者暱稱]',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          Color.fromARGB(255, 140, 140, 140))),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChangeNamePage()));
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios,
                                      size: 15, color: Color(0xFF669FA5)))
                            ],
                          )
                        ],
                      ),
                    ),
                    // const Divider(color: Color.fromRGBO(242, 254, 255, 1)),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('生日',
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xFF669FA5))),
                          Text('[yyyy/mm/dd]',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 140, 140, 140))),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Color.fromRGBO(242, 254, 255, 1)))),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('電子信箱',
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xFF669FA5))),
                          Row(
                            children: [
                              Text('[xxx@gmail.com]',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          Color.fromARGB(255, 140, 140, 140))),
                              // IconButton(
                              //   onPressed: () {},
                              //   icon: const Icon(Icons.arrow_forward_ios,size: 15, color: Color(0xFF669FA5))
                              // )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
    // return Column(
    //   children: [
    //     //使用者頭像
    //     Container(
    //       margin: const EdgeInsets.only(top: 30, bottom: 22),
    //       width: 110,
    //       height: 110,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.black.withOpacity(0.35),
    //             blurRadius: 1,
    //           ),
    //         ],
    //         shape: BoxShape.circle,
    //       ),
    //       child: widget.image != null
    //           ? Image.file(widget.image!, width: 110,height: 110, fit: BoxFit.cover)
    //           : const SizedBox(),
    //     ),
    //     //換頭像按鈕
    //     ElevatedButton(
    //       onPressed: () {
    //         _showButtonDialog();
    //       },
    //       style: ElevatedButton.styleFrom(
    //         elevation: 0,
    //         backgroundColor: const Color.fromRGBO(102, 159, 165, 1),
    //       ),
    //       child: const Text("更換頭像",
    //           style: TextStyle(
    //             fontSize: 15,
    //             color: Colors.white,
    //             letterSpacing: 1.5,
    //           )),
    //     ),

    //     //使用者資訊表
    //     Container(
    //       width: double.infinity,
    //       margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(10),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.black.withOpacity(0.35),
    //             blurRadius: 1,
    //           ),
    //         ],
    //       ),
    //       child: Column(
    //         children: [
    //           Container(
    //             height: 60,
    //             decoration: const BoxDecoration(
    //                 border: Border(bottom: BorderSide(color: Color.fromRGBO(242, 254, 255, 1)))),
    //             padding: const EdgeInsets.fromLTRB(28, 0, 10, 0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 const Text('我的暱稱', style: TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
    //                 Row(
    //                   children: [
    //                     const Text('[使用者暱稱]',
    //                         style:
    //                             TextStyle(fontSize: 13, color: Color.fromARGB(255, 140, 140, 140))),
    //                     IconButton(
    //                         onPressed: () {
    //                           Navigator.push(context,
    //                               MaterialPageRoute(builder: (context) => const ChangeNamePage()));
    //                         },
    //                         icon: const Icon(Icons.arrow_forward_ios,
    //                             size: 15, color: Color(0xFF669FA5)))
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //           // const Divider(color: Color.fromRGBO(242, 254, 255, 1)),
    //           Container(
    //             height: 60,
    //             padding: const EdgeInsets.symmetric(horizontal: 28),
    //             child: const Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text('生日', style: TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
    //                 Text('[yyyy/mm/dd]',
    //                     style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 140, 140, 140))),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             height: 60,
    //             decoration: const BoxDecoration(
    //                 border: Border(top: BorderSide(color: Color.fromRGBO(242, 254, 255, 1)))),
    //             padding: const EdgeInsets.symmetric(horizontal: 28),
    //             child: const Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text('電子信箱', style: TextStyle(fontSize: 15, color: Color(0xFF669FA5))),
    //                 Row(
    //                   children: [
    //                     Text('[xxx@gmail.com]',
    //                         style:
    //                             TextStyle(fontSize: 13, color: Color.fromARGB(255, 140, 140, 140))),
    //                     // IconButton(
    //                     //   onPressed: () {},
    //                     //   icon: const Icon(Icons.arrow_forward_ios,size: 15, color: Color(0xFF669FA5))
    //                     // )
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
