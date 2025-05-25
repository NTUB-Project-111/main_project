import 'package:flutter/material.dart';
import 'package:wounddetection/feature/database.dart';
import '../../feature/healingtime.dart';

class ResultPage5 extends StatefulWidget {
  final Function(String) onDataChanged;
  final String woundtype;
  const ResultPage5({super.key, required this.woundtype, required this.onDataChanged});

  @override
  State<ResultPage5> createState() => _ResultPage5State();
}

class _ResultPage5State extends State<ResultPage5> {
  String? _healingTime;

  final TextEditingController infoEditimg = TextEditingController();
  String? selectedTag;
  List<String> injuryParts = [
    "右手",
    "左手",
    "右手臂",
    "左手臂",
    "右腿",
    "左腿",
    "右腳",
    "左腳",
    "頸部",
    "背部",
    "肩膀",
    "臀部",
    "臉部",
    "腹部"
  ];
  List<String> woundReactions = ["紅腫", "疼痛", "出血", "發熱", "化膿"];
  List<String> selectedInjuryParts = [];
  List<String> selectedWoundReactions = [];
  bool _open = false;
  bool isShow = false;
  bool _isLoading = false;
  Icon icon = const Icon(
    Icons.arrow_drop_down_rounded,
    color: Color(0xFF589399),
    size: 30,
  );
  void _updateHealingTime() {
    String oktime = _healingTime?.replaceAll("天", "") ?? "";
    DatabaseHelper.record['oktime'] = oktime;
    widget.onDataChanged(oktime); // 把資料回傳給 ResultPage
  }

  void _showButton() {
    setState(() {
      isShow = (infoEditimg.text.isNotEmpty ||
          selectedInjuryParts.isNotEmpty ||
          selectedWoundReactions.isNotEmpty);
    });
  }

  // 標籤顯示的 UI
  Widget _buildTagChip(String text, List<String> list) {
    return GestureDetector(
      onTap: () {
        setState(() {
          list.remove(text);
          _showButton();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF589399),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 5),
            const Icon(Icons.close, size: 15, color: Colors.white), // 點擊可移除
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '自我紀錄',
                style: TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 20,
                ),
              ),
              Text(
                '※選填',
                style: TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 1)]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (selectedInjuryParts.isEmpty && selectedWoundReactions.isEmpty)
                    ? const Text(
                        '選擇標籤說明',
                        style: TextStyle(
                          color: Color(0xFFA5A1A1),
                          fontSize: 13,
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10), // 確保上下有間距
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              ...selectedInjuryParts
                                  .map((part) => _buildTagChip(part, selectedInjuryParts)),
                              ...selectedWoundReactions.map(
                                  (reaction) => _buildTagChip(reaction, selectedWoundReactions)),
                            ],
                          ),
                        ),
                      ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _open = !_open;
                    });
                  },
                  icon: _open
                      ? const Icon(
                          Icons.arrow_drop_up_rounded,
                          color: Color(0xFF589399),
                          size: 30,
                        )
                      : const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Color(0xFF589399),
                          size: 30,
                        ),
                  padding: EdgeInsets.zero,
                )
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.fromLTRB(10, 0, 6, 0),
                height: 275,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 1)]),
                child: TextField(
                  controller: infoEditimg,
                  keyboardType: TextInputType.text,
                  maxLines: 10,
                  maxLength: 370,
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Color(0xFFA5A1A1), fontSize: 13, height: 1.4),
                      hintText: '詳細說明發生傷口狀態、造成原因、大小、深度，例如:由美工刀造成、大小約5公分、出血量不多',
                      border: InputBorder.none),
                  onChanged: (value) {
                    setState(() {
                      _showButton();
                      DatabaseHelper.record['recording'] = value;
                    });
                  }, // 每次輸入時更新資料
                ),
              ),
              Visibility(
                visible: _open,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromRGBO(154, 201, 205, 1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "受傷部位",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(88, 147, 153, 1),
                            height: 2 //行高加大
                            ),
                      ),
                      Wrap(
                        spacing: 7.5,
                        children: injuryParts.map((part) {
                          return ChoiceChip(
                            showCheckmark: false, //選取標籤時不要有打勾的效果
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: BorderSide.none,
                            selectedColor: const Color(0xFF589399),
                            backgroundColor: const Color.fromRGBO(224, 240, 241, 0.69),
                            label: Text(part),
                            selected: selectedInjuryParts.contains(part),
                            labelStyle: TextStyle(
                              color: selectedInjuryParts.contains(part)
                                  ? Colors.white
                                  : const Color.fromRGBO(88, 147, 153, 1), //選取時字體顏色
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedInjuryParts.add(part);
                                  DatabaseHelper.record['part'] = selectedInjuryParts;
                                } else {
                                  selectedInjuryParts.remove(part);
                                  DatabaseHelper.record['part'] = selectedInjuryParts;
                                }
                              });
                              _showButton();
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "傷口狀態",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(88, 147, 153, 1),
                            height: 2 //行高加大
                            ),
                      ),
                      Wrap(
                        spacing: 7.5,
                        children: woundReactions.map((reaction) {
                          return ChoiceChip(
                            showCheckmark: false, //選取標籤時不要有打勾的效果
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: BorderSide.none,
                            selectedColor: const Color(0xFF589399),
                            backgroundColor: const Color.fromRGBO(224, 240, 241, 0.69),
                            label: Text(reaction),
                            selected: selectedWoundReactions.contains(reaction),
                            labelStyle: TextStyle(
                              color: selectedWoundReactions.contains(reaction)
                                  ? Colors.white
                                  : const Color.fromRGBO(88, 147, 153, 1), //選取時字體顏色
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedWoundReactions.add(reaction);
                                  DatabaseHelper.record['rection'] = selectedWoundReactions;
                                } else {
                                  selectedWoundReactions.remove(reaction);
                                  DatabaseHelper.record['rection'] = selectedWoundReactions;
                                }
                              });
                              _showButton();
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (isShow && !_isLoading)
                    ? () async {
                        setState(() {
                          _isLoading = true;
                        });

                        _healingTime = await HealingTime.getOktime(
                          DatabaseHelper.record['type'].toString(),
                          selectedInjuryParts.toString(),
                          selectedWoundReactions.toString(),
                          infoEditimg.text,
                        );

                        _updateHealingTime();

                        setState(() {
                          _isLoading = false;
                        });
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    isShow ? const Color(0xFF589399) : const Color(0xFFBED7DA), //#BED7DA
                  ),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12),
                  ),
                  minimumSize: WidgetStateProperty.all(const Size(355, 0)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  _isLoading ? '分析中...' : (isShow ? '開始分析' : '填寫自我紀錄，獲取更精準的癒合時間'),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
