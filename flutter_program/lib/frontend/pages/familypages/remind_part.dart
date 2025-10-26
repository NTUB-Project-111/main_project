// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:drw/frontend/utility/front_util.dart';
// import 'package:flutter/material.dart';

// class RemindPart extends StatefulWidget {
//   const RemindPart({super.key});

//   @override
//   State<RemindPart> createState() => _RemindPartState();
// }

// class _RemindPartState extends State<RemindPart> {
//   /// 每張卡的編輯狀態
//   final List<bool> isEditingList = List.filled(4, false);

//   /// 每張卡的頻率選擇
//   final List<String> selectedFreqList = List.filled(4, '每天');

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         ...List.generate(
//           4,
//           (index) => Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: _buildRemindSection(
//               index: index,
//               imageUrl: 'https://i.imgur.com/0vYJq8K.jpg',
//               date: '2025/10/20',
//               type: '擦傷',
//               time: '2025/10/21 18:30',
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRemindSection({
//     required int index,
//     required String imageUrl,
//     required String date,
//     required String type,
//     required String time,
//   }) {
//     bool isEditing = isEditingList[index];
//     String selectedFreq = selectedFreqList[index];

//     return Container(
//       // height: 115,
//       padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: FrontUtil.textColor, width: 2),
//       ),
//       child: Row(
//         children: [
//           // 左側圖片
//           ClipRRect(
//             borderRadius: BorderRadius.circular(18),
//             child: Image.network(
//               imageUrl,
//               width: 92,
//               height: 92,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, progress) {
//                 if (progress == null) return child;
//                 return Container(
//                   width: 92,
//                   color: Colors.grey[200],
//                   child: const Center(
//                     child: CircularProgressIndicator(strokeWidth: 1),
//                   ),
//                 );
//               },
//               errorBuilder: (_, __, ___) => Container(
//                 width: 92,
//                 color: Colors.grey[200],
//                 child: const Icon(Icons.broken_image, color: Colors.grey),
//               ),
//             ),
//           ),

//           // 右側文字區
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   isEditing
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '角色：媽媽',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: FrontUtil.textColor,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () => setState(() {
//                                 isEditingList[index] = false;
//                               }),
//                               icon: const Icon(Icons.check,
//                                   size: 18, color: Colors.red),
//                             ),
//                           ],
//                         )
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '角色：媽媽',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: FrontUtil.textColor,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () => setState(() {
//                                 isEditingList[index] = true;
//                               }),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.edit,
//                                       size: 18, color: Color(0xFF525252)),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     '編輯',
//                                     style: TextStyle(
//                                       color: Color(0xFF525252),
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                   const SizedBox(height: 3),
//                   Text(
//                     '拍攝日：$date',
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: FrontUtil.textColor,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Text(
//                     '傷口類型：$type',
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: FrontUtil.textColor,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 3),

//                   // 編輯模式 vs 顯示模式
//                   isEditing
//                       ? Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   '換藥頻率：',
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: FrontUtil.textColor,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 Flexible(
//                                   child: DropdownButtonHideUnderline(
//                                     child: DropdownButton2<String>(
//                                       isExpanded: true,
//                                       value: selectedFreq,
//                                       items: ['每天', '兩天一次', '三天一次', '每週']
//                                           .map((day) => DropdownMenuItem<String>(
//                                                 value: day,
//                                                 child: Text(
//                                                   day,
//                                                   style: const TextStyle(
//                                                       color: Color(0xFF589399),
//                                                       fontSize: 14),
//                                                 ),
//                                               ))
//                                           .toList(),
//                                       onChanged: (value) => setState(() {
//                                         selectedFreqList[index] = value!;
//                                       }),
//                                       buttonStyleData: ButtonStyleData(
//                                         height: 30,
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 16),
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                               color: const Color(0xFF669FA5)),
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       dropdownStyleData: DropdownStyleData(
//                                         elevation: 0,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           border: Border.all(
//                                               color: const Color(0xFF669FA5)),
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       menuItemStyleData:
//                                           const MenuItemStyleData(height: 40),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   '換藥時間 ：',
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: FrontUtil.textColor,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 _buildTimeBox('18'),
//                                 const Text(
//                                   ' : ',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF264E5C),
//                                   ),
//                                 ),
//                                 _buildTimeBox('30'),
//                               ],
//                             )
//                           ],
//                         )
//                       : Text(
//                           '換藥日 ：$time',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: FrontUtil.textColor,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeBox(String text) => Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xFF669FA5)),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text(
//           text,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF264E5C),
//           ),
//         ),
//       );
// }

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class RemindPart extends StatefulWidget {
  const RemindPart({super.key});

  @override
  State<RemindPart> createState() => _WoundRemindPageState();
}

class _WoundRemindPageState extends State<RemindPart> {
  // 模擬今日換藥的資料
  List<Map<String, dynamic>> reminders = [
    {"time": "12:00", "member": "媽媽", "done": false},
    {"time": "12:00", "member": "媽媽", "done": false},
    {"time": "12:00", "member": "媽媽", "done": true},
    {"time": "12:00", "member": "媽媽", "done": false},
    {"time": "12:00", "member": "媽媽", "done": false},
    {"time": "12:00", "member": "媽媽", "done": false},
  ];

  // 模擬推薦開啟提醒的傷口照片
  List<String> recommended = [
    "10.25",
    "10.25",
    "10.25",
    "10.25",
  ];

  @override
  Widget build(BuildContext context) {
    int total = reminders.length;
    int doneCount = reminders.where((r) => r["done"]).length;

    // 設定每個 item 高度 + margin
    const double itemHeight = 73;
    const int maxVisibleItems = 5;
    final double listHeight = (reminders.length > maxVisibleItems
            ? maxVisibleItems
            : reminders.length) *
        itemHeight;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== 今日換藥區塊 =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "今日換藥",
                style: TextStyle(
                  color: Color(0xFF669FA5),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$doneCount / $total",
                style: const TextStyle(
                  color: Color(0xFF9FBABB),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 今日換藥列表（固定高度 + 可滑動）
          // 希望可以在點擊單個提醒時跳出對應的診斷報告
          SizedBox(
            height: listHeight,
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final remind = reminders[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 18, color: Color(0xFF9FBABB)),
                          const SizedBox(width: 8),
                          Text("換藥時間：${remind["time"]}"),
                          const SizedBox(width: 20),
                          Text("家人：${remind["member"]}"),
                        ],
                      ),
                      Checkbox(
                        value: remind["done"],
                        activeColor: const Color(0xFF669FA5),
                        onChanged: (val) {
                          setState(() => remind["done"] = val);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 25),

          // ===== 推薦開啟提醒區塊 =====
          const Text(
            "建議開啟換藥提醒", //可以根據癒合時間的長短進行建議
            style: TextStyle(
              color: Color(0xFF669FA5),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recommended.length,
              separatorBuilder: (_, __) => const SizedBox(width: 5),
              itemBuilder: (context, index) {
                return Container(
                  width: 110,
                  padding: const EdgeInsets.all(6),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8E6E6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "拍攝日：${recommended[index]}",
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
