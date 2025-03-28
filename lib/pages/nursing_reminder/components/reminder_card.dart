import 'package:flutter/material.dart';
import './wound_info_card.dart'; // 確保路徑正確

class ReminderCard extends StatelessWidget {
  final String imageUrl;
  final String date;
  final String woundType;
  final String medicationTime;

  const ReminderCard({
    super.key,
    required this.imageUrl,
    required this.date,
    required this.woundType,
    required this.medicationTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 120), // 設定最小高度
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: const Color(0xFF589399), width: 2),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // 設定圓角
            child: Image.network(
              imageUrl,
              width: 102,
              height: 102,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 102, color: Colors.red);
              },
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '拍攝日：$date',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E6D74),
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '傷口類型：$woundType',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E6D74),
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '換藥：$medicationTime',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E6D74),
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight, // 讓按鈕靠右下角
            child: TextButton(
              onPressed: () {
                _showEditDialog(context); // 點擊按鈕後，彈出 WoundInfoCard
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // 移除內邊距，讓按鈕更貼合內容
                minimumSize: Size(0, 0), // 確保不會產生額外間距
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 避免額外大小
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // 讓 Row 根據內容縮小
                children: [
                  Image.asset('images/icon/edit.png', width: 19, height: 19),
                  const SizedBox(width: 1),
                  const Text(
                    '編輯',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF525252),
                      letterSpacing: 0.65,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 彈出 WoundInfoCard 來編輯換藥時間
  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return WoundInfoCard(
          date: date,
          woundType: woundType,
          medicationTime: medicationTime,
        );
      },
    );
  }
}
