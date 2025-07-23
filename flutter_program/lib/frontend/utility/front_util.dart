import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:drw/backend/models/report_model.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FrontUtil {
  static Color bkColor = const Color(0xFFEBFEFF); //主畫面的背景顏色
  static Color bkColor2 = const Color(0xFFF5FEFF); //註冊帳號的背景顏色
  static Color textColor = const Color(0xFF669FA5); //主要文字顏色

  static void showError(String errorMessage, Color bkcolor, Color textcolor) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: bkcolor,
      textColor: textcolor,
      fontSize: 16.0,
    );
  }

  static void showSuccess(String succMessage) {
    Fluttertoast.showToast(
      msg: succMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color.fromARGB(255, 128, 203, 211),
      textColor: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 16.0,
    );
  }

  static void showFail(String failMessage) {
    Fluttertoast.showToast(
      msg: failMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color.fromARGB(255, 214, 92, 92),
      textColor: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 16.0,
    );
  }

  static Widget dash(double screenWidth) {
    return Center(
      child: Dash(
        direction: Axis.horizontal,
        length: screenWidth * 0.9,
        dashLength: 5,
        dashGap: 5,
        dashColor: const Color(0xFF669FA5),
        dashThickness: 2,
      ),
    );
  }

  static Widget loading() {
    return const Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF589399)),
    ));
  }

  static void showTextDialog(BuildContext context, String title, String confirm, String cancel,
      {VoidCallback? onConfirm}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF589399),
            width: 2,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF589399),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                backgroundColor: const Color(0xFF589399),
                side: BorderSide.none,
              ),
              onPressed: () {
                Navigator.pop(context); // 關閉對話框
                if (onConfirm != null) {
                  onConfirm(); // ✅ 執行傳入的動作
                }
              },
              child: Text(
                confirm,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                side: const BorderSide(
                  width: 2,
                  color: Color(0xFF589399),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                cancel,
                style: const TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 顯示確認對話框
  static void showImageDialog(BuildContext context, File image, String title, String confirm,
      String cancle, Widget nextPage) {
    showDialog(
      barrierDismissible: false, // 禁止點擊外部區域關閉對話框
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF589399),
            width: 2,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF589399),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                image,
                width: 200,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                backgroundColor: const Color(0xFF589399),
                side: BorderSide.none,
              ),
              onPressed: () async {
                Navigator.pop(context); // 關閉對話框
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                        create: (_) {
                          final report = Report();
                          report.setImage(image); // ← 設定圖片
                          return report;
                        },
                        child: nextPage),
                  ),
                );
              },
              child: Text(
                confirm,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                side: const BorderSide(
                  width: 2,
                  color: Color(0xFF589399),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // 關閉對話框
              },
              child: Text(
                cancle,
                style: const TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showRemindDialog(BuildContext context, Report report) {
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
                            items: ["每天", "兩天一次", "三天一次", "每週"]
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
                            value: report.remindFreq,
                            onChanged: (String? value) {
                              // 用 dialogSetState 更新對話框內 UI
                              dialogSetState(() {
                                report.remindFreq = value!;
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
                              report.remindTime,
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
                                    final time =
                                        "${result.hour.toString().padLeft(2, '0')}:${result.minute.toString().padLeft(2, '0')}";
                                    report.remindTime = time;
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
                          report.toggleNotify();
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

  static void showConfirmationDialog(BuildContext context, String img, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: const Color(0xFFF5FEFF),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  Uri.parse(ApiBase.baseUrl).resolve(img).toString(),
                  height: 300,
                  width: 280,
                  fit: BoxFit.cover,
                ),
              ),
              Wrap(
                children: [
                  Text(
                    "#$type",
                    style: const TextStyle(
                        color: Color(0xFF589399), height: 3, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //拍攝照片時跳出兩個按鈕
  static void showButtonDialog(
      String text1, String text2, VoidCallback onTap1, VoidCallback onTap2, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color(0xFF589399),
            width: 2,
          ),
        ),
        backgroundColor: const Color(0xFFF5FEFF),
        contentPadding: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // 點完關閉 dialog
                onTap1(); // 執行傳入的第一個方法
              },
              splashColor: const Color(0xFFDFF6F7),
              highlightColor: const Color(0xFFDFF6F7),
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF669FA5))),
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt, color: Color(0xFF589399)),
                    const SizedBox(width: 15),
                    Text(text1, style: const TextStyle(color: Color(0xFF589399), fontSize: 14)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // 點完關閉 dialog
                onTap2(); // 執行傳入的第二個方法
              },
              splashColor: const Color(0xFFDFF6F7),
              highlightColor: const Color(0xFFDFF6F7),
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: double.infinity,
                child: Row(
                  children: [
                    const Icon(Icons.photo, color: Color(0xFF589399)),
                    const SizedBox(width: 15),
                    Text(text2, style: const TextStyle(color: Color(0xFF589399), fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showConfirmWoundDialog(
      BuildContext context, Color color, String title, String cancel, String confirm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        content: SizedBox(
          width: 280, // 設定最大寬度
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  height: 2,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30), // 可視情況調整
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide(color: color),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(cancel, style: TextStyle(color: color)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      confirm,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //確認傷口照片
  static void showSelectWoundDialog(BuildContext context, Color color, String title,
      String? subTitle, String cancel, String confirm, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        content: SizedBox(
          width: 280, // 設定最大寬度
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  height: 2,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              subTitle != null
                  ? Text(
                      subTitle,
                      style: TextStyle(
                        height: 2,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30), // 可視情況調整
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide(color: color),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(cancel, style: TextStyle(color: color)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    child: Text(
                      confirm,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
