import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:drw/backend/models/reminder.dart';
import 'package:drw/backend/provider/remind_provider.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:drw/backend/services/record_service.dart';
import 'package:drw/backend/viewmodels/remind_view_model.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/utility/notifier_util.dart';
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
    loadReminders();
    _isInitialized = true;
  }

  Future<void> loadReminders() async {
    final userInfo = Provider.of<UserProvider>(context, listen: false).user;
    if (userInfo != null) {
      setState(() {
        reminders
          ..clear()
          ..addAll(userInfo.reports
                  .where((r) => r.ifcall == 'Y')
                  .map((r) => Reminder.fromReport(r))
                  .whereType<Reminder>() // 過濾掉 null
              );
      });
    }
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
            debugPrint('$modifiedList');
            if (modifiedList.isNotEmpty) {
              debugPrint('被修改的筆數：${modifiedList.length}');
              showConfirmDialog(
                context,
                "是否儲存變更?",
                "確定",
                "取消",
                () {
                  Navigator.pop(context);
                  Notifier.setRemind(context);
                },
                modifiedList,
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
            icon: const Icon(Icons.delete_rounded, color: Color(0xFF669FA5)),
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
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          if (reminder.isDelete) {
            return const SizedBox(); // 或 return Container()
          }
          return buildReminderCard(index);
        },
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
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: Reminder.parseTime(data.selectedTime),
                  );
                  if (picked != null) {
                    final formatted =
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                    setState(() => data.selectedTime = formatted);
                  }
                },
                child: _buildTimeBox(
                    Reminder.parseTime(data.selectedTime).hour.toString().padLeft(2, '0')),
              ),
              const Text(' ：'),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: Reminder.parseTime(data.selectedTime),
                  );
                  if (picked != null) {
                    final formatted =
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                    setState(() => data.selectedTime = formatted);
                  }
                },
                child: _buildTimeBox(
                    Reminder.parseTime(data.selectedTime).minute.toString().padLeft(2, '0')),
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
              // child: IconButton(
              //   icon: const Icon(Icons.cancel, color: Colors.red, size: 30),
              //   onPressed: () => setState(() {
              //     reminders[index].isDelete = true;

              //     // reminders.removeAt(index);
              //   }),
              // ),
              child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red, size: 30),
                onPressed: () {
                  FrontUtil.showConfirmDialog(
                    context,
                    FrontUtil.textColor,
                    '確定要刪除嗎？', // title
                    null, // subTitle 可放 null 或字串
                    '取消', // 取消按鈕文字
                    '確定', // 確認按鈕文字
                    () async {
                      setState(() {
                        reminders[index].isDelete = true;
                        reminders[index].isModifiedFlag = true;
                      });

                      final remindViewModel = RemindViewModel();
                      final success = await remindViewModel.updateRemind([reminders[index]]);
                      if (success) {
                        FrontUtil.showSuccess('提醒已刪除');
                        // 重新從後端取得最新報告資料
                        final userReport =
                            await RecordService.fetchReports(reminders[index].userId);

                        // 更新 UserProvider 的 user 資料
                        final userProvider = Provider.of<UserProvider>(context, listen: false);
                        final user = userProvider.user;
                        if (user != null) {
                          user.reports = userReport;
                          userProvider.setUserInfo(user);
                        }

                        // 重新載入 reminders 並刷新畫面
                        await loadReminders();

                        setState(() {}); // 強制刷新 UI
                      } else {
                        FrontUtil.showFail('刪除失敗，請稍後再試');
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  TextStyle _infoStyle() => const TextStyle(fontSize: 14, color: Color(0xFF589399), height: 1.5);

  String _formatTime(String timeStr) {
    final time = Reminder.parseTime(timeStr);
    return '${time.hour.toString().padLeft(2, '0')} ：${time.minute.toString().padLeft(2, '0')}';
  }

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

  void showConfirmDialog(BuildContext context, String title, String confirm, String cancel,
      VoidCallback onConfirm, List<Reminder> reminds) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF589399), width: 2),
        ),
        backgroundColor: Colors.white,
        title: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20, color: Color(0xFF589399), fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                backgroundColor: const Color(0xFF589399),
              ),
              onPressed: () async {
                RemindViewModel remind = RemindViewModel();
                final message = await remind.updateRemind(reminds);
                if (message) {
                  FrontUtil.showSuccess('儲存成功!');

                  final userReport = await RecordService.fetchReports(reminds[0].userId);
                  final userProvider = Provider.of<UserProvider>(context, listen: false);
                  final user = userProvider.user;
                  if (user != null) {
                    user.reports = userReport;
                    userProvider.setUserInfo(user);
                  }

                  if (mounted) {
                    Provider.of<ReportProvider>(context, listen: false).setReports(userReport);
                    final allReminds = userReport.expand((r) => r.reminds).toList();
                    Provider.of<RemindProvider>(context, listen: false).setReminds(allReminds);
                    onConfirm();
                    await loadReminders();
                  }

                  Navigator.pop(context);
                } else {
                  FrontUtil.showFail('儲存變更失敗，請稍後再試');
                }
              },
              child: Text(confirm,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                side: const BorderSide(width: 2, color: Color(0xFF589399)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(cancel,
                  style: const TextStyle(
                      color: Color(0xFF589399), fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
