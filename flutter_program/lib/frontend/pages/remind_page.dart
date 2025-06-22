import 'package:flutter/material.dart';

class RemindPage extends StatefulWidget {
  const RemindPage({super.key});

  @override
  State<RemindPage> createState() => _RemindPageState();
}

class _RemindPageState extends State<RemindPage> {
  List<bool> isEditingList = [false, false, false];
  String selectedWeekday = '周四';
  TimeOfDay selectedTime = const TimeOfDay(hour: 17, minute: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      appBar: AppBar(
        title: const Text(
          '護理提醒',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 2.5,
            color: Color(0xFF669FA5),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF669FA5)),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: const Color(0xFF669FA5),
            height: 2.0,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          buildReminderCard(
              index: 0,
              imagePath: 'images/hospital.png',
              date: '20XX/XX/XX',
              woundType: '擦傷',
              remindDate: '2025/06/10',
              time: '18：30'),
          buildReminderCard(
              index: 1,
              imagePath: 'images/hospital.png',
              date: '20XX/XX/XX',
              woundType: '擦傷',
              remindDate: '2025/06/13',
              time: '18：30'),
          buildReminderCard(
              index: 2,
              imagePath: 'images/hospital.png',
              date: '20XX/XX/XX',
              woundType: '割傷',
              remindDate: '2025/06/03',
              time: '18：30'),
        ],
      ),
    );
  }

  Widget buildReminderCard({
    required int index,
    required String imagePath,
    required String date,
    required String woundType,
    required String remindDate,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF669FA5), width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: isEditingList[index]
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('拍攝日：$date', style: _infoStyle()),
                            Text('傷口類型：$woundType', style: _infoStyle()),
                            Text('換藥時間：$remindDate $time', style: _infoStyle()),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('換藥頻率：', style: TextStyle(color: Color(0xFF589399))),
                                const SizedBox(width: 8),
                                DropdownButton<String>(
                                  value: selectedWeekday,
                                  items: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
                                      .map((day) => DropdownMenuItem(
                                            value: day,
                                            child: Text(day,style: const TextStyle(color: Color(0xFF589399),fontSize: 14),),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedWeekday = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('換藥時間：', style: TextStyle(color: Color(0xFF589399))),
                                _buildTimeBox('${selectedTime.hour.toString().padLeft(2, '0')}'),
                                const Text('：'),
                                _buildTimeBox('${selectedTime.minute.toString().padLeft(2, '0')}'),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('拍攝日：$date', style: _infoStyle()),
                            Text('傷口類型：$woundType', style: _infoStyle()),
                            Text('換藥時間：$time', style: _infoStyle()),
                          ],
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -3,
            bottom: -3,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isEditingList[index] = !isEditingList[index];
                });
              },
              icon: const Icon(Icons.edit_rounded, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _infoStyle() {
    return const TextStyle(fontSize: 14, color: Color(0xFF589399), height: 1.5);
  }

  Widget _buildTimeBox(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF669FA5)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF264E5C)),
      ),
    );
  }
}
