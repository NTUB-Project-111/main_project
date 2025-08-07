import 'package:drw/backend/models/report_model.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarePart extends StatefulWidget {
  final bool isExtra;
  const CarePart({super.key, required this.isExtra});

  @override
  State<CarePart> createState() => _CarePartState();
}

class _CarePartState extends State<CarePart> {
  @override
  @override
  Widget build(BuildContext context) {
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
                        onPressed: () {
                          report.toggleSwitch();
                        },
                        icon: const Icon(
                          Icons.compare_arrows,
                          color: Color(0xFF589399),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final reference = report.getReference(widget.isExtra);
                          FrontUtil.showReference(context, reference);
                        },
                        icon: const Icon(
                          Icons.link,
                          color: Color(0xFF589399),
                        ),
                      ),
                      IconButton(
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
                if (report.isSwitch)
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
                              margin: const EdgeInsets.only(top: 10, bottom: 15, left: 5, right: 5),
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
                        style: TextStyle(color: FrontUtil.textColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
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
