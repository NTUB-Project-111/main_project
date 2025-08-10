import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:drw/backend/models/remind.dart';
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
  bool isNotify = false;
  bool isSwitch = false;
  UserRemind? remind;
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
    for (var r in widget.report.reminds) {
      if (r.recordId == widget.report.id) {
        remind = r;
        break;
      }
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
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildCareSteps(careSteps, widget.report, remind),
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
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  // void showRemindDialog(BuildContext context, UserReport report, UserRemind? remind) {
  //   String freq = remind.freq;
  //   String time = remind.time;
  //   // 將選擇的時間初始值設定在對話框外層，讓其狀態能夠在對話框內更新
  //   showDialog(
  //     barrierDismissible: false, // 禁止點擊外部區域關閉對話框
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter dialogSetState) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //               side: const BorderSide(
  //                 color: Color(0xFF589399),
  //                 width: 2,
  //               ),
  //             ),
  //             backgroundColor: Colors.white,
  //             title: const Text(
  //               '換藥提醒',
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 color: Color(0xFF589399),
  //                 fontWeight: FontWeight.w700,
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 20),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Text(
  //                         "提醒頻率",
  //                         style: TextStyle(
  //                           height: 3,
  //                           fontSize: 16,
  //                           color: Color(0xFF589399),
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                       ),
  //                       DropdownButtonHideUnderline(
  //                         child: DropdownButton2<String>(
  //                           alignment: Alignment.center,
  //                           isExpanded: true,
  //                           hint: const Text(
  //                             '----- 請選擇 -----',
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w100,
  //                               fontSize: 12,
  //                               color: Color(0xFFAEAEAE),
  //                             ),
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                           items: ["每天", "兩天一次", "三天一次", "每週"]
  //                               .map((String item) => DropdownMenuItem<String>(
  //                                     value: item,
  //                                     child: Text(
  //                                       item,
  //                                       textAlign: TextAlign.center,
  //                                       style: const TextStyle(
  //                                         fontWeight: FontWeight.w100,
  //                                         fontSize: 14,
  //                                         color: Color.fromRGBO(88, 147, 153, 1),
  //                                       ),
  //                                       overflow: TextOverflow.ellipsis,
  //                                     ),
  //                                   ))
  //                               .toList(),
  //                           value: freq,
  //                           onChanged: (String? value) {
  //                             // 用 dialogSetState 更新對話框內 UI
  //                             dialogSetState(() {
  //                               freq = value!;
  //                             });
  //                           },
  //                           buttonStyleData: ButtonStyleData(
  //                             padding: const EdgeInsets.symmetric(horizontal: 14),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(15),
  //                               border: Border.all(
  //                                 color: const Color.fromRGBO(154, 201, 205, 1),
  //                               ),
  //                               color: Colors.white,
  //                             ),
  //                             elevation: 0,
  //                           ),
  //                           iconStyleData: const IconStyleData(
  //                             icon: Icon(
  //                               Icons.arrow_drop_down_rounded,
  //                             ),
  //                             iconSize: 30,
  //                             iconEnabledColor: Color.fromRGBO(88, 147, 153, 1),
  //                           ),
  //                           dropdownStyleData: DropdownStyleData(
  //                             elevation: 0,
  //                             maxHeight: 200,
  //                             decoration: BoxDecoration(
  //                               border: Border.all(
  //                                 color: const Color.fromRGBO(154, 201, 205, 1),
  //                               ),
  //                               borderRadius: BorderRadius.circular(14),
  //                               color: Colors.white,
  //                             ),
  //                             scrollbarTheme: ScrollbarThemeData(
  //                               radius: const Radius.circular(40),
  //                               thickness: WidgetStateProperty.all(6),
  //                               thumbVisibility: WidgetStateProperty.all(true),
  //                             ),
  //                           ),
  //                           menuItemStyleData: const MenuItemStyleData(
  //                             height: 33,
  //                             padding: EdgeInsets.only(left: 25, right: 14),
  //                           ),
  //                         ),
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           const Text(
  //                             "提醒時間",
  //                             style: TextStyle(
  //                               height: 3,
  //                               fontSize: 16,
  //                               color: Color(0xFF589399),
  //                               fontWeight: FontWeight.w700,
  //                             ),
  //                           ),
  //                           Text(
  //                             time,
  //                             style: const TextStyle(
  //                               height: 3,
  //                               fontSize: 16,
  //                               color: Color(0xFF589399),
  //                               fontWeight: FontWeight.w700,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Theme(
  //                         data: Theme.of(context).copyWith(
  //                           colorScheme: const ColorScheme.light(
  //                             primary: Color.fromARGB(255, 176, 215, 219),
  //                             onPrimary: Colors.white,
  //                             onSurface: Color.fromARGB(255, 125, 173, 178),
  //                           ),
  //                           timePickerTheme: TimePickerThemeData(
  //                               //時間選擇器 顏色設定
  //                               backgroundColor: const Color(0xFFF7FCFD),
  //                               dialHandColor: const Color(0xFF589399),
  //                               dialTextColor:
  //                                   WidgetStateColor.resolveWith((Set<WidgetState> states) {
  //                                 if (states.contains(WidgetState.selected)) {
  //                                   return const Color.fromARGB(255, 255, 255, 255); // 選中狀態下的數字
  //                                 }
  //                                 return const Color(0xFF2E6D74); // 未選中狀態下的數字
  //                               }),
  //                               // dialTextColor: const Color(0xFF2E6D74),
  //                               dialBackgroundColor: Colors.white,
  //                               // hourMinuteColor: const Color(0xFFBBD3D6),
  //                               hourMinuteTextColor: const Color(0xFF164449),
  //                               hourMinuteShape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 side: const BorderSide(color: Color(0xFF589399), width: 2),
  //                               ),
  //                               dayPeriodColor: WidgetStateColor.resolveWith(
  //                                 (states) => const Color(0xFF589399),
  //                               ),
  //                               dayPeriodTextColor: Colors.white,
  //                               // ... 其他可設定的屬性
  //                               confirmButtonStyle: ButtonStyle(
  //                                 textStyle: WidgetStateProperty.all<TextStyle>(
  //                                   const TextStyle(fontWeight: FontWeight.bold), // 設定字體寬度
  //                                 ),
  //                                 foregroundColor:
  //                                     WidgetStateProperty.all<Color>(const Color(0xFF589399)),
  //                               ),
  //                               helpTextStyle: const TextStyle(color: Color(0xFF589399)),
  //                               cancelButtonStyle: ButtonStyle(
  //                                 foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
  //                               )),
  //                           textButtonTheme: TextButtonThemeData(
  //                             style: TextButton.styleFrom(
  //                               foregroundColor: FrontUtil.bkColor,
  //                             ),
  //                           ),
  //                         ),
  //                         child: Builder(
  //                           builder: (context) => OutlinedButton(
  //                             style: OutlinedButton.styleFrom(
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(15.0), // 調整圓角半徑
  //                               ),
  //                               padding: const EdgeInsets.symmetric(horizontal: 70),
  //                               side: const BorderSide(
  //                                 width: 1,
  //                                 color: Color.fromRGBO(154, 201, 205, 1),
  //                               ),
  //                             ),
  //                             onPressed: () async {
  //                               final result = await showTimePicker(
  //                                   context: context,
  //                                   initialTime: TimeOfDay.now(),
  //                                   initialEntryMode: TimePickerEntryMode.dial, // dial 或 input
  //                                   helpText: "選擇時間",
  //                                   confirmText: "確定",
  //                                   cancelText: "取消");
  //                               if (result != null) {
  //                                 dialogSetState(() {
  //                                   final selectedTime =
  //                                       "${result.hour.toString().padLeft(2, '0')}:${result.minute.toString().padLeft(2, '0')}";
  //                                   time = selectedTime;
  //                                 });
  //                               }
  //                               // ...
  //                             },
  //                             child: const Text(
  //                               '選擇時間',
  //                               style: TextStyle(
  //                                 color: Color.fromRGBO(88, 147, 153, 1),
  //                                 // fontSize: 15,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 15,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Row(
  //                   mainAxisSize: MainAxisSize.max,
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     OutlinedButton(
  //                       style: OutlinedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(15.0), // 調整圓角半徑
  //                         ),
  //                         padding: const EdgeInsets.symmetric(horizontal: 30),
  //                         side: const BorderSide(
  //                           width: 2,
  //                           color: Color(0xFF589399),
  //                         ),
  //                       ),
  //                       onPressed: () {
  //                         setState(() {
  //                           isNotify = !isNotify;
  //                         });
  //                         Navigator.pop(context); // 關閉對話框
  //                       },
  //                       child: const Text(
  //                         '取消',
  //                         style: TextStyle(
  //                           color: Color(0xFF589399),
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                       ),
  //                     ),
  //                     OutlinedButton(
  //                       style: OutlinedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(15.0), // 調整圓角半徑
  //                         ),
  //                         padding: const EdgeInsets.symmetric(horizontal: 30),
  //                         backgroundColor: const Color(0xFF589399),
  //                         side: BorderSide.none,
  //                       ),
  //                       onPressed: () {
  //                         debugPrint(freq);
  //                         debugPrint(time);
  //                         Navigator.pop(context); // 關閉對話框
  //                       },
  //                       child: const Text(
  //                         '確定',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const Text(
  //                   "※提醒頻率及時間皆可至小鈴鐺處進行修改※",
  //                   style: TextStyle(
  //                     height: 3,
  //                     fontSize: 12,
  //                     color: Color(0xFF589399),
  //                     // fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _buildCareSteps(
      Map<String, List<String>> careSteps, UserReport report, UserRemind? remind) {
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
                              setState(() {
                                isSwitch = !isSwitch;
                              });
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
                              if (!isNotify) {
                                // showRemindDialog(context, report, remind);
                              }
                              setState(() {
                                isNotify = !isNotify;
                              });
                            },
                            icon: isNotify
                                ? const Icon(
                                    Icons.notifications_active,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.notifications_off_sharp,
                                    color: Color(0xFF589399),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ...[
                    if (isSwitch)
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: FrontUtil.textColor,
                                  )),
                              Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, bottom: 15, left: 5, right: 5),
                                  height: 280,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: FrontUtil.textColor,
                                  )),
                            ],
                          ),
                          Text(
                            '測試',
                            style:
                                TextStyle(color: FrontUtil.textColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      )
                    else
                      ..._buildAllWoundSections(careSteps),
                  ]
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

  List<String> getReference(bool isExtra, String woundType) {
    List<String> reference = [];
    if (isExtra) {
      switch (woundType) {
        case '燒傷':
        case '燙傷':
          reference = [
            'https://www.weigong.org.tw/HealthEdus/Detail?no=133',
            'https://yl.cch.org.tw/upload/knowledge/251/2024%E5%B9%B412%E6%9C%8859560-P-C-050-03%E7%87%99%E7%87%92%E5%82%B7%E5%8F%A3%E8%AD%B7%E7%90%86%E9%A0%88%E7%9F%A5_6564428.pdf',
            'https://ihealth.vghtpe.gov.tw/media/345'
          ];
          break;
        case '擦傷':
        case '割傷':
        case '刺傷':
          reference = [
            'https://www.kentcht.nhs.uk/leaflet/changing-your-wound-dressing/',
            'https://patient.uwhealth.org/healthfacts/6820'
          ];
          break;
        case '瘀青':
          reference = [
            'https://www.stanfordchildrens.org/en/topic/default?id=bruises-90-P02795',
            'https://my.clevelandclinic.org/health/diseases/15235-bruises',
            'https://www.mayoclinic.org/first-aid/first-aid-bruise/basics/art-20056663'
          ];
          break;
        case '手術傷口':
          reference = [
            'https://ihealth.vghtc.gov.tw/media/886',
            'https://www.chimei.org.tw/main/cmh_department/59012/info/7510/A7510213.html',
            'https://www1.cgmh.org.tw/intr/intr4/c8270/Sports%20Medicine%20Center_health/00383-20220806-140132.pdf'
          ];
          break;
        default:
          reference = [];
      }
    } else {
      switch (woundType) {
        case '燒傷':
        case '燙傷':
          reference = [
            'https://www.nhs.uk/conditions/burns-and-scalds/',
            'https://www.mayoclinic.org/first-aid/first-aid-burns/basics/art-20056649',
            'https://www.auh.org.tw/NewsInfo/HealthEducationInfo?docid=1241'
          ];
          break;
        case '擦傷':
          reference = [
            'https://www.stanfordchildrens.org/en/topic/default?id=abrasions-90-P02789',
            'https://newsnetwork.mayoclinic.org/discussion/treating-skin-abrasions-known-as-raspberries/',
            'https://intermountainhealthcare.org/blogs/4-steps-to-treat-abrasions-at-home'
          ];
          break;
        case '割傷':
          reference = [
            'https://www.nhs.uk/conditions/cuts-and-grazes/',
            'https://www.mayoclinic.org/zh-hans/first-aid/first-aid-cuts/basics/art-20056711',
            'https://www.stanfordchildrens.org/en/topic/default?id=taking-care-of-cuts-and-scrapes-1-2978'
          ];
          break;
        case '刺傷':
          reference = [
            'https://www.mayoclinic.org/first-aid/first-aid-puncture-wounds/basics/art-20056665',
            'https://www.stanfordchildrens.org/en/topic/default?id=puncture-wounds-90-P02844',
            'https://medlineplus.gov/ency/article/000043.htm'
          ];
          break;
        case '瘀青':
          reference = [
            'https://www.stanfordchildrens.org/en/topic/default?id=bruises-90-P02795',
            'https://my.clevelandclinic.org/health/diseases/15235-bruises',
            'https://www.mayoclinic.org/first-aid/first-aid-bruise/basics/art-20056663'
          ];
          break;
        case '手術傷口':
          reference = [
            'https://ihealth.vghtc.gov.tw/media/886',
            'https://www.chimei.org.tw/main/cmh_department/59012/info/7510/A7510213.html',
            'https://www1.cgmh.org.tw/intr/intr4/c8270/Sports%20Medicine%20Center_health/00383-20220806-140132.pdf'
          ];
          break;
        default:
          reference = [];
      }
    }
    return reference;
  }
}
