import 'package:flutter/material.dart';
import '../headers/header_3.dart';
import '../../my_flutter_app_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(children: [
      const HeaderPage3(
        icon: Icon(
          MyFlutterApp.bell,
          color: Color(0xFF669FA5),
          size: 23,
        ),
      ),
      Container(
        color: Colors.white,
        width: size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 陰影
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // 陰影顏色和透明度
                    spreadRadius: 1, // 陰影擴散
                    blurRadius: 1, // 模糊程度
                    offset: const Offset(1, 3), // 偏移量 (x, y)
                  ),
                ],
                borderRadius: BorderRadius.circular(10), // 圓角與圖片一致
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'images/knowledge.png',
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '今日',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFF669FA5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(3, 0, 5, 3),
                  child: Text(
                    '換藥提醒',
                    style: TextStyle(fontSize: 15, color: Color(0xFF669FA5)),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Divider(
                    color: Color(0xFF669FA5),
                    thickness: 1,
                  ),
                )),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ReminderTile("10:30", "右手臂換藥"),
                  ReminderTile("14:30", "右手臂換藥"),
                  ReminderTile("17:50", "右手臂換藥"),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget ReminderTile(String time, String description) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(214, 242, 244, 0.3),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color.fromRGBO(133, 162, 164, 1.0)),
      ),
      child: Row(
        children: [
          Text(
            time,
            style: const TextStyle(fontSize: 15, color: Color(0xFF669FA5)),
          ),
          const SizedBox(width: 13),
          Text(
            description,
            style: const TextStyle(fontSize: 15, color: Color(0xFF669FA5)),
          ),
        ],
      ),
    );
  }
}
