import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class FamilyRecordCard extends StatelessWidget {
  final String imageUrl; // 圖片路徑或網路連結
  final String date; // 拍攝日
  final String woundType; // 傷口類型
  final String role; // 角色分類文字

  const FamilyRecordCard({
    super.key,
    required this.imageUrl,
    required this.date,
    required this.woundType,
    required this.role,
  });

  // 根據角色決定顏色
  Color _getRoleColor(String role) {
    switch (role) {
      case '爺':
        return const Color(0xFF8D6E63); // 棕灰色
      case '奶':
        return const Color(0xFF8D6E63); // 棕灰色
      case '爸':
        return const Color.fromARGB(255, 119, 87, 119);
      case '媽':
        return const Color.fromARGB(255, 119, 87, 119);
      case '姐':
      case '姊':
        return const Color.fromARGB(255, 217, 168, 204);
      case '妹':
        return const Color.fromARGB(255, 217, 168, 204);
      case '哥':
        return const Color.fromARGB(255, 163, 189, 228);
      case '弟':
        return const Color.fromARGB(255, 163, 189, 228);
      default:
        return const Color(0xFFB0BEC5); // 預設灰藍
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Stack(
        clipBehavior: Clip.none, // ✅ 允許超出邊界
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF90A4AE).withOpacity(0.3), // 💡柔藍灰陰影
                  blurRadius: 8,
                  offset: const Offset(2, 4), // 陰影方向與距離
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              color: const Color.fromARGB(255, 248, 254, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : Container(
                                color: const Color.fromARGB(255, 146, 146, 146),
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 36,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // 改為不使用 Flexible（在未被限制的 Column 中可能會導致 overflow）
                    Text(
                      '拍攝日：$date',
                      style: TextStyle(fontSize: 12, color: FrontUtil.textColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '類型：$woundType',
                      style: TextStyle(fontSize: 12, color: FrontUtil.textColor),
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [

                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),

          // 右上角，角色標籤
          Positioned(
            top: -6, // 向上凸出
            right: -6, // 向右凸出
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 163, 193, 209).withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white, // ✅ 外層白邊
                child: CircleAvatar(
                  radius: 14, // 內層顏色圈稍微小一點
                  backgroundColor: _getRoleColor(role),
                  child: Text(
                    role,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
