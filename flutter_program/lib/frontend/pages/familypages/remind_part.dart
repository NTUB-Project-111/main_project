import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class RemindPart extends StatefulWidget {
  const RemindPart({super.key});

  @override
  State<RemindPart> createState() => _RemindPartState();
}

class _RemindPartState extends State<RemindPart> {
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4, // ✅ 原本 itemCount: 4
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildRemindSection(
            imageUrl: 'https://i.imgur.com/0vYJq8K.jpg',
            date: '20XX/XX/XX',
            type: '擦傷',
            time: '周一 – 18:30',
          ),
        ),
      ),
    );
  }

  /// ✅ 將卡片內容抽成共用方法
  Widget _buildRemindSection({
    required String imageUrl,
    required String date,
    required String type,
    required String time,
  }) {
    return Container(
      height: 115,
      padding: const EdgeInsets.only(left: 10),
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
                  width: 120,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                width: 120,
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
                  Text(
                    '角色：媽媽',
                    style: TextStyle(
                      fontSize: 13,
                      color: FrontUtil.textColor,
                      fontWeight: FontWeight.w500,
                    ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '換    藥 ：$time',
                        style: TextStyle(
                          fontSize: 13,
                          color: FrontUtil.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, size: 18, color: Color(0xFF525252)),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
