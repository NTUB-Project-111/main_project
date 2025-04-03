import 'package:flutter/material.dart'; // 引入 Flutter 的 UI 套件
import 'package:dropdown_button2/dropdown_button2.dart'; // 引入第三方下拉選單套件
import '../my_flutter_app_icons.dart'; // 引入自訂義的圖示
import 'headers/header_1.dart'; // 引入標頭檔
import './tabs.dart'; // 引入底部導覽列的頁面

class RemindPage extends StatefulWidget {
  // 定義一個可變狀態的頁面
  const RemindPage({super.key}); // 建構子，允許父元件傳遞 `key`

  @override
  State<RemindPage> createState() => _RemindPageState(); // 創建對應的狀態管理類別
}

class _RemindPageState extends State<RemindPage> with TickerProviderStateMixin {
  // `_RemindPageState` 負責處理頁面的狀態變更，`TickerProviderStateMixin` 用於動畫

  List<Map<String, dynamic>> reminders = [
    // 定義提醒事項的清單
    {
      "isPressed": false, // 是否為編輯模式
      "selectedDay": "周一", // 預設換藥日
      "selectedHour": 17, // 預設小時
      "selectedMinute": 30, // 預設分鐘
      "isDeleteView": false, // 是否顯示刪除視圖
    },
    {
      "isPressed": false,
      "selectedDay": "周二",
      "selectedHour": 15,
      "selectedMinute": 45,
      "isDeleteView": false,
    },
  ];

  void toggleEditMode(int index) {
    // 切換是否為編輯模式
    setState(() {
      reminders[index]["isPressed"] =
          !reminders[index]["isPressed"]; // 取反 `isPressed`
    });
  }

  void updateTime(int index, String field, int value) {
    // 更新時間
    setState(() {
      reminders[index][field] = value; // 修改選定的時間（時或分）
    });
  }

  void updateDay(int index, String newDay) {
    // 更新換藥日
    setState(() {
      reminders[index]["selectedDay"] = newDay; // 修改選定的星期
    });
  }

  void toggleDeleteViewForAll() {
    setState(() {
      isDeleteMode = !isDeleteMode; // 切換刪除模式
      for (var i = 0; i < reminders.length; i++) {
        reminders[i]["isDeleteView"] = isDeleteMode; // 根據狀態設置
      }
    });
  }

  Widget buildReminderItem(int index) {
    return _buildDeleteView(index); // 確保這裡回傳一個 Widget
  }

  bool isDeleteMode = false; // 控制刪除模式的開關

  void toggleDeleteMode() {
    setState(() {
      isDeleteMode = !isDeleteMode; // 切換狀態
    });
  }

//UI頁面
  @override
  Widget build(BuildContext context) {
    // 當 `setState` 被呼叫時，`build` 會重新繪製 UI
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF), // 設定背景顏色
      appBar: AppBar(
        toolbarHeight: 50, // 調整高度
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, // 返回鍵圖示
            color: Color(0xFF589399), // 修改顏色
          ),
          onPressed: () {
            Navigator.pop(context); // 返回上一頁
          },
        ),
        title: const Text(
          "護理提醒",
          style: TextStyle(
            fontSize: 20, // 更改字體大小
            color: Color(0xFF589399), // 更改字體顏色
            fontWeight: FontWeight.bold, // 設定字體粗細
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // 移除預設陰影
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Color(0xFF589399), // 設定底線顏色
            height: 2.5, // 設定底線高度
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.brightness_high,
              size: 23,
              color: Color(0xFF589399),
            ),
            onPressed: () => toggleDeleteViewForAll(), // 切換狀態
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: ListView.separated(
          shrinkWrap: true, // 限制高度
          itemCount: reminders.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: 15), // 設定間距
          itemBuilder: (context, index) {
            return reminders[index]["isDeleteView"]
                ? _buildDeleteView(index)
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF589399),
                        width: 1.5,
                      ),
                    ),
                    width: 380,
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: reminders[index]["isPressed"]
                          ? _buildEditableView(index)
                          : _buildStaticView(index),
                    ),
                  );
          },
        ),
      ),
    );
  }

//傷口照片放置區
  Widget _buildImage() {
    // 建立顯示圖片的區塊
    return ClipRRect(
      // 使用 ClipRRect 來創建圓角矩形
      borderRadius: BorderRadius.circular(20), // 設定圓角
      child: Container(
        // 建立一個容器來模擬圖片
        width: 100,
        height: 100,
        color: Colors.grey, // 設定背景顏色為灰色（預設圖片）
      ),
    );
  }

  final TextStyle textStyle =
      const TextStyle(fontSize: 13, color: Color(0xFF2e6d74));

  Widget _buildStaticView(int index) {
    // 顯示靜態提醒
    return Stack(
      // 疊加元素
      children: [
        Padding(
          padding: const EdgeInsets.all(10), // 設定內距
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // 底對齊
            children: [
              _buildImage(), // 呼叫 `_buildImage()` 生成圖片區塊
              const SizedBox(width: 20), // 設定間距
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 左對齊
                  children: [
                    Text("拍攝日：20XX/XX/XX", style: textStyle), // 假資料
                    const SizedBox(height: 3),
                    Text("傷口類型：割傷", style: textStyle), // 假資料
                    const SizedBox(height: 3),
                    Text(
                      "換藥時間：${reminders[index]["selectedDay"]} "
                      "${reminders[index]["selectedHour"]}:${reminders[index]["selectedMinute"].toString().padLeft(2, '0')}",
                      style: textStyle,
                    ),
                    // const SizedBox(height: 10), // 設定間距
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -5, // 調整位置
          right: -5,
          child: IconButton(
            onPressed: () => toggleEditMode(index), // 切換為編輯模式
            icon: const Icon(Icons.edit,
                size: 18, color: Color.fromRGBO(53, 53, 53, 1)), // 設定圖示
          ),
        ),
      ],
    );
  }

  Widget _buildEditableView(int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(10), // 設定內距
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 圖片容器
              Container(
                padding: const EdgeInsets.all(5),
                child: _buildImage(),
              ),
              const SizedBox(width: 10),
              // 文字與選單
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("拍攝日：20XX/XX/XX", style: textStyle),
                      const SizedBox(height: 5),
                      Text("傷口類型：割傷", style: textStyle),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text('換藥頻率：', style: textStyle),
                          Flexible(
                            child: _buildDropdownButton2(
                              value: reminders[index]["selectedDay"] ?? '周一',
                              items: ['周一', '周二', '周三', '周四', '周五'],
                              onChanged: (newValue) =>
                                  updateDay(index, newValue!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      _buildEditableTimeFields(index),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Positioned 必須放在 Stack 內
        Positioned(
          top: -5,
          right: -5,
          child: IconButton(
            onPressed: () {
              if (index >= 0 && index < reminders.length) {
                toggleEditMode(index);
              }
            },
            icon: const Icon(
              Icons.check,
              size: 18,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableTimeFields(int index) {
    // 建立可編輯的時間選擇區塊
    return Row(
      children: [
        Text('換藥時間：', style: textStyle), // 顯示標籤「換藥時間」
        _buildTimeSelector(
          // 時間選擇器（小時）
          value: reminders[index]["selectedHour"], // 目前選擇的小時
          min: 0, // 最小值為 0
          max: 23, // 最大值為 23
          onChanged: (value) =>
              updateTime(index, "selectedHour", value), // 更新選擇的小時
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5), // 設定水平間距
          child: Text(':',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold)), // 顯示冒號（:）
        ),
        _buildTimeSelector(
          // 時間選擇器（分鐘）
          value: reminders[index]["selectedMinute"], // 目前選擇的分鐘
          min: 0, // 最小值為 0
          max: 59, // 最大值為 59
          onChanged: (value) =>
              updateTime(index, "selectedMinute", value), // 更新選擇的分鐘
        ),
      ],
    );
  }

  Widget _buildTimeSelector({
    // 建立時間選擇輸入框
    required int value, // 目前的數值
    required int min, // 最小值
    required int max, // 最大值
    required ValueChanged<int> onChanged, // 當使用者修改時觸發的函數
  }) {
    TextEditingController controller = // 建立控制器，並初始化數值（補零格式）
        TextEditingController(text: value.toString().padLeft(2, '0'));

    return Container(
      // 建立外框
      margin: const EdgeInsets.only(top: 5), // 設定上邊距
      width: 50, // 設定寬度
      decoration: BoxDecoration(
        // 設定框線裝飾
        borderRadius: BorderRadius.circular(15), // 設定圓角
        border: Border.all(color: const Color(0xFF589399)), // 設定邊框顏色
      ),
      child: TextField(
        // 建立文字輸入框
        controller: controller, // 綁定控制器
        keyboardType: TextInputType.number, // 設定為數字輸入
        textAlign: TextAlign.center, // 文字置中
        style: const TextStyle(fontSize: 14), // 設定字體大小
        decoration: const InputDecoration(
          // 設定輸入框樣式
          contentPadding: EdgeInsets.symmetric(vertical: 5), // 設定內邊距
          border: InputBorder.none, // 移除底線
        ),
        onSubmitted: (input) {
          // 當使用者輸入完成後執行
          int? newValue = int.tryParse(input); // 轉換輸入為數字
          if (newValue != null && newValue >= min && newValue <= max) {
            // 確保輸入數值在範圍內
            onChanged(newValue); // 更新數值
          } else {
            // 若輸入錯誤，則恢復原始數值
            controller.text = value.toString().padLeft(2, '0');
          }
        },
      ),
    );
  }

  Widget _buildDropdownButton2({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 30, // 頻率下拉選單的高度--加Container調整寬度
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10), // 設定內邊距
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), // 設定圓角
        border: Border.all(color: Color(0xFF589399)), // 設定邊框顏色
      ),
      child: DropdownButton<String>(
        value: value,
        dropdownColor: Colors.white, // 設定下拉選單背景色
        style: const TextStyle(color: Colors.red), // 選中項目的文字顏色
        isExpanded: true, // 讓選單展開時不會被擠壓
        underline: SizedBox.shrink(), // 移除底線
        items: items.map(
          (item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: textStyle, // 設定選項文字顏色
              ),
            );
          },
        ).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDeleteView(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min, // 讓 Row 只佔所需的空間
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 主要內容區塊
        Expanded(
          // 確保主要內容可以正確顯示
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF589399), width: 2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 傷口圖片
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 100, // 限制圖片大小
                    height: 100,
                    child: _buildImage(),
                  ),
                ),
                const SizedBox(width: 20), // 設定間距

                // 文字區塊
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("拍攝日：20XX/XX/XX", style: textStyle),
                      const SizedBox(height: 3),
                      Text("傷口類型：${reminders[index]["woundType"]}",
                          style: textStyle),
                      const SizedBox(height: 3),
                      Text(
                        "換藥時間：${reminders[index]["selectedDay"]} "
                        "${reminders[index]["selectedHour"]}:${reminders[index]["selectedMinute"].toString().padLeft(2, '0')}",
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 15), // 設定主要內容與按鈕的間距

        // 刪除按鈕區塊
        Container(
          width: 35,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: IconButton(
            onPressed: () {
              if (index >= 0 && index < reminders.length) {
                setState(() {
                  reminders.removeAt(index); // 移除對應索引的提醒
                });
              }
            },
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            padding: const EdgeInsets.all(5), // 減少內距，使按鈕更小
            constraints: const BoxConstraints(), // 移除默認的按鈕大小限制
          ),
        ),
      ],
    );
  }
}
