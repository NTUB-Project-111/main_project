import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:drw/backend/models/reminder.dart';

import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/tools/front_tool.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemindPage extends StatefulWidget {
  const RemindPage({super.key});

  @override
  State<RemindPage> createState() => _RemindPageState();
}

class _RemindPageState extends State<RemindPage> {
  final List<Reminder> reminders = [];
  bool _isInitialized = false;
  bool showDeleteButtons = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    final userInfo = Provider.of<UserProvider>(context, listen: false).user;
    if (userInfo != null) {
      // final reminderList =
      //     userInfo.reports.where((r) => r.ifcall == 'Y').map((r) => toReminderData(r)).toList();
      final reminderList = userInfo.reports
          .where((r) => r.ifcall == 'Y')
          .map((r) => Reminder.fromReport(r))
          .toList();

      setState(() => reminders.addAll(reminderList));
    }
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF669FA5)),
          onPressed: () {
            final modifiedList = reminders.where((r) => r.isModified).toList();
            if (modifiedList.isNotEmpty) {
              // 有資料被修改過
              debugPrint('被修改的筆數：${modifiedList.length}');
              showConfirmDialog(
                context,
                "是否儲存變更?",
                "確定",
                "取消",
                () => Navigator.pop(context),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('護理提醒',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, height: 2.5, color: Color(0xFF669FA5))),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF669FA5)),
            onPressed: () => setState(() {
              showDeleteButtons = !showDeleteButtons;
            }),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(height: 2.0, color: const Color(0xFF669FA5)),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: reminders.length,
        itemBuilder: (context, index) => buildReminderCard(index),
      ),
    );
  }

  Widget buildReminderCard(int index) {
    final data = reminders[index];
    final imageWidget = Image.network(
      data.imagePath.startsWith('http')
          ? data.imagePath
          : Uri.parse(ApiBase.baseUrl).resolve(data.imagePath).toString(),
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );

    final infoWidgets = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('拍攝日 ：${data.date}', style: _infoStyle()),
        Text('傷口類型 ：${data.woundType}', style: _infoStyle()),
        if (data.isEditing) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('換藥頻率 ：', style: TextStyle(color: Color(0xFF589399))),
              const SizedBox(width: 8),
              Flexible(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    value: data.selectedFreq,
                    items: ['每天', '兩天一次', '三天一次', '每週']
                        .map((day) => DropdownMenuItem<String>(
                              value: day,
                              child: Text(day,
                                  style: const TextStyle(color: Color(0xFF589399), fontSize: 14)),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => data.selectedFreq = value!),
                    buttonStyleData: ButtonStyleData(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF669FA5)),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      elevation: 0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFF669FA5)),
                        color: Colors.white,
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(height: 40),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('換藥時間 ：', style: TextStyle(color: Color(0xFF589399))),
              GestureDetector(
                onTap: () async {
                  final picked =
                      await showTimePicker(context: context, initialTime: data.selectedTime);
                  if (picked != null) setState(() => data.selectedTime = picked);
                },
                child: _buildTimeBox(data.selectedTime.hour.toString().padLeft(2, '0')),
              ),
              const Text(' ：'),
              GestureDetector(
                onTap: () async {
                  final picked =
                      await showTimePicker(context: context, initialTime: data.selectedTime);
                  if (picked != null) setState(() => data.selectedTime = picked);
                },
                child: _buildTimeBox(data.selectedTime.minute.toString().padLeft(2, '0')),
              ),
            ],
          ),
        ] else ...[
          Text('換藥時間 ：${data.remindDate} ${_formatTime(data.selectedTime)}', style: _infoStyle()),
          Text('換藥頻率 ：${data.selectedFreq}', style: _infoStyle()),
        ]
      ],
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
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
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(12), child: imageWidget),
                      const SizedBox(width: 12),
                      Flexible(child: infoWidgets),
                    ],
                  ),
                ),
                if (!showDeleteButtons)
                  Positioned(
                    right: -3,
                    top: data.isEditing ? -3 : null,
                    bottom: data.isEditing ? null : -3,
                    child: IconButton(
                      icon: Icon(data.isEditing ? Icons.check : Icons.edit_rounded,
                          size: 20, color: data.isEditing ? Colors.green : null),
                      onPressed: () => setState(() => data.isEditing = !data.isEditing),
                    ),
                  ),
              ],
            ),
          ),
          if (showDeleteButtons)
            Container(
              margin: const EdgeInsets.only(left: 3),
              child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red, size: 30),
                onPressed: () => setState(() => reminders.removeAt(index)),
              ),
            ),
        ],
      ),
    );
  }

  TextStyle _infoStyle() => const TextStyle(fontSize: 14, color: Color(0xFF589399), height: 1.5);

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')} ：${time.minute.toString().padLeft(2, '0')}';

  Widget _buildTimeBox(String text) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF669FA5)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(text,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF264E5C))),
      );
  void showConfirmDialog(
      BuildContext context, String title, String confirm, String cancel, VoidCallback onConfirm) {
    showDialog(
      barrierDismissible: false, // 禁止點擊外部區域關閉對話框
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF589399),
            width: 2,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF589399),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                backgroundColor: const Color(0xFF589399),
                side: BorderSide.none,
              ),
              onPressed: () {
                
                Navigator.pop(context); // 關閉對話框
                onConfirm();
              },
              child: Text(
                confirm,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                side: const BorderSide(
                  width: 2,
                  color: Color(0xFF589399),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // 關閉對話框
              },
              child: Text(
                cancel,
                style: const TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
