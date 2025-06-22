import 'package:drw/backend/models/report_model.dart';
import 'package:drw/frontend/tools/front_tool.dart';
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
                      if (report.notify) FrontTool.showRemindDialog(context, report);
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
          ...List.generate(report.careSteps.length, (index) {
            //前面的 ... 是 Dart 的展開運算子，將列表中的每個元素展開並直接插入到 Column 中。
            return _buildCareStep('${index + 1}', report.careSteps[index]);
          }),
        ],
      ),
    );
  }

  Widget _buildCareStep(String n, String text) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 13),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4D000000),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  n,
                  style: const TextStyle(
                    color: Color(0xFF589399),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  // 確保文字可以換行
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF589399),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
