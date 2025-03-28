import 'package:flutter/material.dart';
import '../../my_flutter_app_icons.dart';
import 'components/reminder_card.dart';
// import '../../tabs.dart';
import '../headers/header_1.dart';
import 'components/wound_info_card.dart';

class RemindPage extends StatelessWidget {
  const RemindPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFEBFEFF),
        ),
        child: Column(
          children: [
            const HeaderPage1(
              title: "傷口紀錄冊",
              icon: Icon(
                MyFlutterApp.bell,
                size: 23,
                color: Color(0xFF589399),
              ),
              // targetPage: RemindPage(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  ReminderCard(
                    imageUrl:
                        'https://top1cdn.top1health.com/cdn/am/705/3005.jpg',
                    date: '20XX/XX/XX',
                    woundType: '擦傷',
                    medicationTime: '周一 18：30',
                  ),
                  SizedBox(height: 24),
                  ReminderCard(
                    imageUrl:
                        'https://top1cdn.top1health.com/cdn/am/705/3005.jpg',
                    date: '20XX/XX/XX',
                    woundType: '擦傷',
                    medicationTime: '周一 20：30',
                  ),
                  SizedBox(height: 24),
                  ReminderCard(
                    imageUrl:
                        'https://top1cdn.top1health.com/cdn/am/705/3005.jpg',
                    date: '20XX/XX/XX',
                    woundType: '擦傷',
                    medicationTime: '周一 18：30',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Tabs(), // 移到 bottomNavigationBar
    );
  }
}
