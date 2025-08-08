import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/services/record_service.dart';
import 'package:drw/frontend/headers/header5.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowReportPage extends StatefulWidget {
  final UserReport report;
  const ShowReportPage({super.key, required this.report});

  @override
  State<ShowReportPage> createState() => _ShowReportPageState();
}

class _ShowReportPageState extends State<ShowReportPage> {
  late Map<String, List<String>> careSteps = {};
  late List<dynamic> tags = [];

  @override
  void initState() {
    super.initState();
    List<String> steps = widget.report.caremode.split(';');
    for (var step in steps) {
      if (step.trim().isEmpty) continue;
      List<String> parts = step.split(':');
      if (parts.length < 2) continue;
      String title = parts[0].trim();
      String contentText = parts[1].trim();
      List<String> lines = contentText.split('。').where((s) => s.trim().isNotEmpty).toList();
      careSteps[title] = lines;
    }
  }

  @override
  Widget build(BuildContext context) {
    RecordService recordService = RecordService();
    return Scaffold(
        backgroundColor: const Color(0xFFEBFEFF),
        body: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Header5(),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF589399),
                            width: 2,
                          ),
                        ),
                      ),
                      height: 55,
                      // padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF669FA5),
                            ),
                            padding: EdgeInsets.zero, // 移除 padding
                            constraints: const BoxConstraints(), // 移除預設大小
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 23),
                            child: Text(
                              widget.report.name,
                              style: const TextStyle(
                                color: Color(0xFF589399),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // 使用系統抓取的日期顯示
                          Text(
                            widget.report.date,
                            style: const TextStyle(
                              color: Color(0xFF589399),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Color(0xFF589399),
                        width: 2,
                      ))),
                      height: 230,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  widget.report.photo.toString(),
                                  height: 180,
                                  width: 180,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          // const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    48, 4, 48, 4), //對稱的內間距，讓Container與裡面的子元素的上下間距為n，左右間距為m
                                decoration: BoxDecoration(
                                  color: const Color(0xFF589399).withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "傷口類型",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Text(
                                widget.report.type,
                                style: const TextStyle(
                                  color: Color(0xFF589399),
                                  fontSize: 48,
                                ),
                              ),
                              SizedBox(
                                  width: 180,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: widget.report.oktime != '傷口已痊癒'
                                        ? [
                                            const Text(
                                              '預計',
                                              style: TextStyle(
                                                color: Color(0xFF589399),
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              widget.report.oktime,
                                              style: const TextStyle(
                                                color: Color(0xFF589399),
                                                fontSize: 26,
                                              ),
                                            ),
                                            const Text(
                                              '癒合',
                                              style: TextStyle(
                                                color: Color(0xFF589399),
                                                fontSize: 16,
                                              ),
                                            ),
                                          ]
                                        : [
                                            const Text(
                                              '傷口已痊癒',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 26,
                                              ),
                                            ),
                                          ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildCareSteps(careSteps),
                    // ..._buildAllWoundSections(careSteps),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '自我紀錄',
                          style: TextStyle(color: FrontUtil.textColor, fontSize: 20, height: 3),
                        ),
                        (widget.report.choosekind != '' || widget.report.recording != '')
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.report.choosekind != '')
                                    Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        Text(
                                          '標籤：${widget.report.choosekind}',
                                          style: TextStyle(
                                            color: FrontUtil.textColor,
                                            fontSize: 16,
                                            height: 2,
                                          ),
                                        )
                                      ],
                                    ),
                                  if (widget.report.recording != '')
                                    Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        Text(
                                          '描述：${widget.report.recording}',
                                          style: TextStyle(
                                            color: FrontUtil.textColor,
                                            fontSize: 16,
                                            height: 2,
                                          ),
                                        )
                                      ],
                                    ),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ],
                              )
                            : Column(
                                children: [
                                  Center(
                                    child: Text(
                                      '未填寫',
                                      style: TextStyle(
                                        color: FrontUtil.textColor,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ],
                              )
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          FrontUtil.showConfirmDialog(context, const Color(0xFFFF6262),
                              '此傷口已經癒合了嗎?', '※『是的』將會關閉傷口的後續追蹤', '還沒', '是的', () async {
                            widget.report.groupId == 0
                                ? await recordService.updateOktime(
                                    userId: widget.report.userId.toString(),
                                    oktime: '傷口已痊癒',
                                    recordId: widget.report.id.toString(),
                                  )
                                : await recordService.updateOktime(
                                    userId: widget.report.userId.toString(),
                                    oktime: '傷口已痊癒',
                                    recordId: widget.report.id.toString(),
                                    groupId: widget.report.groupId.toString());
                            final userReport =
                                await RecordService.fetchReports(widget.report.userId);
                            final userProvider = Provider.of<UserProvider>(context, listen: false);
                            final user = userProvider.user;
                            if (user != null) {
                              user.reports = userReport;

                              userProvider.setUserInfo(user);
                            }
                            if (mounted) {
                              Provider.of<ReportProvider>(context, listen: false)
                                  .setReports(userReport);
                              debugPrint(userReport.reversed.first.oktime);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFF589399),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          '傷口已痊癒?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  Widget _buildCareSteps(Map<String, List<String>> careSteps) {
    return Row(
      children: [
        Expanded(
          // 讓 Column 占滿 Row 的空間
          child: Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF589399), width: 2))),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '傷口護理建議',
                        style: TextStyle(
                          height: 3,
                          color: Color(0xFF589399),
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // report.toggleSwitch();
                            },
                            icon: const Icon(
                              Icons.compare_arrows,
                              color: Color(0xFF589399),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // final reference = report.getReference(widget.isExtra);
                              // FrontUtil.showReference(context, reference);
                            },
                            icon: const Icon(
                              Icons.link,
                              color: Color(0xFF589399),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // report.toggleNotify();
                              // if (report.notify) {
                              //   FrontUtil.showRemindDialog(context, report);
                              // }
                            },
                            icon: const Icon(
                              Icons.notifications_off_sharp,
                              color: Color(0xFF589399),
                            ),
                            // icon: report.notify
                            //     ? const Icon(
                            //         Icons.notifications_active,
                            //         color: Colors.red,
                            //       )
                            //     : const Icon(
                            //         Icons.notifications_off_sharp,
                            //         color: Color(0xFF589399),
                            //       ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ..._buildAllWoundSections(careSteps),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAllWoundSections(Map<String, List<String>> steps) {
    return steps.entries.map((entry) {
      final title = entry.key;
      final details = entry.value;
      return _buildWoundSection(title, details);
    }).toList();
  }

  Widget _buildWoundSection(String title, List<String> contents) {
    bool show = false;
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4D000000),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    setState(() => show = !show);
                  },
                  icon: Icon(show ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ),
              ],
            ),
          ),
          if (show)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contents
                    .map((line) => Text('• ${line.replaceAll(RegExp(r'\s+'), '')}'))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
