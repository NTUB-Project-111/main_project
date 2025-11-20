// import 'package:drw/backend/models/report.dart';
// import 'package:drw/backend/models/user.dart';
import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/services/record_service.dart';
import 'package:drw/backend/viewmodels/report_view_model.dart';
import 'package:drw/backend/provider/remind_provider.dart';
import 'package:drw/backend/provider/report_provider.dart';
// import 'package:drw/backend/provider/user_provider.dart';
// import 'package:drw/backend/services/record_service.dart';
import 'package:drw/frontend/pages/tabs/tabs.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/utility/notifier_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonPart extends StatefulWidget {
  final bool isExtra;
  final int? id;
  final UserReport? report;
  const ButtonPart({super.key, required this.isExtra, this.id, this.report});

  @override
  State<ButtonPart> createState() => _ButtonPartState();
}

class _ButtonPartState extends State<ButtonPart> {
  Notifier notifier = Notifier();
  bool isSaving = false;
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    final remindProvider = Provider.of<RemindProvider>(context, listen: false);
    final reminds = remindProvider.reminds;
    return Consumer<Report>(
      builder: (context, report, _) {
        return Container(
          margin: const EdgeInsets.only(top: 15, bottom: 25),
          child: report.woundType != "無異常"
              ? Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Tabs(
                                        currentIndex: 0,
                                      )));
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
                        onPressed: isSaving
                            ? null
                            : () async {
                                setState(() {
                                  isSaving = true;
                                });
                                final result = await report.uploadData(report.userId.toString(),
                                    widget.isExtra, widget.id ?? 0, widget.report);
                                if (result) {
                                  if (reminds.isNotEmpty) {
                                    reportProvider
                                        .addReport(report.toUserReport(reminds.last.id + 1));
                                    // if (widget.isExtra) {
                                    //   context.read<ReportProvider>().updateReportGroup(
                                    //       widget.report!.id, resultMap['newGroupId']);
                                    // }
                                  } else {
                                    reportProvider.addReport(report.toUserReport(1));
                                  }
                                  final userReports =
                                      await RecordService.fetchReports(report.userId);
                                  remindProvider.addReminds(report.reminds);
                                  Provider.of<ReportProvider>(context, listen: false)
                                      .setReports(userReports);
                                  // notifier.scheduleReminders(remindProvider.reminds);
                                  // notifier.getAllReminders();
                                  FrontUtil.showSuccess('報告儲存成功!');
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => const Tabs(currentIndex: 0)),
                                    (route) => false,
                                  );
                                  // report.clearAll();
                                  // debugPrint('舊報告groupID${widget.report!.groupId.toString()}');
                                  // debugPrint('新報告groupID${report.groupId.toString()}');
                                } else {
                                  FrontUtil.showFail('報告儲存失敗');
                                }

                                setState(() {
                                  isSaving = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: isSaving ? Colors.grey : const Color(0xFF589399),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isSaving ? '儲存中...' : '儲存報告',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        // onPressed: report.isSaving
                        //     ? null
                        //     : () async {

                        //         final userProvider =
                        //             Provider.of<UserProvider>(context, listen: false);
                        //         final user = userProvider.user;
                        //         if (user == null) return;
                        //         final result = await report.uploadData(
                        //             user.id.toString(), widget.isExtra, widget.id ?? 0);
                        //         if (result) {
                        //           // 重新取得該使用者所有報告資料
                        //           final userReports = await RecordService.fetchReports(user.id);
                        //           // 更新 user 物件裡的 reports，並更新 userProvider
                        //           user.reports = userReports;
                        //           userProvider.setUserInfo(user);
                        //           if (mounted) {
                        //             // 更新 ReportProvider
                        //             Provider.of<ReportProvider>(context, listen: false)
                        //                 .setReports(userReports);
                        //             // 將所有提醒整合出來並更新 RemindProvider
                        //             final allReminds =
                        //                 userReports.expand((r) => r.reminds).toList();
                        //             Provider.of<RemindProvider>(context, listen: false)
                        //                 .setReminds(allReminds);
                        //             notifier.scheduleReminders(allReminds);
                        //             notifier.getAllReminders();
                        //           }
                        //           // 可能額外需要觸發資料儲存/紀錄刷新
                        //           await RecordService.getRecords(context, user.id.toString());

                        //           // 顯示成功訊息並跳頁
                        //           FrontUtil.showSuccess('報告儲存成功!');
                        //           // Navigator.pushReplacement(
                        //           //   context,
                        //           //   MaterialPageRoute(builder: (_) => const Tabs(currentIndex: 0)),
                        //           // );
                        //           Navigator.of(context).pushAndRemoveUntil(
                        //             MaterialPageRoute(builder: (_) => const Tabs(currentIndex: 0)),
                        //             (route) => false,
                        //           );
                        //         } else {
                        //           FrontUtil.showFail('報告儲存失敗');
                        //         }
                        //       },
                        // style: ElevatedButton.styleFrom(
                        //   padding: const EdgeInsets.symmetric(vertical: 12),
                        //   backgroundColor: report.isSaving ? Colors.grey : const Color(0xFF589399),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        // ),
                        // child: Text(
                        //   report.isSaving ? '儲存中...' : '儲存報告',
                        //   style: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 16,
                        //   ),
                        // ),
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
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Tabs(
                                        currentIndex: 0,
                                      )));
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
      },
    );
  }
}
