// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/backend/provider/family_provider.dart';
import 'package:drw/backend/provider/remind_provider.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/backend/viewmodels/family_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemindPart extends StatefulWidget {
  final int? selectedMember;
  final String? selectedRole;
  const RemindPart({super.key, this.selectedMember, this.selectedRole});

  @override
  State<RemindPart> createState() => _WoundRemindPageState();
}

class _WoundRemindPageState extends State<RemindPart> {
  // 模擬今日換藥的資料
  // List<Map<String, dynamic>> reminders = [];
  // List<Map<String, dynamic>> recommended = [];

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final remindProvider = context.watch<RemindProvider>();
    final familyProvider = context.watch<FamilyProvider>();
    final reportProvider = context.watch<ReportProvider>();

    // reminders.clear();
    // recommended.clear();
    // List reminders = [];
    // List recommended = [];

    // if (widget.selectedMember == null) {
    //   for (var remind in remindProvider.reminds) {
    //     // final dateTime = DateTime.parse(remind.date);
    //     for (var member in familyProvider.members) {
    //       if (member.memberId == remind.memberId &&
    //           remind.date ==
    //               '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}') {
    //         reminders.add({"time": remind.time, "member": member.role, "done": false});
    //       }
    //     }
    //   }
    //   for (var report in reportProvider.reports) {
    //     if (report.ifcall == 'N') {
    //       final dateTime = DateTime.parse(report.date);
    //       String date = '${dateTime.month}/${dateTime.day}';
    //       recommended.add({"date": date, "image": report.photo});
    //     }
    //   }
    // } else {
    //   for (var remind in remindProvider.reminds) {
    //     if (widget.selectedMember == remind.memberId &&
    //         remind.date ==
    //             '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}') {
    //       reminders.add({"time": remind.time, "member": widget.selectedRole, "done": false});
    //     }
    //   }
    //   for (var report in reportProvider.reports) {
    //     if (report.ifcall == 'N' && report.memberId == widget.selectedMember) {
    //       final dateTime = DateTime.parse(report.date);
    //       String date = '${dateTime.month}/${dateTime.day}';
    //       recommended.add({"date": date, "image": report.photo});
    //     }
    //   }
    // }
    Family family = context.watch<Family>();
    family.setReminders(widget.selectedMember, widget.selectedRole, remindProvider.reminds,
        familyProvider.members, reportProvider.reports);
    int total = family.reminders.length;
    int doneCount = family.reminders.where((r) => r["done"]).length;

    // 設定每個 item 高度 + margin
    const double itemHeight = 73;
    const int maxVisibleItems = 5;
    final double listHeight =
        (family.reminders.length > maxVisibleItems ? maxVisibleItems : family.reminders.length) *
            itemHeight;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== 今日換藥區塊 =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "今日換藥",
                style: TextStyle(
                  color: Color(0xFF669FA5),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$doneCount / $total",
                style: const TextStyle(
                  color: Color(0xFF9FBABB),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 今日換藥列表（固定高度 + 可滑動）
          // 希望可以在點擊單個提醒時跳出對應的診斷報告
          Consumer<Family>(
            builder: (context, family, child) {
              return SizedBox(
                height: listHeight,
                child: ListView.builder(
                  itemCount: family.reminders.length,
                  itemBuilder: (context, index) {
                    // family.newReminders == [] ? final remind = family.newReminders[index] : final remind = family.reminders[index];
                    final source =
                        family.newReminders.isNotEmpty ? family.newReminders : family.reminders;

                    final remind = source[index];

                    debugPrint('==== ${family.reminders.toString()} ====');
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 18, color: Color(0xFF9FBABB)),
                              const SizedBox(width: 8),
                              Text("換藥時間：${remind["time"]}"),
                              const SizedBox(width: 20),
                              Text("家人：${remind["member"]}"),
                            ],
                          ),
                          Checkbox(
                            value: remind["done"],
                            activeColor: const Color(0xFF669FA5),
                            onChanged: (val) {
                              family.updateReminder(index, val!);
                              debugPrint(family.reminders.toString());
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),

          //  SizedBox(
          //       height: listHeight,
          //       child: ListView.builder(
          //         itemCount: family.reminders.length,
          //         itemBuilder: (context, index) {
          //           final remind = family.reminders[index];
          //           return Container(
          //             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          //             margin: const EdgeInsets.only(bottom: 6),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(10),
          //               boxShadow: const [
          //                 BoxShadow(
          //                   color: Colors.black12,
          //                   blurRadius: 3,
          //                   offset: Offset(0, 2),
          //                 ),
          //               ],
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Row(
          //                   children: [
          //                     const Icon(Icons.access_time, size: 18, color: Color(0xFF9FBABB)),
          //                     const SizedBox(width: 8),
          //                     Text("換藥時間：${remind["time"]}"),
          //                     const SizedBox(width: 20),
          //                     Text("家人：${remind["member"]}"),
          //                   ],
          //                 ),
          //                 Checkbox(
          //                   value: remind["done"],
          //                   activeColor: const Color(0xFF669FA5),
          //                   onChanged: (val) {
          //                     // setState(() => remind["done"] = val);
          //                     family.updateReminder(index, val!);
          //                   },
          //                 ),
          //               ],
          //             ),
          //           );
          //         },
          //       ),
          //     ),

          const SizedBox(height: 25),

          // ===== 推薦開啟提醒區塊 =====
          const Text(
            "建議開啟換藥提醒", //可以根據癒合時間的長短進行建議
            style: TextStyle(
              color: Color(0xFF669FA5),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: family.recommended.length,
              separatorBuilder: (_, __) => const SizedBox(width: 5),
              itemBuilder: (context, index) {
                return Container(
                  width: 110,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      family.recommended[index]["image"] == null
                          ? Container(
                              width: 100,
                              height: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8E6E6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          : Container(
                              width: 100,
                              height: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8E6E6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  family.recommended[index]["image"].toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      const SizedBox(height: 5),
                      Text(
                        "拍攝日：${family.recommended[index]["date"]}",
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
