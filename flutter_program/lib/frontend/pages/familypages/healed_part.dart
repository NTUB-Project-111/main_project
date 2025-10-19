import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class HealedPart extends StatefulWidget {
  const HealedPart({super.key});

  @override
  State<HealedPart> createState() => _HealedPartState();
}

class _HealedPartState extends State<HealedPart> {
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('2025年 9月', () {
          // 點擊更多按鈕的處理
        }),
        _buildImageSection([]),
        _buildSectionTitle('2025年 8月', () {
          // 點擊更多按鈕的處理
        }),
        _buildImageSection([]),
      ],
    ));
  }

  static Widget _buildSectionTitle(String title, VoidCallback onMorePressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 10, 0),
      child: Row(
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text('更多', style: TextStyle(color: FrontUtil.textColor)),
                  Icon(Icons.arrow_forward_ios, size: 12, color: FrontUtil.textColor),
                ],
              ))
        ],
      ),
    );
  }

  static Widget _buildImageSection(List<String> imagePaths) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
      child: Row(
        children: [
          imagePaths.isEmpty
              ? Container(
                  height: 220,
                  width: 159, //176
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                )
              : ClipRRect(
                  child: Image.network(
                    '',
                    fit: BoxFit.cover,
                    height: 220,
                    width: 159,
                  ),
                ),
          Column(
            children: [
              imagePaths.isEmpty
                  ? Container(
                      height: 105,
                      width: 159,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    )
                  : ClipRRect(
                      child: Image.network(
                        '',
                        fit: BoxFit.cover,
                        height: 105,
                        width: 159,
                      ),
                    ),
              Row(
                children: [
                  imagePaths.isEmpty
                      ? Container(
                          height: 105,
                          width: 74, //83
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                        )
                      : ClipRRect(
                          child: Image.network(
                            '',
                            fit: BoxFit.cover,
                            height: 105,
                            width: 74,
                          ),
                        ),
                  imagePaths.isEmpty
                      ? Container(
                          height: 105,
                          width: 74,
                          decoration: BoxDecoration(
                              color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                        )
                      : ClipRRect(
                          child: Image.network(
                            '',
                            fit: BoxFit.cover,
                            height: 105,
                            width: 74,
                          ),
                        )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
