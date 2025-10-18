import 'package:flutter/material.dart';

class ReportImagePart extends StatefulWidget {
  const ReportImagePart({super.key});

  @override
  State<ReportImagePart> createState() => _ReportImagePartState();
}

class _ReportImagePartState extends State<ReportImagePart> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('最新報告', () {
          // 點擊更多按鈕的處理
        }),
        _buildImageSection([]),
        _buildSectionTitle('歷史報告', () {
          // 點擊更多按鈕的處理
        }),
        _buildImageSection([]),
      ],
    ));
  }

  static Widget _buildSectionTitle(String title, VoidCallback onMorePressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          InkWell(
            onTap: onMorePressed,
            child: const Text(
              '更多 >',
              style: TextStyle(color: Colors.teal),
            ),
          )
        ],
      ),
    );
  }

  static Widget _buildImageSection(List<String> imagePaths) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 8),
      child: Row(
        children: [
          imagePaths.isEmpty
              ? Container(
                  color: Colors.grey[200],
                  height: 220,
                  width: 159,//176
                  margin: const EdgeInsets.only(right: 10),
                )
              : Image.network(
                  '',
                  fit: BoxFit.cover,
                  height: 220,
                  width: 159,
                  
                ),
          Column(
            children: [
              imagePaths.isEmpty
                  ? Container(
                      color: Colors.grey[200],
                      height: 105,
                      width: 159,
                      margin: const EdgeInsets.only(bottom: 10),
                    )
                  : Image.network(
                      '',
                      fit: BoxFit.cover,
                      height: 105,
                      width: 159,
                    ),
              Row(
                children: [
                  imagePaths.isEmpty
                      ? Container(
                          color: Colors.grey[200],
                          height: 105,
                          width: 74,//83
                          margin: const EdgeInsets.only(right: 10),
                        )
                      : Image.network(
                          '',
                          fit: BoxFit.cover,
                          height: 105,
                          width: 74,
                        ),
                  imagePaths.isEmpty
                      ? Container(
                          color: Colors.grey[200],
                          height: 105,
                          width: 74,
                        )
                      : Image.network(
                          '',
                          fit: BoxFit.cover,
                          height: 105,
                          width: 74,)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
