import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../feature/notifer.dart';
import '../tabs.dart';
import '../../feature/database.dart';

class ResultPage6 extends StatefulWidget {
  final String woundType;
  const ResultPage6({super.key, required this.woundType});

  @override
  State<ResultPage6> createState() => _ResultPage6State();
}

class _ResultPage6State extends State<ResultPage6> {
  bool _isSaving = false;
  late List<String> oktimelist;
  List<Map<String, dynamic>> remindlist = [];
  void _createRemind() {
    remindlist.clear();
    String oktime = DatabaseHelper.record['oktime']
        .replaceAll(RegExp(r'\s+'), '') // 移除所有空白（空格、換行等）
        .replaceAll(RegExp(r'[\u4e00-\u9fa5]'), ''); // 移除所有中文字

    oktimelist = oktime.split("~");
    // print(_oktimelist);
    int okday = int.parse(oktimelist[1]); // 正確轉換成 int
    final freqMap = {
      "每天": 1,
      "兩天一次": 2,
      "三天一次": 3,
      "每週": 7,
    };
    final freqStr = DatabaseHelper.record['freq'];
    final freqDays = freqMap[freqStr] ?? 0;
    String dateStr = DatabaseHelper.record['date'];
    List<String> parts = dateStr.split('-');
    if (parts.length != 3) {
      print("日期格式錯誤: $dateStr");
      return;
    }

    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    DateTime startDate = DateTime(year, month, day);
    DateTime endDate = startDate.add(Duration(days: okday));
    DateTime remindDate = startDate.add(Duration(days: freqDays));

    while (!remindDate.isAfter(endDate)) {
      String formattedDay = "${remindDate.year.toString().padLeft(4, '0')}-"
          "${remindDate.month.toString().padLeft(2, '0')}-"
          "${remindDate.day.toString().padLeft(2, '0')}";

      remindlist.add({"day": formattedDay, "time": DatabaseHelper.record['time']});

      remindDate = remindDate.add(Duration(days: freqDays));
    }
    print(remindlist);
  }

  void _saveRecord() async {
    setState(() {
      _isSaving = true;
    });
    // print(DatabaseHelper.record);
    String? userId = await DatabaseHelper.getUserId();
    _createRemind();
    if (userId != null && userId.isNotEmpty) {
      // 建立部位+反應的字串
      final details = [
        DatabaseHelper.record['part'].toString(),
        DatabaseHelper.record['rection'].toString(),
      ].toList();

      final tags = details
          .join(', ')
          .trim()
          .replaceAll(RegExp(r'^,|,$'), '')
          .replaceAll('[', '')
          .replaceAll(']', '')
          .trim();

      // 儲存記錄
      await DatabaseHelper.addRecord(
        userId,
        DatabaseHelper.record['date'].toString(),
        DatabaseHelper.record['image'],
        DatabaseHelper.record['type'].toString(),
        DatabaseHelper.record['oktime'].toString(),
        DatabaseHelper.record['caremode'].toString(),
        DatabaseHelper.record['ifcall'].toString(),
        tags,
        DatabaseHelper.record['recording'].toString(),
      );

      DatabaseHelper.allRecords = (await DatabaseHelper.getUserRecords())!;
      if (DatabaseHelper.record['ifcall'].toString() == 'Y') {
        final recordId = DatabaseHelper.allRecords.last["id_record"].toString();
        for (var remind in remindlist) {
          bool result = await DatabaseHelper.addRemind(userId, recordId, remind["day"].toString(),
              remind["time"].toString(), DatabaseHelper.record['freq']);
          if (!result) {
            print("新增提醒失敗: $remind");
          }
        }
      }
      DatabaseHelper.allCalls = (await DatabaseHelper.getReminds()) ?? [];
      DatabaseHelper.remindRecords = (await DatabaseHelper.getRemindRecord()) ?? [];
      DatabaseHelper.homeRemind = (await DatabaseHelper.getHomeRemind()) ?? [];

      await Notifier.initialize();
      Notifier.scheduleReminders(DatabaseHelper.allCalls);
      Fluttertoast.showToast(
        msg: "儲存成功",
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 106, 216, 110),
        textColor: const Color.fromARGB(255, 38, 82, 40),
        fontSize: 16.0,
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Tabs()));
    } else {
      Fluttertoast.showToast(
        msg: "無法獲取使用者 ID，請稍後再試",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 22),
      child: widget.woundType != "無異常"
          ? Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const Tabs()));
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(
                        color: Color(0xFF589399),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '不儲存報告',
                      style: TextStyle(
                        color: Color(0xFF589399),
                        fontSize: 16,
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveRecord,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: _isSaving ? Colors.grey : const Color(0xFF589399),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isSaving ? '儲存中...' : '儲存報告',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const Tabs()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF589399),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '確定',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
