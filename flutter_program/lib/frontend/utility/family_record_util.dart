import 'package:flutter/material.dart';

class FamilyRecordCard extends StatelessWidget {
  final String imageUrl; // 圖片路徑或網路連結
  final String date; // 拍攝日
  final String woundType; // 傷口類型
  final String role; // 角色分類文字

  const FamilyRecordCard({
    Key? key,
    required this.imageUrl,
    required this.date,
    required this.woundType,
    required this.role,
  }) : super(key: key);

  // 根據角色決定顏色
  Color _getRoleColor(String role) {
    switch (role) {
      case '爺':
        return const Color(0xFF8D6E63); // 棕灰色
      case '奶':
        return const Color(0xFF8D6E63); // 棕灰色
      case '爸':
        return const Color.fromARGB(255, 254, 212, 255); // 藍灰色
      case '媽':
        return const Color.fromARGB(255, 254, 212, 255); // 藍灰色
      case '姐':
        return const Color.fromARGB(255, 208, 179, 255); // 淡紫色
      case '妹':
        return const Color.fromARGB(255, 208, 179, 255); // 淡紫色
      case '哥':
        return const Color.fromARGB(255, 197, 236, 255); // 淺藍色
      case '弟':
        return const Color.fromARGB(255, 197, 236, 255); // 淺藍色
      default:
        return const Color(0xFFB0BEC5); // 預設灰藍
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, // 固定寬度
      child: Stack(
        children: [
          Card(
            elevation: 4,
            color: const Color(0xFFDCDCDC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1, // 圖片方形
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[400],
                              child: const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '拍攝日：$date',
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '傷口類型：$woundType',
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: _getRoleColor(role),
              child: Text(
                role,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
