import 'package:drw/backend/models/report_model.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarePart extends StatefulWidget {
  const CarePart({super.key});

  @override
  State<CarePart> createState() => _CarePartState();
}

class _CarePartState extends State<CarePart> {
  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF589399), width: 2))),
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
              Consumer<Report>(
                builder: (context, report, child) {
                  return IconButton(
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
                  );
                },
              ),
            ],
          ),
          // ...List.generate(report.careSteps.length, (index) {
          //   //前面的 ... 是 Dart 的展開運算子，將列表中的每個元素展開並直接插入到 Column 中。
          //   return _buildCareStep('${index + 1}', report.careSteps[index]);
          // }),
          ..._buildAllWoundSections(report.careSteps),
        ],
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
            margin: const EdgeInsets.symmetric( vertical: 5),
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
