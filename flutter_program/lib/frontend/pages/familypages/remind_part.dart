import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class RemindPart extends StatefulWidget {
  const RemindPart({super.key});

  @override
  State<RemindPart> createState() => _RemindPartState();
}

class _RemindPartState extends State<RemindPart> {
  /// 每張卡的編輯狀態
  final List<bool> isEditingList = List.filled(4, false);

  /// 每張卡的頻率選擇
  final List<String> selectedFreqList = List.filled(4, '每天');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildRemindSection(
            index: index,
            imageUrl: 'https://i.imgur.com/0vYJq8K.jpg',
            date: '2025/10/20',
            type: '擦傷',
            time: '2025/10/21 18:30',
          ),
        ),
      ),
    );
  }

  Widget _buildRemindSection({
    required int index,
    required String imageUrl,
    required String date,
    required String type,
    required String time,
  }) {
    bool isEditing = isEditingList[index];
    String selectedFreq = selectedFreqList[index];

    return Container(
      // height: 115,
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FrontUtil.textColor, width: 2),
      ),
      child: Row(
        children: [
          // 左側圖片
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              imageUrl,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: 92,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                width: 92,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),

          // 右側文字區
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isEditing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '角色：媽媽',
                              style: TextStyle(
                                fontSize: 13,
                                color: FrontUtil.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() {
                                isEditingList[index] = false;
                              }),
                              icon: const Icon(Icons.check,
                                  size: 18, color: Colors.red),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '角色：媽媽',
                              style: TextStyle(
                                fontSize: 13,
                                color: FrontUtil.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() {
                                isEditingList[index] = true;
                              }),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit,
                                      size: 18, color: Color(0xFF525252)),
                                  SizedBox(width: 4),
                                  Text(
                                    '編輯',
                                    style: TextStyle(
                                      color: Color(0xFF525252),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 3),
                  Text(
                    '拍攝日：$date',
                    style: TextStyle(
                      fontSize: 13,
                      color: FrontUtil.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '傷口類型：$type',
                    style: TextStyle(
                      fontSize: 13,
                      color: FrontUtil.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // 編輯模式 vs 顯示模式
                  isEditing
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '換藥頻率：',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: FrontUtil.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Flexible(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      value: selectedFreq,
                                      items: ['每天', '兩天一次', '三天一次', '每週']
                                          .map((day) => DropdownMenuItem<String>(
                                                value: day,
                                                child: Text(
                                                  day,
                                                  style: const TextStyle(
                                                      color: Color(0xFF589399),
                                                      fontSize: 14),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (value) => setState(() {
                                        selectedFreqList[index] = value!;
                                      }),
                                      buttonStyleData: ButtonStyleData(
                                        height: 30,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFF669FA5)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                        ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        elevation: 0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: const Color(0xFF669FA5)),
                                          color: Colors.white,
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(height: 40),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '換藥時間 ：',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: FrontUtil.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                _buildTimeBox('18'),
                                const Text(
                                  ' : ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF264E5C),
                                  ),
                                ),
                                _buildTimeBox('30'),
                              ],
                            )
                          ],
                        )
                      : Text(
                          '換藥日 ：$time',
                          style: TextStyle(
                            fontSize: 13,
                            color: FrontUtil.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String text) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF669FA5)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF264E5C),
          ),
        ),
      );
}
