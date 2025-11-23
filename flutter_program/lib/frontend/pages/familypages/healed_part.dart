import 'package:drw/frontend/pages/familypages/family_images.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class HealedPart extends StatefulWidget {
  const HealedPart({super.key});

  @override
  State<HealedPart> createState() => _HealedPartState();
}

class _HealedPartState extends State<HealedPart> {
  bool isEditing = false;

  /// 成員選擇狀態
  int selectedMember = 0;

  /// 成員資料
  final List<Map<String, String>> members = [
    {"name": "媽媽", "image": "images/register_icon.png"},
    {"name": "爸爸", "image": "images/register_icon.png"},
    {"name": "爺爺", "image": "images/register_icon.png"},
    {"name": "奶奶", "image": "images/register_icon.png"},
    {"name": "哥哥", "image": "images/register_icon.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// -------------------------
            /// 成員選擇卡片
            /// -------------------------
            _buildMemberSelector(),

            const SizedBox(height: 10),

            /// -------------------------
            /// 2025年 9月
            /// -------------------------
            _buildSectionTitle('2025年 9月', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FamilyImagesPage(
                    title: '2025年9月_已癒合',
                  ),
                ),
              );
            }),

            _buildImageSection([]),

            /// -------------------------
            /// 2025年 8月
            /// -------------------------
            _buildSectionTitle('2025年 8月', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FamilyImagesPage(
                    title: '2025年8月_已癒合',
                  ),
                ),
              );
            }),

            _buildImageSection([]),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 成員卡片列
  // ===========================================================================
  Widget _buildMemberSelector() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: members.length,
        padding: const EdgeInsets.symmetric(vertical: 6), // 左右一致
        itemBuilder: (context, index) {
          bool isSelected = index == selectedMember;

          return SizedBox(
            width: MediaQuery.of(context).size.width / 3 - 25,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedMember = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE0F2F3) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      members[index]["image"]!,
                      width: 55,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      members[index]["name"]!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF669FA5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// ===========================================================================
// 標題列 + 更多按鈕
// ===========================================================================

  Widget _buildSectionTitle(String title, VoidCallback onMorePressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 用 spaceBetween
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onMorePressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // 不要多餘 padding
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text('更多', style: TextStyle(color: FrontUtil.textColor)),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: FrontUtil.textColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 圖片區塊（左大 + 右三小）
  // ===========================================================================
  Widget _buildImageSection(List<String> images) {
    List<String?> list =
        List<String?>.generate(4, (i) => i < images.length ? images[i] : null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageBox(list[0],
              width: 160,
              height: 220,
              margin: const EdgeInsets.only(right: 10)),
          Column(
            children: [
              _imageBox(list[1],
                  width: 160,
                  height: 106,
                  margin: const EdgeInsets.only(bottom: 8)),
              Row(
                children: [
                  _imageBox(list[2],
                      width: 77,
                      height: 106,
                      margin: const EdgeInsets.only(right: 6)),
                  _imageBox(list[3], width: 77, height: 106),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // ------------------------------
  // 單張圖片（含 placeholder）
  // ------------------------------
  Widget _imageBox(
    String? url, {
    required double width,
    required double height,
    EdgeInsets margin = EdgeInsets.zero,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        image: url != null
            ? DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}
