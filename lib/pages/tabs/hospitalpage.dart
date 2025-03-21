import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});

  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  final List<String> cities = [
    '臺北市',
    '新北市',
    '桃園市',
    '臺中市',
    '臺南市',
    '高雄市',
  ];

  final List<String> districts = [
    '大安區',
    '中正區',
    '信義區',
    '板橋區',
    '中和區',
    '永和區',
  ];

  final List<String> medicalDepartments = [
    '急診',
    '內科',
    '外科',
    '骨科',
    '皮膚科',
    '耳鼻喉科',
    '眼科',
  ];

  // 狀態變數：每個選單擁有獨立的選擇值
  String? selectedCity;
  String? selectedDistrict;
  String? selectedDepartment;

  bool _open = false;
  Icon _icon = const Icon(Icons.search,color: Color(0xFF589399));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:const EdgeInsets.fromLTRB(26, 36, 14, 5),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF589399),
                width: 2,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "附近醫院",
                    style: TextStyle(
                      color: Color(0xFF589399),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _icon = _open? const Icon(Icons.search,color: Color(0xFF589399)):const Icon(Icons.clear,color: Color(0xFF589399));
                        _open = !_open;
                        
                      });
                    },
                    icon: _icon
                  ),
                ],
              ),
              Visibility(
                visible: _open,
                child: Column(
                  children: [
                    _buildSearchItem(
                      "縣市",
                      cities,
                      selectedCity,
                      (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                    ),
                    // 第二個下拉選單：地區
                    _buildSearchItem(
                      "地區",
                      districts,
                      selectedDistrict,
                      (value) {
                        setState(() {
                          selectedDistrict = value;
                        });
                      },
                    ),
                    // 第三個下拉選單：醫療科別
                    _buildSearchItem(
                      "醫療科別",
                      medicalDepartments,
                      selectedDepartment,
                      (value) {
                        setState(() {
                          selectedDepartment = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // 查詢按鈕的邏輯
                          print("縣市：$selectedCity");
                          print("地區：$selectedDistrict");
                          print("醫療科別：$selectedDepartment");
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFF589399),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(0, 30),
                        ),
                        child: const Text(
                          '查詢',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: 0.75,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 第一個下拉選單：縣市
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchItem(
    String title,
    List<String> items, // 接受動態的選單內容
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.symmetric(
            vertical: 7,
            horizontal: 28,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromRGBO(154, 201, 205, 1),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(88, 147, 153, 1),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              alignment: Alignment.center,
              isExpanded: true,
              hint: const Row(
                children: [
                  Expanded(
                    child: Text(
                      '----- 請選擇 -----',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 12,
                        color: Color(0xFFAEAEAE),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: items
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Color.fromRGBO(88, 147, 153, 1),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: onChanged,
              buttonStyleData: ButtonStyleData(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
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
                iconSize: 35,
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
        ),
      ],
    );
  }
}
