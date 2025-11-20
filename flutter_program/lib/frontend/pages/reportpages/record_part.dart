import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:drw/backend/provider/family_provider.dart';
import 'package:drw/backend/viewmodels/report_view_model.dart';
import 'package:drw/backend/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordPart extends StatefulWidget {
  const RecordPart({super.key});

  @override
  State<RecordPart> createState() => _RecordPartState();
}

class _RecordPartState extends State<RecordPart> {
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
  final TextEditingController _selfRecord = TextEditingController();
  List<String> items = [];
  String? selectedValue = '姊姊';
  int index = 0;

  @override
  void initState() {
    super.initState();
    final familyProvider = context.read<FamilyProvider>();
    final members = familyProvider.members;
    for (var member in members) {
      items.add(member.role);
    }
    // report.setMemberId(member.userId);
    selectedValue = members[0].role;
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Report>(builder: (context, report, _) {
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
                  style: TextStyle(color: Color(0xFF589399), fontSize: 20, height: 3),
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
            Row(
              children: [
                const Text(
                  '傷口主人',
                  style: TextStyle(
                    color: Color(0xFF589399),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const Spacer(),
                const SizedBox(width: 30),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      value: selectedValue,
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    color: Color(0xFF5A9A9A),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                        report.setRole(value!);
                        final familyProvider = context.read<FamilyProvider>();
                        final members = familyProvider.members;
                        // for (var member in members) {
                        //   if (member.role == report.role) {
                        //     report.setMemberId(member.userId);
                        //   }
                        // }
                        for (int i = 0; i < members.length; i++) {
                          if (members[i].role == report.role) {
                            report.setMemberId(members[i].memberId);
                            index = i;
                          }
                        }
                        debugPrint('=====角色id$index=====');
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF5A9A9A)),
                        iconSize: 30,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        elevation: 1,
                        maxHeight: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                )
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
                  (report.injuryParts.isEmpty && report.woundReactions.isEmpty)
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
                                ...report.injuryParts
                                    .map((part) => _buildTagChip(part, report.injuryParts, report)),
                                ...report.woundReactions.map((reaction) =>
                                    _buildTagChip(reaction, report.woundReactions, report)),
                              ],
                            ),
                          ),
                        ),
                  IconButton(
                    onPressed: () {
                      report.toggleOpen();
                    },
                    icon: report.open
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
                    controller: _selfRecord,
                    keyboardType: TextInputType.text,
                    maxLines: 10,
                    maxLength: 100,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Color(0xFFA5A1A1), fontSize: 13, height: 1.4),
                        hintText: '詳細說明發生傷口狀態、造成原因、大小、深度，例如:由美工刀造成、大小約5公分、出血量不多',
                        border: InputBorder.none),
                    onChanged: (value) {
                      report.setSelfRecord(value);
                      report.toggleUpdateButton();
                    }, // 每次輸入時更新資料
                  ),
                ),
                Visibility(
                  visible: report.open,
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
                              selected: report.injuryParts.contains(part),
                              labelStyle: TextStyle(
                                color: report.injuryParts.contains(part)
                                    ? Colors.white
                                    : const Color.fromRGBO(88, 147, 153, 1), //選取時字體顏色
                              ),
                              onSelected: (bool selected) {
                                report.setInjuryParts(selected, part);
                                report.toggleUpdateButton();
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
                              selected: report.woundReactions.contains(reaction),
                              labelStyle: TextStyle(
                                color: report.woundReactions.contains(reaction)
                                    ? Colors.white
                                    : const Color.fromRGBO(88, 147, 153, 1), //選取時字體顏色
                              ),
                              onSelected: (bool selected) {
                                report.setWoundReactions(selected, reaction);
                                report.toggleUpdateButton();
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
                  onPressed: (report.updateButton && !report.isUpdating)
                      ? () async {
                          final familyProvider =
                              Provider.of<FamilyProvider>(context, listen: false);
                          final members = familyProvider.members;
                          report.updateOktime(members[index].birthyear.toString(),
                              members[index].disease, members[index].freq);
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      report.updateButton ? const Color(0xFF589399) : const Color(0xFFBED7DA),
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
                    report.isUpdating
                        ? '分析中...'
                        : (report.updateButton ? '開始分析' : '填寫自我紀錄，獲取更精準的癒合時間'),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ))
          ],
        ),
      );
    });
  }

  Widget _buildTagChip(String text, List<String> list, Report report) {
    return GestureDetector(
      onTap: () {
        setState(() {
          list.remove(text);
          report.toggleUpdateButton();
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
}
