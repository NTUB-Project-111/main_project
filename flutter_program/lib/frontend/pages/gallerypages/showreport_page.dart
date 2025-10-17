import 'package:carousel_slider/carousel_slider.dart';
import 'package:drw/backend/models/remind.dart';
import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/viewmodels/report_view_model.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/services/record_service.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/utility/notifier_util.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowReportPage extends StatefulWidget {
  final UserReport report;
  final bool isExtra;
  const ShowReportPage({super.key, required this.report, required this.isExtra});

  @override
  State<ShowReportPage> createState() => _ShowReportPageState();
}

class _ShowReportPageState extends State<ShowReportPage> {
  late Map<String, List<String>> careSteps = {};
  late List<dynamic> tags = [];
  bool isNotify = false;
  bool isSwitch = false;
  bool isNotifyChange = false;
  UserRemind? remind;
  Report userReport = Report();
  bool isOktimeChange = false;
  RecordService recordService = RecordService();
  bool isSaving = false;
  bool success = true;
  Notifier notifier = Notifier();
  final CarouselSliderController _carouselController = CarouselSliderController();
  int currentIndex = 0;
  List<String> imageUrls = [];
  List<String> imageSteps = [];
  @override
  void initState() {
    super.initState();
    isSaving = false;
    if (widget.report.ifcall == 'Y') {
      isNotify = true;
    }
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
    if (widget.isExtra) {
      switch (widget.report.type) {
        case '燒傷':
        case '燙傷':
          imageUrls = [
            'images/burncare1.png',
            'images/burncare2.png',
            'images/burncare3.png',
            'images/burncare4.png',
            'images/burncare5.png',
            'images/burncare6.png',
            'images/burncare7.png'
          ];
          imageSteps = ['洗手', '移除舊紗布', '觀察傷口', '清潔傷口', '擦乾傷口', '擦藥', '包紮傷口'];
          break;
        case '擦傷':
        case '割傷':
        case '刺傷':
          imageUrls = [
            'images/woundcare1.png',
            'images/woundcare2.png',
            'images/woundcare3.png',
            'images/woundcare4.png',
            'images/woundcare5.png'
          ];
          imageSteps = ['洗淨雙手', '拆除舊敷料', '擦拭傷口', '塗抹藥膏', '包紮傷口'];
          break;
        case '瘀青':
          imageUrls = [
            'images/bruise1.jpg',
            'images/bruise2.jpg',
            'images/bruise3.jpg',
            'images/bruise4.jpg',
            'images/bruise5.jpg'
          ];
          imageSteps = ['初期冷敷', '後期熱敷', '避免加壓或按摩', '抬高患肢', '若瘀傷部位出現腫脹'];
          break;
        case '手術傷口':
          imageUrls = [
            'images/surgical1.png',
            'images/surgical2.png',
            'images/surgical3.png',
            'images/surgical4.png',
            'images/surgical5.png',
            'images/surgical1.png',
          ];
          imageSteps = ['清潔雙手', '檢查傷口', '清潔傷口', '消毒傷口', '包紮傷口', '再次洗手'];
          break;
        case '嚴重傷口':
          imageUrls = [
            'images/serious1.png',
            'images/serious2.png',
            'images/serious3.png',
            'images/serious4.png',
            'images/serious5.png',
          ];
          imageSteps = ['盡快送醫', '立刻加壓止血', '抬高患部', '避免進食與飲水', '保持溫暖、防休克'];
          break;
        default:
          imageUrls = [];
      }
    } else {
      switch (widget.report.type) {
        case '燒傷':
        case '燙傷':
          imageUrls = [
            'images/burn1.png',
            'images/burn2.png',
            'images/burn3.png',
            'images/burn4.png',
            'images/burn5.png'
          ];
          imageSteps = ['沖洗燒燙傷部位', '脫掉衣物飾品', '浸泡傷部', '塗抹乳液', '包紮傷口', '服用止痛藥(如有需要)'];
          break;
        case '擦傷':
          imageUrls = [
            'images/abrasion1.png',
            'images/abrasion2.png',
            'images/abrasion3.png',
            'images/abrasion4.png'
          ];
          imageSteps = ['洗淨雙手', '清潔傷口', '擦藥', '包紮傷口'];
          break;
        case '割傷':
          imageUrls = [
            'images/cut1.png',
            'images/cut2.png',
            'images/cut3.png',
            'images/cut4.png',
            'images/cut5.png'
          ];
          imageSteps = ['洗手', '止血', '清潔傷口', '塗抹藥膏', '包紮傷口'];
          break;
        case '刺傷':
          imageUrls = [
            'images/stab1.png',
            'images/stab2.png',
            'images/stab3.png',
            'images/stab4.png',
            'images/stab5.png'
          ];
          imageSteps = ['洗手', '止血', '清潔傷口', '塗抹藥膏', '覆蓋傷口'];
          break;
        case '瘀青':
          imageUrls = [
            'images/bruise1.jpg',
            'images/bruise2.jpg',
            'images/bruise3.jpg',
            'images/bruise4.jpg',
            'images/bruise5.jpg'
          ];
          imageSteps = ['初期冷敷', '後期熱敷', '避免加壓或按摩', '抬高患肢', '若瘀傷部位出現腫脹'];
          break;
        case '手術傷口':
          imageUrls = [
            'images/surgical1.png',
            'images/surgical2.png',
            'images/surgical3.png',
            'images/surgical4.png',
            'images/surgical5.png',
            'images/surgical1.png',
          ];
          imageSteps = ['清潔雙手', '檢查傷口', '清潔傷口', '消毒傷口', '包紮傷口', '再次洗手'];
          break;
        case '嚴重傷口':
          imageUrls = [
            'images/serious1.png',
            'images/serious2.png',
            'images/serious3.png',
            'images/serious4.png',
            'images/serious5.png',
          ];
          imageSteps = ['盡快送醫', '立刻加壓止血', '抬高患部', '避免進食與飲水', '保持溫暖、防休克'];
          break;
        default:
          imageUrls = [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    RecordService recordService = RecordService();

    return Scaffold(
        backgroundColor: const Color(0xFFEBFEFF),
        body: isSaving
            ? Center(child: FrontUtil.loading())
            : Column(children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Header5(),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
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
                                  onPressed: () async {
                                    if (isNotifyChange) {
                                      FrontUtil.showTextDialog(
                                        context,
                                        '確定要儲存修改嗎?',
                                        '確定',
                                        '取消',
                                        onConfirm: () async {
                                          setState(() {
                                            isSaving = true;
                                          });
                                          bool success = false;
                                          try {
                                            if (isNotify) {
                                              // 先新增提醒，再更新 ifcall
                                              final s1 = await userReport
                                                  .addRemind(widget.report.userId.toString());
                                              final s2 = await recordService.updateIfcall(
                                                userId: widget.report.userId,
                                                recordId: widget.report.id,
                                                ifcall: 'Y',
                                              );
                                              success = s1 && s2;
                                              if (success) {
                                                final updatedReport =
                                                    widget.report.copyWith(ifcall: 'Y');
                                                context
                                                    .read<ReportProvider>()
                                                    .updateReport(updatedReport);
                                              }
                                            } else {
                                              // 關閉提醒
                                              success = await recordService.updateIfcall(
                                                userId: widget.report.userId,
                                                recordId: widget.report.id,
                                                ifcall: 'N',
                                              );
                                              if (success) {
                                                final updatedReport =
                                                    widget.report.copyWith(ifcall: 'N');
                                                context
                                                    .read<ReportProvider>()
                                                    .updateReport(updatedReport);
                                              }
                                            }
                                            // 更新通知排程
                                            notifier.setRemind(context);
                                          } catch (e) {
                                            success = false;
                                            debugPrint('提醒修改發生錯誤: $e');
                                          } finally {
                                            setState(() {
                                              isSaving = false;
                                            });
                                            Navigator.pop(context); // 關閉對話框
                                            if (success) {
                                              FrontUtil.showSuccess('提醒修改成功!');
                                            } else {
                                              FrontUtil.showFail('提醒修改失敗');
                                            }
                                          }
                                        },
                                      );
                                    } else {
                                      Navigator.pop(context);
                                    }
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
                                        height: 250,
                                        width: 175,
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
                                        fontSize: 40,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: isOktimeChange
                                            ? [
                                                const Text(
                                                  '傷口已痊癒',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 20,
                                                  ),
                                                )
                                              ]
                                            : widget.report.oktime != '傷口已痊癒'
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
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _buildCareSteps(careSteps, widget.report, remind, userReport),
                          // ..._buildAllWoundSections(careSteps),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '自我紀錄',
                                style:
                                    TextStyle(color: FrontUtil.textColor, fontSize: 20, height: 3),
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
                          widget.report.oktime == '傷口已痊癒' || isOktimeChange
                              ? const SizedBox()
                              : SizedBox(
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
                                                ifcall: 'N')
                                            : await recordService.updateOktime(
                                                userId: widget.report.userId.toString(),
                                                oktime: '傷口已痊癒',
                                                recordId: widget.report.id.toString(),
                                                groupId: widget.report.groupId.toString(),
                                                ifcall: 'N');
                                        setState(() {
                                          isOktimeChange = true;
                                          isNotify = false;
                                        });
                                        final userReport =
                                            await RecordService.fetchReports(widget.report.userId);
                                        final userProvider =
                                            Provider.of<UserProvider>(context, listen: false);
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
                                        notifier.setRemind(context);
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

  Widget _buildCareSteps(Map<String, List<String>> careSteps, UserReport report, UserRemind? remind,
      Report userReport) {
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
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                isSwitch = !isSwitch;
                              });
                            },
                            icon: const Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  FluentIcons.cube_24_regular,
                                  color: Color(0xFF589399),
                                  size: 13,
                                ),
                                Icon(
                                  FluentIcons.arrow_sync_20_regular,
                                  color: Color(0xFF589399),
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 2),
                          IconButton(
                            onPressed: () {
                              final reference = getReference(widget.isExtra, widget.report.type);
                              FrontUtil.showReference(context, reference);
                            },
                            icon: const Icon(
                              Icons.content_paste_search_rounded,
                              color: Color(0xFF589399),
                            ),
                          ),
                          const SizedBox(width: 2),
                          widget.isExtra
                              ? const SizedBox()
                              : IconButton(
                                  onPressed: () {
                                    if (!isNotify) {
                                      userReport.recordId = widget.report.id;
                                      userReport.date = widget.report.date;
                                      userReport.oktime = widget.report.oktime;
                                      final reminds = widget.report.reminds;
                                      for (var r in reminds) {
                                        if (r.recordId == userReport.recordId) {
                                          final remind = r;
                                          userReport.remindFreq = remind.freq;
                                          userReport.remindTime = remind.time;

                                          break;
                                        }
                                      }
                                      FrontUtil.showRemindDialog(context, userReport);
                                      // showRemindDialog(context, report, remind);
                                    }
                                    setState(() {
                                      isNotifyChange = true;
                                      isNotify = !isNotify;
                                    });
                                  },
                                  icon: widget.report.oktime == '傷口已痊癒' || isOktimeChange
                                      ? const SizedBox()
                                      : isNotify
                                          ? const Icon(
                                              Icons.notifications_active,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.notifications_off_sharp,
                                              color: Color(0xFF589399),
                                            )),
                        ],
                      ),
                    ],
                  ),
                  ...[
                    if (isSwitch)
                      SizedBox(
                        width: double.infinity,
                        height: 320,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 左箭頭
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF589399)),
                                  onPressed: () {
                                    if (currentIndex > 0) {
                                      _carouselController.previousPage();
                                      currentIndex = currentIndex - 1; // 用 controller 控制
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 250,
                                  height: 250,
                                  child: CarouselSlider.builder(
                                    carouselController: _carouselController, // 加上 controller
                                    itemCount: imageUrls.length,
                                    itemBuilder: (context, index, realIndex) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          imageUrls[index],
                                          fit: BoxFit.cover,
                                          width: 250,
                                          height: 250,
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      viewportFraction: 1.0,
                                      enableInfiniteScroll: false,
                                      height: 250,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          currentIndex = index;
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                // 右箭頭
                                IconButton(
                                  icon:
                                      const Icon(Icons.arrow_forward_ios, color: Color(0xFF589399)),
                                  onPressed: () {
                                    if (currentIndex < imageUrls.length - 1) {
                                      _carouselController.nextPage();
                                      currentIndex = currentIndex + 1; // 用 controller 控制
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              imageSteps.isNotEmpty ? imageSteps[currentIndex] : "步驟 ${currentIndex + 1}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF589399)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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
                    .map(
                      (line) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '•',
                              style: TextStyle(
                                color: Color(0xFF589399),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 6), // bullet 與文字間距
                            Expanded(
                              child: Text(
                                line.replaceAll(RegExp(r'\s+'), ''),
                                style: const TextStyle(
                                  color: Color(0xFF589399),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
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
