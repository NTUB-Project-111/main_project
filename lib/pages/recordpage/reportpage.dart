import 'package:flutter/material.dart';
import '../../feature/database.dart';
import '../headers/header_3.dart';
import '../resultpages/result_1.dart';

class ReportPage extends StatefulWidget {
  final Map<String, dynamic> record;
  const ReportPage({super.key, required this.record});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late List<dynamic> careSteps;
  late List<dynamic> tags;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    careSteps = widget.record['caremode']
        .replaceAll('[', '') // 移除左方括號
        .replaceAll(']', '') // 移除右方括號
        .split(',') // 用逗號切割字串
        .map((e) => e.trim()) // 去除每個元素前後的空格
        .toList();
    tags = widget.record['choosekind']
        .split(',') // 用逗號切割字串
        .map((e) => e.trim()) // 去除每個元素前後的空格
        .toList();
  }

  Widget _buildTagChip(List<dynamic> list) {
    return Wrap(
      children: list.map((text) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.only(right: 5), // 可以加上 margin 讓每個 Container 之間有間距
          decoration: BoxDecoration(
            color: const Color(0xFF589399),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      }).toList(), // 轉換為 List
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEBFEFF),
        body: Column(children: [
          const HeaderPage3(),
          ResultPage1(date: widget.record['date']),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Color(0xFF589399),
                        width: 2,
                      ))),
                      height: 230,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  Uri.parse(DatabaseHelper.baseUrl)
                                      .resolve(widget.record['photo'])
                                      .toString(),
                                  height: 180,
                                  width: 180,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          // const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    48, 4, 48, 4), //對稱的內間距，讓Container與裡面的子元素的上下間距為n，左右間距為m
                                decoration: BoxDecoration(
                                  color: const Color(0xFF589399).withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "傷口類型",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Text(
                                widget.record['type'],
                                style: const TextStyle(
                                  color: Color(0xFF589399),
                                  fontSize: 48,
                                ),
                              ),
                              SizedBox(
                                width: 180,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '預計',
                                      style: TextStyle(
                                        color: Color(0xFF589399),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      widget.record['oktime'],
                                      style: const TextStyle(
                                        color: Color(0xFF589399),
                                        fontSize: 26,
                                      ),
                                    ),
                                    const Text(
                                      '天癒合',
                                      style: TextStyle(
                                        color: Color(0xFF589399),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildCareSteps(careSteps),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '自我紀錄',
                          style: TextStyle(color: Color(0xFF589399), fontSize: 20, height: 3),
                        ),
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(color: Color(0x4D000000), blurRadius: 1)
                                ]),
                            child: tags.toString() != '[]' ? _buildTagChip(tags) : const SizedBox(height: 30,)),
                        Container(
                            width: double.infinity,
                            height: 250,
                            margin: const EdgeInsets.only(top: 15),
                            padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(color: Color(0x4D000000), blurRadius: 1)
                                ]),
                            child: Text(widget.record['recording'],
                                style: const TextStyle(color: Color(0xFF589399)))),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  Widget _buildCareSteps(List<dynamic> careSteps) {
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
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '傷口護理建議',
                          style: TextStyle(
                            height: 3,
                            color: Color(0xFF589399),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...List.generate(careSteps.length, (index) {
                    //前面的 ... 是 Dart 的展開運算子，將列表中的每個元素展開並直接插入到 Column 中。
                    return _buildSuggestionItem('${index + 1}', careSteps[index]);
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
