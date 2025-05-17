import 'package:flutter/material.dart'; // 引入 Flutter 的 UI 套件
import 'package:dropdown_button2/dropdown_button2.dart'; // 引入第三方下拉選單套件
import 'package:intl/intl.dart';
import '../feature/notifer.dart';
import '../my_flutter_app_icons.dart'; // 引入自訂義的圖示
import 'headers/header_1.dart'; // 引入標頭檔
import '../feature/database.dart';
import './tabs.dart';

class RemindPage extends StatefulWidget {
  // 定義一個可變狀態的頁面
  const RemindPage({super.key}); // 建構子，允許父元件傳遞 `key`

  @override
  State<RemindPage> createState() => _RemindPageState(); // 創建對應的狀態管理類別
}

class _RemindPageState extends State<RemindPage> with TickerProviderStateMixin {
  // `_RemindPageState` 負責處理頁面的狀態變更，`TickerProviderStateMixin` 用於動畫
  List<Map<String, dynamic>>? calls = DatabaseHelper.allCalls;
  List<Map<String, dynamic>> reminders = [];
  List<Map<String, dynamic>> userCalls =
      DatabaseHelper.remindRecords.map((e) => Map<String, dynamic>.from(e)).toList();
  // List<Map<String, dynamic>>? distinctCalls;
  List<Map<String, dynamic>> remindlist = [];
  List<bool> isSave = [];

  @override
  void initState() {
    super.initState();
    // debugPrint(userCalls?)
    if (userCalls.isNotEmpty) {
      print(userCalls);
      isSave = List.filled(userCalls.length, true);
      createReminders();
    }
  }

  void createReminders() {
    reminders = userCalls.where((call) => call["ifcall"] == "Y").map((call) {
      return {
        "date": call["date"],
        "type": call["type"],
        "img": call["photo"],
        "isPressed": false,
        "selectedFreq": call["freq"],
        "selectedHour": int.parse(call["time"].split(":")[0]),
        "selectedMinute": int.parse(call["time"].split(":")[1]),
        "isDeleteView": false,
        "ifcall": true
      };
    }).toList();
  }

  void toggleEditMode(int index) {
    // 切換是否為編輯模式
    setState(() {
      reminders[index]["isPressed"] = !reminders[index]["isPressed"]; // 取反 `isPressed`
    });
  }

  void updateTime(int index, String field, int value) {
    // 更新時間
    setState(() {
      reminders[index][field] = value; // 修改選定的時間（時或分）
      if (field == "selectedHour") {
        userCalls?[index]["time"] = "${value.toString()}:${reminders[index]["selectedMinute"]}";
      } else {
        userCalls?[index]["time"] = "${reminders[index]["selectedHour"]}:${value.toString()}";
      }
      if (DatabaseHelper.remindRecords[index]["time"] != userCalls?[index]["time"]) {
        isSave[index] = false;
      } else {
        debugPrint("database:${DatabaseHelper.remindRecords[index]["time"]}");
        debugPrint("usercalls:${userCalls?[index]["time"]}");
        isSave[index] = true;
      }
    });
  }

  void updateDay(int index, String newFreq) {
    // 更新換藥頻率
    setState(() {
      reminders[index]["selectedFreq"] = newFreq; // 修改選定的頻率
      userCalls?[index]["freq"] = newFreq;
      if (userCalls?[index]["freq"] != DatabaseHelper.remindRecords[index]["freq"]) {
        isSave[index] = false;
      } else {
        isSave[index] = true;
      }
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

  void _showConfirmationDialog(int index) {
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
          title: const Text(
            '確定要刪除此提醒?',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF589399),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          content: Row(
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  side: const BorderSide(
                    width: 2,
                    color: Color(0xFF589399),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
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
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  backgroundColor: const Color(0xFF589399),
                  side: BorderSide.none,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    reminders[index]["ifcall"] = false;
                    isSave[index] = true;
                  });
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
          )),
    );
  }

  void _showErrorDialog() {
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
          title: const Text(
            '尚有更動的資料未儲存\n確定要儲存嗎?',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF589399),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          content: Row(
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  side: const BorderSide(
                    width: 2,
                    color: Color(0xFF589399),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
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
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  backgroundColor: const Color(0xFF589399),
                  side: BorderSide.none,
                ),
                onPressed: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Tabs(
                                currentIndex: 0,
                              )));
                  _saveRemind();
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
          )),
    );
  }

  void _saveRemind() async {
    bool isChange = false;
    for (var usercall in userCalls) {
      //處理刪除的提醒
      if (usercall["ifcall"] == 'N') {
        await DatabaseHelper.updateRecord(
            usercall["id_record"].toString(), usercall["fk_userid"].toString(), 'N');
        await DatabaseHelper.deleteRemind(
            usercall["fk_userid"].toString(), usercall["id_record"].toString());
      }
      //處理更改的提醒
      for (var call in calls!) {
        if (call["fk_record_id"] == usercall["id_record"]) {
          if (call["freq"] != usercall["freq"]) {
            isChange = true;
            await DatabaseHelper.deleteRemind(
                //刪除舊提醒
                usercall["fk_userid"].toString(),
                usercall["id_record"].toString());
            _createRemind(
                usercall["date"], usercall["oktime"], usercall["freq"], usercall["time"]); //產生新提醒
            if (remindlist.isNotEmpty) {
              //將新提醒逐筆加入
              for (var remind in remindlist) {
                await DatabaseHelper.addRemind(
                    usercall["fk_userid"].toString(),
                    usercall["id_record"].toString(),
                    remind["day"],
                    remind["time"],
                    usercall["freq"]);
              }
            }
          } else if (call["time"] != usercall["time"]) {
            isChange = true;
            await DatabaseHelper.updateCallTime(usercall["id_record"].toString(),
                usercall["fk_userid"].toString(), usercall["time"]);
          }
          break;
        }
      }
    }
    if (isChange) {
      DatabaseHelper.allCalls = (await DatabaseHelper.getReminds()) ?? [];
      DatabaseHelper.remindRecords = (await DatabaseHelper.getRemindRecord()) ?? [];
      await Notifier.initialize();
      await Notifier.cancelAllReminders();
      Notifier.scheduleReminders(DatabaseHelper.allCalls);
    } else {
      print("資料未更改");
    }
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

  //產生新的護理提醒
  void _createRemind(String starttime, String oktime, String freq, String time) {
    late List<String> oktimelist;
    DateTime today = DateTime.now();
    oktimelist = oktime.split("~");
    if (oktimelist.length != 2) {
      debugPrint("oktime 格式錯誤: $oktime");
      return;
    }
    int okday = int.parse(oktimelist[1]);
    final freqMap = {
      "每天": 1,
      "兩天一次": 2,
      "三天一次": 3,
      "每週": 7,
    };
    final freqStr = freq;
    final freqDays = freqMap[freqStr] ?? 0;
    if (freqDays == 0) {
      debugPrint("無效的頻率: $freqStr");
      return;
    }

    List<String> parts = starttime.split('-');
    if (parts.length != 3) {
      debugPrint("日期格式錯誤: $starttime");
      return;
    }
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    DateTime startDate = DateTime(year, month, day);
    DateTime endDate = startDate.add(Duration(days: okday));
    DateTime remindDate = today.add(Duration(days: freqDays));

    while (!remindDate.isAfter(endDate)) {
      String formattedDay = DateFormat('yyyy-MM-dd').format(remindDate);
      remindlist.add({"day": formattedDay, "time": time});
      remindDate = remindDate.add(Duration(days: freqDays));
    }
    print(remindlist);
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
              MyFlutterApp.icon_park_solid__back, // 返回鍵圖示
              color: Color(0xFF589399), // 修改顏色
            ),
            onPressed: () async {
              if (isSave.contains(false)) {
                _showErrorDialog();
              } else if (isSave.isNotEmpty) {
                _saveRemind();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Tabs(
                              currentIndex: 0,
                            )));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Tabs(
                              currentIndex: 0,
                            )));
              }

              // Navigator.pop(context);
            }),
        title: const Text(
          "護理提醒",
          style: TextStyle(
            fontSize: 18, // 更改字體大小
            color: Color(0xFF589399), // 更改字體顏色
            fontWeight: FontWeight.bold, // 設定字體粗細
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // 移除預設陰影
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFF589399), // 設定底線顏色
            height: 2, // 設定底線高度
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
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
          separatorBuilder: (context, index) => const SizedBox(height: 0), // 設定間距
          itemBuilder: (context, index) {
            return reminders[index]["ifcall"]
                ? reminders[index]["isDeleteView"]
                    ? _buildDeleteView(index)
                    : Container(
                        margin: const EdgeInsets.only(bottom: 15),
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
                      )
                : Container();
          },
        ),
      ),
    );
  }

//傷口照片放置區
  Widget _buildImage(String img) {
    // 建立顯示圖片的區塊
    return ClipRRect(
      // 使用 ClipRRect 來創建圓角矩形
      borderRadius: BorderRadius.circular(20), // 設定圓角
      child: Container(
        // 建立一個容器來模擬圖片
        width: 90,
        height: 90,
        color: Colors.grey, // 設定背景顏色為灰色（預設圖片）
        child: Image.network(
          Uri.parse(DatabaseHelper.baseUrl).resolve(img).toString(),
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  final TextStyle textStyle = const TextStyle(fontSize: 13, color: Color(0xFF2e6d74));

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
              _buildImage(reminders[index]["img"]), // 呼叫 `_buildImage()` 生成圖片區塊
              const SizedBox(width: 20), // 設定間距
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 左對齊
                  children: [
                    Text("拍攝日：${reminders[index]["date"]}", style: textStyle), // 假資料
                    const SizedBox(height: 3),
                    Text("傷口類型：${reminders[index]["type"]}", style: textStyle), // 假資料
                    const SizedBox(height: 3),
                    Text(
                      "換藥時間：${reminders[index]["selectedFreq"]} "
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
            icon: const Icon(Icons.edit, size: 18, color: Color.fromRGBO(53, 53, 53, 1)), // 設定圖示
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
                child: _buildImage(reminders[index]["img"]),
              ),
              const SizedBox(width: 10),
              // 文字與選單
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("拍攝日：${reminders[index]["date"]}", style: textStyle),
                      const SizedBox(height: 5),
                      Text("傷口類型：${reminders[index]["type"]}", style: textStyle),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text('換藥頻率：', style: textStyle),
                          Flexible(
                            child: _buildDropdownButton2(
                              value: reminders[index]["selectedFreq"] ?? '每天',
                              items: ['每天', '兩天一次', '三天一次', '每週'],
                              onChanged: (newValue) => updateDay(index, newValue!),
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
              isSave[index] = true;
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
          onChanged: (value) => updateTime(index, "selectedHour", value), // 更新選擇的小時
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5), // 設定水平間距
          child: Text(':', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // 顯示冒號（:）
        ),
        _buildTimeSelector(
          // 時間選擇器（分鐘）
          value: reminders[index]["selectedMinute"], // 目前選擇的分鐘
          min: 0, // 最小值為 0
          max: 59, // 最大值為 59
          onChanged: (value) => updateTime(index, "selectedMinute", value), // 更新選擇的分鐘
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
      height: 30,
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xFF589399)),
      ),
      child: DropdownButton2<String>(
        alignment: Alignment.center,
        value: value,
        // dropdownDirection: DropdownDirection.down, // 指定向下展開
        dropdownStyleData: DropdownStyleData(
          width: 150,
          elevation: 0, //無陰影
          offset: const Offset(-10, -1),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF589399)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
        ),
        isExpanded: true,
        underline: const SizedBox.shrink(),
        style: const TextStyle(color: Colors.red),
        items: items.map(
          (item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: textStyle,
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
            margin: const EdgeInsets.only(bottom: 15),
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
                    width: 90, // 限制圖片大小
                    height: 90,
                    child: _buildImage(reminders[index]["img"]),
                  ),
                ),
                const SizedBox(width: 20), // 設定間距

                // 文字區塊
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("拍攝日：${reminders[index]["date"]}", style: textStyle),
                      const SizedBox(height: 3),
                      Text("傷口類型：${reminders[index]["type"]}", style: textStyle),
                      const SizedBox(height: 3),
                      Text(
                        "換藥時間：${reminders[index]["selectedFreq"]} "
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
                _showConfirmationDialog(index);
                setState(() {
                  // reminders.removeAt(index); // 移除對應索引的提醒
                  // reminders[index]["ifcall"] = 'N';
                  userCalls?[index]['ifcall'] = 'N';
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
