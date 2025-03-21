import 'package:flutter/material.dart';



class ResultPage5 extends StatefulWidget {
  const ResultPage5({super.key});

  @override
  State<ResultPage5> createState() => _ResultPage5State();
}

class _ResultPage5State extends State<ResultPage5> {
  final TextEditingController infoEditimg = TextEditingController();
  String? selectedTag;
  List<String> injuryParts = ["右手臂", "左手臂", "右腿", "左腿", "右腳", "左腳", "背部", "肩膀", "臀部", "臉部", "腹部"];
  List<String> woundReactions = ["紅腫", "疼痛", "出血", "發熱", "化膿"];
  List<String> selectedInjuryParts = [];
  List<String> selectedWoundReactions = [];
  bool _open = false;
  Icon icon = const Icon(
    Icons.arrow_drop_down_rounded,
    color: Color(0xFF589399),
    size: 30,
  );
  // 標籤顯示的 UI
  Widget _buildTagChip(String text, List<String> list) {
    return GestureDetector(
      onTap: () {
        setState(() {
          list.remove(text);
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
                  fontSize: 22,
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
                      icon = _open
                          ? const Icon(
                              Icons.arrow_drop_up_rounded,
                              color: Color(0xFF589399),
                              size: 30,
                            )
                          : const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Color(0xFF589399),
                              size: 30,
                            );
                    });
                  },
                  icon: icon,
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
                child: Expanded(
                  child: TextField(
                      controller: infoEditimg,
                      keyboardType: TextInputType.text,
                      maxLines: 10,
                      maxLength: 370,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Color(0xFFA5A1A1), fontSize: 13, height: 1.4),
                          hintText: '根據上面所選擇的標籤進行細項說明/撰寫自己當下發生的狀況/心情紀錄...等',
                          border: InputBorder.none)
                      // border: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Color(0x4D000000) )
                      // )),
                      ),
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
                                } else {
                                  selectedInjuryParts.remove(part);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15),

                      // 傷口反饋標題
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
                                } else {
                                  selectedWoundReactions.remove(reaction);
                                }
                              });
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

        ],
      ),
    );
  }
}
