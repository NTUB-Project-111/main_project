// import 'package:drw/backend/models/records_model.dart';
// import 'package:drw/backend/models/reminds_model.dart';
// import 'package:drw/backend/services/apibase.dart';
// import 'package:drw/frontend/pages/tabs/tabs.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class RemindPage extends StatefulWidget {
//   const RemindPage({super.key});

//   @override
//   State<RemindPage> createState() => _RemindPageState();
// }

// class _RemindPageState extends State<RemindPage> {
//   //UI頁面
//   @override
//   Widget build(BuildContext context) {
//     final reminds = context.watch<Reminds>().reminds;
//     final records = context.watch<Records>().records;
//     return Scaffold(
//       backgroundColor: const Color(0xFFEBFEFF), // 設定背景顏色
//       appBar: AppBar(
//         toolbarHeight: 50, // 調整高度
//         leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back, // 返回鍵圖示
//               color: Color(0xFF589399), // 修改顏色
//             ),
//             onPressed: () async {
//               if (isSave.contains(false)) {
//                 _showErrorDialog();
//               } else if (isSave.isNotEmpty) {
//                 _saveRemind();
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const Tabs(
//                               currentIndex: 0,
//                             )));
//               } else {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const Tabs(
//                               currentIndex: 0,
//                             )));
//               }

//               // Navigator.pop(context);
//             }),
//         title: const Text(
//           "護理提醒",
//           style: TextStyle(
//             fontSize: 18, // 更改字體大小
//             color: Color(0xFF589399), // 更改字體顏色
//             fontWeight: FontWeight.bold, // 設定字體粗細
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0, // 移除預設陰影
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Container(
//             color: const Color(0xFF589399), // 設定底線顏色
//             height: 2, // 設定底線高度
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.settings,
//               size: 23,
//               color: Color(0xFF589399),
//             ),
//             onPressed: () => toggleDeleteViewForAll(), // 切換狀態
//           ),
//         ],
//       ),

//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         child: ListView.separated(
//           shrinkWrap: true, // 限制高度
//           itemCount: reminders.length,
//           separatorBuilder: (context, index) => const SizedBox(height: 0), // 設定間距
//           itemBuilder: (context, index) {
//             return reminders[index]["ifcall"]
//                 ? reminders[index]["isDeleteView"]
//                     ? _buildDeleteView(index)
//                     : Container(
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                             color: const Color(0xFF589399),
//                             width: 1.5,
//                           ),
//                         ),
//                         width: 380,
//                         child: AnimatedSize(
//                           duration: const Duration(milliseconds: 200),
//                           curve: Curves.easeInOut,
//                           child: reminders[index]["isPressed"]
//                               ? _buildEditableView(index)
//                               : _buildStaticView(index),
//                         ),
//                       )
//                 : Container();
//           },
//         ),
//       ),
//     );
//   }

// //傷口照片放置區
//   Widget _buildImage(String img) {
//     // 建立顯示圖片的區塊
//     return ClipRRect(
//       // 使用 ClipRRect 來創建圓角矩形
//       borderRadius: BorderRadius.circular(20), // 設定圓角
//       child: Container(
//         // 建立一個容器來模擬圖片
//         width: 90,
//         height: 90,
//         color: Colors.grey, // 設定背景顏色為灰色（預設圖片）
//         child: Image.network(
//           Uri.parse(ApiBase.baseUrl).resolve(img).toString(),
//           width: 90,
//           height: 90,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   final TextStyle textStyle = const TextStyle(fontSize: 13, color: Color(0xFF2e6d74));

//   Widget _buildStaticView(int index) {
//     // 顯示靜態提醒
//     return Stack(
//       // 疊加元素
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(10), // 設定內距
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center, // 底對齊
//             children: [
//               _buildImage(reminders[index]["img"]), // 呼叫 `_buildImage()` 生成圖片區塊
//               const SizedBox(width: 20), // 設定間距
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, // 左對齊
//                   children: [
//                     Text("拍攝日：${reminders[index]["date"]}", style: textStyle), // 假資料
//                     const SizedBox(height: 3),
//                     Text("傷口類型：${reminders[index]["type"]}", style: textStyle), // 假資料
//                     const SizedBox(height: 3),
//                     Text(
//                       "換藥時間：${reminders[index]["selectedFreq"]} "
//                       "${reminders[index]["selectedHour"]}:${reminders[index]["selectedMinute"].toString().padLeft(2, '0')}",
//                       style: textStyle,
//                     ),
//                     // const SizedBox(height: 10), // 設定間距
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: -5, // 調整位置
//           right: -5,
//           child: IconButton(
//             onPressed: () => toggleEditMode(index), // 切換為編輯模式
//             icon: const Icon(Icons.edit, size: 18, color: Color.fromRGBO(53, 53, 53, 1)), // 設定圖示
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEditableView(int index) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10), // 設定內距
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 圖片容器
//               Container(
//                 padding: const EdgeInsets.all(5),
//                 child: _buildImage(reminders[index]["img"]),
//               ),
//               const SizedBox(width: 10),
//               // 文字與選單
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.all(5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("拍攝日：${reminders[index]["date"]}", style: textStyle),
//                       const SizedBox(height: 5),
//                       Text("傷口類型：${reminders[index]["type"]}", style: textStyle),
//                       const SizedBox(height: 5),
//                       Row(
//                         children: [
//                           Text('換藥頻率：', style: textStyle),
//                           Flexible(
//                             child: _buildDropdownButton2(
//                               value: reminders[index]["selectedFreq"] ?? '每天',
//                               items: ['每天', '兩天一次', '三天一次', '每週'],
//                               onChanged: (newValue) => updateDay(index, newValue!),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 5),
//                       _buildEditableTimeFields(index),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Positioned 必須放在 Stack 內
//         Positioned(
//           top: -5,
//           right: -5,
//           child: IconButton(
//             onPressed: () {
//               if (index >= 0 && index < reminders.length) {
//                 toggleEditMode(index);
//               }
//               isSave[index] = true;
//             },
//             icon: const Icon(
//               Icons.check,
//               size: 18,
//               color: Colors.red,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEditableTimeFields(int index) {
//     // 建立可編輯的時間選擇區塊
//     return Row(
//       children: [
//         Text('換藥時間：', style: textStyle), // 顯示標籤「換藥時間」
//         _buildTimeSelector(
//           // 時間選擇器（小時）
//           value: reminders[index]["selectedHour"], // 目前選擇的小時
//           min: 0, // 最小值為 0
//           max: 23, // 最大值為 23
//           onChanged: (value) => updateTime(index, "selectedHour", value), // 更新選擇的小時
//         ),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 5), // 設定水平間距
//           child: Text(':', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // 顯示冒號（:）
//         ),
//         _buildTimeSelector(
//           // 時間選擇器（分鐘）
//           value: reminders[index]["selectedMinute"], // 目前選擇的分鐘
//           min: 0, // 最小值為 0
//           max: 59, // 最大值為 59
//           onChanged: (value) => updateTime(index, "selectedMinute", value), // 更新選擇的分鐘
//         ),
//       ],
//     );
//   }

//   Widget _buildTimeSelector({
//     // 建立時間選擇輸入框
//     required int value, // 目前的數值
//     required int min, // 最小值
//     required int max, // 最大值
//     required ValueChanged<int> onChanged, // 當使用者修改時觸發的函數
//   }) {
//     TextEditingController controller = // 建立控制器，並初始化數值（補零格式）
//         TextEditingController(text: value.toString().padLeft(2, '0'));

//     return Container(
//       // 建立外框
//       margin: const EdgeInsets.only(top: 5), // 設定上邊距
//       width: 50, // 設定寬度
//       decoration: BoxDecoration(
//         // 設定框線裝飾
//         borderRadius: BorderRadius.circular(15), // 設定圓角
//         border: Border.all(color: const Color(0xFF589399)), // 設定邊框顏色
//       ),
//       child: TextField(
//         // 建立文字輸入框
//         controller: controller, // 綁定控制器
//         keyboardType: TextInputType.number, // 設定為數字輸入
//         textAlign: TextAlign.center, // 文字置中
//         style: const TextStyle(fontSize: 14), // 設定字體大小
//         decoration: const InputDecoration(
//           // 設定輸入框樣式
//           contentPadding: EdgeInsets.symmetric(vertical: 5), // 設定內邊距
//           border: InputBorder.none, // 移除底線
//         ),
//         onSubmitted: (input) {
//           // 當使用者輸入完成後執行
//           int? newValue = int.tryParse(input); // 轉換輸入為數字
//           if (newValue != null && newValue >= min && newValue <= max) {
//             // 確保輸入數值在範圍內
//             onChanged(newValue); // 更新數值
//           } else {
//             // 若輸入錯誤，則恢復原始數值
//             controller.text = value.toString().padLeft(2, '0');
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildDropdownButton2({
//     required String value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Container(
//       height: 30,
//       width: 150,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(color: const Color(0xFF589399)),
//       ),
//       child: DropdownButton2<String>(
//         alignment: Alignment.center,
//         value: value,
//         // dropdownDirection: DropdownDirection.down, // 指定向下展開
//         dropdownStyleData: DropdownStyleData(
//           width: 150,
//           elevation: 0, //無陰影
//           offset: const Offset(-10, -1),
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xFF589399)),
//             borderRadius: BorderRadius.circular(8),
//             color: Colors.white,
//           ),
//         ),
//         isExpanded: true,
//         underline: const SizedBox.shrink(),
//         style: const TextStyle(color: Colors.red),
//         items: items.map(
//           (item) {
//             return DropdownMenuItem<String>(
//               value: item,
//               child: Text(
//                 item,
//                 style: textStyle,
//               ),
//             );
//           },
//         ).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }

//   Widget _buildDeleteView(int index) {
//     return Row(
//       mainAxisSize: MainAxisSize.min, // 讓 Row 只佔所需的空間
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // 主要內容區塊
//         Expanded(
//           // 確保主要內容可以正確顯示
//           child: Container(
//             margin: const EdgeInsets.only(bottom: 15),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: const Color(0xFF589399), width: 2),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // 傷口圖片
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: SizedBox(
//                     width: 90, // 限制圖片大小
//                     height: 90,
//                     child: _buildImage(reminders[index]["img"]),
//                   ),
//                 ),
//                 const SizedBox(width: 20), // 設定間距

//                 // 文字區塊
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("拍攝日：${reminders[index]["date"]}", style: textStyle),
//                       const SizedBox(height: 3),
//                       Text("傷口類型：${reminders[index]["type"]}", style: textStyle),
//                       const SizedBox(height: 3),
//                       Text(
//                         "換藥時間：${reminders[index]["selectedFreq"]} "
//                         "${reminders[index]["selectedHour"]}:${reminders[index]["selectedMinute"].toString().padLeft(2, '0')}",
//                         style: textStyle,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(width: 15), // 設定主要內容與按鈕的間距

//         // 刪除按鈕區塊
//         Container(
//           width: 35,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.red,
//           ),
//           child: IconButton(
//             onPressed: () {
//               if (index >= 0 && index < reminders.length) {
//                 _showConfirmationDialog(index);
//                 setState(() {
//                   // reminders.removeAt(index); // 移除對應索引的提醒
//                   // reminders[index]["ifcall"] = 'N';
//                   userCalls?[index]['ifcall'] = 'N';
//                 });
//               }
//             },
//             icon: const Icon(Icons.close, color: Colors.white, size: 20),
//             padding: const EdgeInsets.all(5), // 減少內距，使按鈕更小
//             constraints: const BoxConstraints(), // 移除默認的按鈕大小限制
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class RemindPage extends StatefulWidget {
  const RemindPage({super.key});

  @override
  State<RemindPage> createState() => _RemindPageState();
}

class _RemindPageState extends State<RemindPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      appBar: AppBar(
        title: const Text(
          '護理提醒',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildReminderCard(
              imagePath: 'images/hospital.png', // 替換成你實際的圖片路徑
              date: '20XX/XX/XX',
              woundType: '擦傷',
              remindDate: '2025/06/10',
              time: '18：30'),
          buildReminderCard(
              imagePath: 'images/hospital.png',
              date: '20XX/XX/XX',
              woundType: '擦傷',
              remindDate: '2025/06/13',
              time: '18：30'),
          buildReminderCard(
              imagePath: 'images/hospital.png',
              date: '20XX/XX/XX',
              woundType: '割傷',
              remindDate: '2025/06/03',
              time: '18：30'),
        ],
      ),
    );
  }

  Widget buildReminderCard({
    required String imagePath,
    required String date,
    required String woundType,
    required String remindDate,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF669FA5), width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('拍攝日：$date',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF589399))),
                      Text('傷口類型：$woundType',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF589399))),
                      Text('換藥日期：$remindDate',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF589399))),
                      Text('換藥時間：$time',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF589399))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -3,
            bottom: -3,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_rounded, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
