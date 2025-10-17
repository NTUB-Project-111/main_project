import 'package:carousel_slider/carousel_slider.dart';
import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/backend/viewmodels/report_view_model.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarePart extends StatefulWidget {
  final bool isExtra;
  const CarePart({super.key, required this.isExtra});

  @override
  State<CarePart> createState() => _CarePartState();
}

class _CarePartState extends State<CarePart> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF589399), width: 2)),
      ),
      child: Consumer<Report>(
        builder: (context, report, child) {
          return Column(
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
                          report.toggleSwitch();
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
                          final reference = report.getReference(widget.isExtra);
                          FrontUtil.showReference(context, reference);
                        },
                        icon: const Icon(
                          Icons.content_paste_search_rounded,
                          color: Color(0xFF589399),
                        ),
                      ),
                      const SizedBox(width: 2),
                      user!.id == -1 || widget.isExtra
                          ? const SizedBox()
                          : IconButton(
                              onPressed: () {
                                report.toggleNotify();
                                if (report.notify) {
                                  FrontUtil.showRemindDialog(context, report);
                                }
                              },
                              icon: report.notify
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
                // 護理步驟動畫
                if (report.isSwitch)
                  SizedBox(
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
                                  _carouselController.previousPage(); // 用 controller 控制
                                }
                              },
                            ),
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: CarouselSlider.builder(
                                carouselController: _carouselController, // 加上 controller
                                itemCount: report.imageUrls.length,
                                itemBuilder: (context, index, realIndex) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      report.imageUrls[index],
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
                              icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF589399)),
                              onPressed: () {
                                if (currentIndex < report.imageUrls.length - 1) {
                                  _carouselController.nextPage(); // 用 controller 控制
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          report.steps.isNotEmpty
                              ? report.steps[currentIndex]
                              : "步驟 ${currentIndex + 1}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF589399)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
              
                else
                  ..._buildAllWoundSections(report.careSteps),
              ]
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildAllWoundSections(Map<String, List<String>> steps) {
    final widgets = steps.entries.map((entry) {
      return _buildWoundSection(entry.key, entry.value);
    }).toList();

    // 在最後一個卡片下方加空間
    widgets.add(const SizedBox(height: 16)); // 想要多高就改這裡

    return widgets;
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
}
