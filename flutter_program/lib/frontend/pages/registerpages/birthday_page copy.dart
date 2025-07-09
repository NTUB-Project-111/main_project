// import 'package:drw/backend/viewmodels/register_view_model.dart';
// import 'package:drw/frontend/headers/header6.dart';
// import 'package:drw/frontend/pages/registerpages/habit_page.dart';
// import 'package:drw/frontend/utility/front_util.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class BirthdayPage extends StatefulWidget {
//   const BirthdayPage({super.key});

//   @override
//   State<BirthdayPage> createState() => _BirthdayPageState();
// }

// class _BirthdayPageState extends State<BirthdayPage> {
//   int selectedYear = DateTime.now().year;

//   Future<void> _selectYear() async {
//     final picked = await showModalBottomSheet<int>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.6,
//           minChildSize: 0.4,
//           maxChildSize: 0.9,
//           builder: (_, controller) {
//             return Container(
//               margin: const EdgeInsets.all(12),
//               // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//               padding: const EdgeInsets.symmetric(
//                 vertical: 10,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     '選擇西元年份',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: FrontUtil.textColor,
//                     ),
//                   ),
//                   const Divider(
//                     thickness: 1.5,
//                     color: Color(0xFF2F7E87),
//                     height: 25,
//                   ),
//                   Expanded(
//                     child: GridView.builder(
//                       controller: controller,
//                       itemCount: DateTime.now().year - 1900 + 1, // 共 126 年
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3, // 每列 3 個年份
//                         crossAxisSpacing: 8,
//                         mainAxisSpacing: 8,
//                         childAspectRatio: 2.5, // 控制區塊寬高比例
//                       ),
//                       itemBuilder: (context, index) {
//                         final year = 1900 + index;
//                         return GestureDetector(
//                           onTap: () => Navigator.pop(context, year),
//                           child: Container(
//                             alignment: Alignment.center,
//                             // decoration: BoxDecoration(
//                             //   color: const Color(0xFFE0F7FA),
//                             //   borderRadius: BorderRadius.circular(10),
//                             // ),
//                             child: Text(
//                               year.toString(),
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: FrontUtil.textColor,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//     if (picked != null && picked != selectedYear) {
//       final register = context.read<Register>(); // ← 改成 read
//       register.setBirthday(picked); // ← 修正 set 的值為 picked
//       setState(() {
//         selectedYear = picked;
//       });
//     }
//   }

//   // ⭐ 改寫為 Stateful 內部方法，能讀取 selectedYear
//   Widget _buildButton() {
//     return GestureDetector(
//       onTap: _selectYear,
//       child: Container(
//         margin: const EdgeInsets.only(top: 40, bottom: 20),
//         width: 150,
//         height: 80,
//         decoration: BoxDecoration(
//           // color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(color: Color(0x80589399), offset: Offset(0, -1)), //
//             BoxShadow(
//               color: Colors.white,
//               spreadRadius: -0.5,
//               blurRadius: 1.5,
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             selectedYear.toString(),
//             style: TextStyle(
//               color: FrontUtil.textColor,
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: FrontUtil.bkColor2,
//       body: Column(
//         children: [
//           Header6(
//             title: '註冊帳號',
//             icon: Icon(Icons.arrow_back, color: FrontUtil.textColor),
//           ),
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Image.asset(
//                     'images/nurse_bear.png',
//                     width: 100,
//                     height: 100,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: FrontUtil.textColor, width: 1.5),
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.white,
//                     ),
//                     child: Text(
//                       '請問您出生的西元年份為?',
//                       style: TextStyle(
//                         color: FrontUtil.textColor,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.5,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   _buildButton(), // ⭐ 用內部方法
//                   IconButton(
//                     onPressed: () {
//                       // 可取 selectedYear 來傳到下一頁
//                       final register = context.read<Register>();
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChangeNotifierProvider.value(
//                             value: register,
//                             child: const HabitPage(),
//                           ),
//                         ),
//                       );
//                     },
//                     icon: Icon(
//                       Icons.arrow_circle_right_sharp,
//                       size: 40,
//                       color: FrontUtil.textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
