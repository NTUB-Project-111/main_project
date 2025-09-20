import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/pages/confirm_wound_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/utility/gallery_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectImagePage extends StatefulWidget {
  const SelectImagePage({super.key});

  @override
  State<SelectImagePage> createState() => _SelectImagePageState();
}

class _SelectImagePageState extends State<SelectImagePage> {
  bool showExtraButtons = false;
  bool showWoundChooser = false;
  Set<String> selectedWounds = {};
  DateTime? selectedDate;
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.97); // 按下時縮小
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0); // 放開時回復
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0); // 取消時回復
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final reports = reportProvider.reports;
    Gallery gallery = Gallery();
    gallery.sortReports(reports);
    final filteredReports = gallery.reports.where((reportGroup) {
      final report = reportGroup.first;
      final matchWound =
          selectedWounds.isEmpty || selectedWounds.contains(report.type);
      final matchDate = selectedDate == null ||
          report.date ==
              "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
      return matchWound && matchDate;
    }).toList();
    final visibleReports =
        filteredReports.where((r) => r.first.oktime != '傷口已痊癒').toList();

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 217, 234, 236),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 217, 234, 236),
          title: Text(
            '選擇傷口',
            style: TextStyle(
              fontSize: 20, // 字體大小
              fontWeight: FontWeight.bold, // 粗體
              color: FrontUtil.textColor, // 文字顏色（可以依需要換掉）
            ),
          ),
          iconTheme: IconThemeData(color: FrontUtil.textColor),
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: visibleReports.length,
              itemBuilder: (context, index) {
                final report = visibleReports[index].first;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: _buildWoundSection(report),
                );
              },
            ),
            Visibility(
              visible: showWoundChooser,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x4D2E6D74),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 13,
                    runSpacing: 8,
                    children: [
                      _buildWoundButton("擦傷"),
                      _buildWoundButton("割傷"),
                      _buildWoundButton("瘀青"),
                      _buildWoundButton("燒傷"),
                      _buildWoundButton("刺傷"),
                      _buildWoundButton("手術傷口"),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              right: showExtraButtons ? 162 : 25,
              bottom: 30, // 隱藏時往下滑出畫面外
              child: AnimatedOpacity(
                opacity: showExtraButtons ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: !showExtraButtons,
                  child: _buildCircleButton(
                    icon: Icons.calendar_month,
                    onTap: () {
                      _showDatePicker();
                    },
                  ),
                ),
              ),
            ),

            // 2. 儀表板按鈕（中間層）
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              right: showExtraButtons ? 100 : 25, // 拉出畫面外
              bottom: 30,
              child: AnimatedOpacity(
                opacity: showExtraButtons ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: !showExtraButtons,
                  child: _buildCircleButton(
                    icon: Icons.space_dashboard_rounded,
                    onTap: () {
                      setState(() {
                        showWoundChooser = !showWoundChooser;
                      });
                    },
                  ),
                ),
              ),
            ),

            // 3. 搜尋按鈕（最上層）
            Positioned(
              right: 25,
              bottom: 25,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showExtraButtons = !showExtraButtons;
                    showWoundChooser = false;
                  });
                  debugPrint(showExtraButtons.toString());
                },
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: FrontUtil.textColor, width: 2),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x4D2E6D74),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.search,
                    color: FrontUtil.textColor,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  // Widget _buildWoundSection(UserReport report) {
  //   final photoPath = report.photo;
  //   final imageUrl = Uri.parse(ApiBase.baseUrl).resolve(photoPath).toString();
  //   final woundList = _getWoundList(report);
  //   return InkWell(
  //       onTap: () async {
  //         final updated = await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ConfirmWoundPage(report: report),
  //           ),
  //         );

  //         if (updated == true) {
  //           debugPrint('資料更新');
  //           debugPrint(report.oktime);
  //           // 有異動才重新拉資料
  //           setState(() {}); // 重新 build 畫面
  //         }
  //       },
  //       child: Container(
  //         // color: FrontUtil.bkColor,
  //         padding: const EdgeInsets.all(5),
  //         width: double.infinity,
  //         child: Row(
  //           children: [
  //             Container(
  //                 width: 82,
  //                 height: 82,
  //                 margin: const EdgeInsets.all(10),
  //                 decoration: const BoxDecoration(
  //                   borderRadius: BorderRadius.all(Radius.circular(15)),
  //                   color: Colors.grey,
  //                 ),
  //                 child: ClipRRect(
  //                   borderRadius: const BorderRadius.all(Radius.circular(15)),
  //                   child: Image.network(
  //                     imageUrl,
  //                     width: 82,
  //                     height: 82,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 )),
  //             const SizedBox(width: 5),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     report.name,
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: FrontUtil.textColor,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 15),
  //                   Text(
  //                     report.date,
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: FrontUtil.textColor,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               margin: const EdgeInsets.only(right: 5),
  //               padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
  //               decoration: BoxDecoration(
  //                 color: woundList[1], // 綠色背景
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Text(
  //                 woundList[0],
  //                 style: const TextStyle(color: Colors.white, fontSize: 18),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  // }

  Widget _buildWoundSection(UserReport report) {
    final photoPath = report.photo;
    final imageUrl = Uri.parse(ApiBase.baseUrl).resolve(photoPath).toString();
    final woundList = _getWoundList(report);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0, // ⭐ 沒有陰影
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmWoundPage(report: report),
                ),
              );

              if (updated == true) {
                debugPrint('資料更新');
                debugPrint(report.oktime);
                setState(() {}); // 重新 build 畫面
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 左邊照片
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 中間文字
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: FrontUtil.textColor,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          report.date,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: FrontUtil.textColor.withOpacity(0.7),
                                  ),
                        ),
                      ],
                    ),
                  ),

                  // 右邊標籤
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: woundList[1],
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      woundList[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> _getWoundList(UserReport report) {
    List<dynamic> woundList = ['', Colors.grey];
    if (report.type == '手術傷口') {
      woundList[0] = '術';
      woundList[1] = const Color(0xFFBFADFF);
    } else {
      woundList[0] = report.type.substring(0, 1);
      if (report.type == '擦傷') {
        woundList[1] = const Color(0xFF8CB083);
      } else if (report.type == '割傷') {
        woundList[1] = const Color(0xFFFEC1D9);
      } else if (report.type == '燙傷' || report.type == '燒傷') {
        woundList[1] = const Color(0xFFFFCA98);
      } else if (report.type == '嚴重傷口') {
        woundList[1] = const Color(0xFFFF6A6A);
      } else if (report.type == '刺傷') {
        woundList[1] = const Color(0xFFA68894);
      } else if (report.type == '瘀青') {
        woundList[1] = const Color(0xFFC1D3FE);
      }
    }
    return woundList;
  }

  Widget _buildWoundButton(String text) {
    final isSelected = selectedWounds.contains(text);

    return SizedBox(
      width: 150,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            if (isSelected) {
              selectedWounds.remove(text); // 取消選擇
            } else {
              selectedWounds.add(text); // 加入選擇
            }
          });
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: FrontUtil.textColor,
          ),
          backgroundColor: isSelected ? FrontUtil.textColor : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 5),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : FrontUtil.textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x4D2E6D74),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: FrontUtil.textColor,
          size: 32,
        ),
      ),
    );
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: FrontUtil.textColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // 這裡確保OK/Cancel按鈕使用指定顏色
              ),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    setState(() {
      selectedDate = pickedDate; // 若為 null 表示取消選擇，也會一併清空篩選
    });
  }
}
