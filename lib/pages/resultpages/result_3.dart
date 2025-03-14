import 'package:flutter/material.dart';
import '../../my_flutter_app_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ResultPage3 extends StatefulWidget {
  final List<String> resultinfo;

  const ResultPage3({super.key, required this.resultinfo});

  @override
  State<ResultPage3> createState() => _ResultPage3State();
}

class _ResultPage3State extends State<ResultPage3> {
  Icon _icon = const Icon(
    MyFlutterApp.bell_slash,
    color: Color(0xFF589399),
  );
  bool _notify = false;
  String? selectedFrequency = "每天一次";
  TimeOfDay selectedTime = TimeOfDay.now();

  void _showReminderDialog(BuildContext context) {
    // 將選擇的時間初始值設定在對話框外層，讓其狀態能夠在對話框內更新

    showDialog(
      barrierDismissible: false, // 禁止點擊外部區域關閉對話框
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: Color(0xFF589399),
                  width: 2,
                ),
              ),
              backgroundColor: Colors.white,
              title: const Text(
                '換藥提醒',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF589399),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "提醒頻率",
                          style: TextStyle(
                            height: 3,
                            fontSize: 16,
                            color: Color(0xFF589399),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            alignment: Alignment.center,
                            isExpanded: true,
                            hint: const Text(
                              '----- 請選擇 -----',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 12,
                                color: Color(0xFFAEAEAE),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: ["每天一次", "每兩天一次", "每週一次", "每月一次"]
                                .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 14,
                                          color: Color.fromRGBO(88, 147, 153, 1),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: selectedFrequency,
                            onChanged: (String? value) {
                              // 用 dialogSetState 更新對話框內 UI
                              dialogSetState(() {
                                selectedFrequency = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color.fromRGBO(154, 201, 205, 1),
                                ),
                                color: Colors.white,
                              ),
                              elevation: 0,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down_rounded,
                              ),
                              iconSize: 30,
                              iconEnabledColor: Color.fromRGBO(88, 147, 153, 1),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              elevation: 0,
                              maxHeight: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(154, 201, 205, 1),
                                ),
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: WidgetStateProperty.all(6),
                                thumbVisibility: WidgetStateProperty.all(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 33,
                              padding: EdgeInsets.only(left: 25, right: 14),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "提醒時間",
                              style: TextStyle(
                                height: 3,
                                fontSize: 16,
                                color: Color(0xFF589399),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              selectedTime.format(context),
                              style: const TextStyle(
                                height: 3,
                                fontSize: 16,
                                color: Color(0xFF589399),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            timePickerTheme: TimePickerThemeData(
                                backgroundColor: const Color(0xFFF7FCFD),
                                dialHandColor: const Color(0xFF589399),
                                dialTextColor: const Color(0xFF2E6D74),
                                dialBackgroundColor: Colors.white,
                                // hourMinuteColor: const Color(0xFFBBD3D6),
                                hourMinuteTextColor: const Color(0xFF164449),
                                hourMinuteShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Color(0xFF589399), width: 2),
                                ),
                                dayPeriodColor: WidgetStateColor.resolveWith(
                                  (states) => const Color(0xFF589399),
                                ),
                                dayPeriodTextColor: Colors.white,
                                // ... 其他可設定的屬性
                                confirmButtonStyle: ButtonStyle(
                                  textStyle: WidgetStateProperty.all<TextStyle>(
                                    const TextStyle(fontWeight: FontWeight.bold), // 設定字體寬度
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(const Color(0xFF589399)),
                                ),
                                helpTextStyle: const TextStyle(color: Color(0xFF589399)),
                                cancelButtonStyle: ButtonStyle(
                                  foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                                )),
                          ),
                          child: Builder(
                            builder: (context) => OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0), // 調整圓角半徑
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 70),
                                side: const BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(154, 201, 205, 1),
                                ),
                              ),
                              onPressed: () async {
                                final result = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.dial, // dial 或 input
                                    helpText: "選擇時間",
                                    confirmText: "確定",
                                    cancelText: "取消");
                                if (result != null) {
                                  dialogSetState(() {
                                    selectedTime = result;
                                  });
                                }
                                // ...
                              },
                              child: const Text(
                                '選擇時間',
                                style: TextStyle(
                                  color: Color.fromRGBO(88, 147, 153, 1),
                                  // fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0), // 調整圓角半徑
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          side: const BorderSide(
                            width: 2,
                            color: Color(0xFF589399),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _notify = false;
                            _icon = const Icon(
                              MyFlutterApp.bell_slash,
                              color: Color(0xFF589399),
                            );
                          });
                          Navigator.pop(context); // 關閉對話框
                        },
                        child: const Text(
                          '取消',
                          style: TextStyle(
                            color: Color(0xFF589399),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0), // 調整圓角半徑
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          backgroundColor: const Color(0xFF589399),
                          side: BorderSide.none,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // 關閉對話框
                        },
                        child: const Text(
                          '確定',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "※提醒頻率及時間皆可至小鈴鐺處進行修改※",
                    style: TextStyle(
                      height: 3,
                      fontSize: 12,
                      color: Color(0xFF589399),
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '傷口護理建議',
                          style: TextStyle(
                            height: 3,
                            color: Color(0xFF589399),
                            fontSize: 22,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _notify = !_notify;
                              _icon = _notify
                                  ? const Icon(
                                      MyFlutterApp.bell,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      MyFlutterApp.bell_slash,
                                      color: Color(0xFF589399),
                                    );
                            });
                            _notify ? _showReminderDialog(context) : null;
                          },
                          icon: _icon,
                        ),
                        // const Icon(MyFlutterApp.bell,color: Color(0xFF589399),),
                      ],
                    ),
                  ),
                  ...List.generate(widget.resultinfo.length, (index) {
                    //前面的 ... 是 Dart 的展開運算子，將列表中的每個元素展開並直接插入到 Column 中。
                    return _buildSuggestionItem('${index+1}', widget.resultinfo[index]);
                  }),
                  // _buildSuggestionItem('1', '用清水輕輕沖洗傷口，清除表面的灰塵或異物'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionItem(String n, String text) {
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
