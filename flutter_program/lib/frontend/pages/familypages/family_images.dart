import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class FamilyImagesPage extends StatefulWidget {
  final String title;
  const FamilyImagesPage({super.key, required this.title});

  @override
  State<FamilyImagesPage> createState() => _FamilyImagesPageState();
}

class _FamilyImagesPageState extends State<FamilyImagesPage> {
  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [
      // 'images/icon.png',
      // 'images/icon.png',
      // 'images/icon.png',
      // 'images/icon.png',
      // 'images/icon.png',
      // 'images/icon.png',
      // 'images/icon.png',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: FrontUtil.textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '家庭群組',
          style: TextStyle(color: FrontUtil.textColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 2.0,
            color: FrontUtil.textColor,
          ),
        ),
      ),
      body: Column(
        children: [
          // 日期區塊（帶漸層背景）
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD3F1F1), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF4E9A99),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 2,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 圖片網格
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [_buildImageGrid(imageUrls)],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<String> imageUrls) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        imageUrls.isEmpty
                            ? Container(
                                height: 180,
                                width: 160, //176
                                margin: const EdgeInsets.only(right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            : ClipRRect(
                                child: Image.network(
                                  '',
                                  fit: BoxFit.cover,
                                  height: 180,
                                  width: 160,
                                ),
                              ),
                        imageUrls.isEmpty
                            ? Container(
                                height: 104,
                                width: 160, //176
                                margin: const EdgeInsets.only(right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            : ClipRRect(
                                child: Image.network(
                                  '',
                                  fit: BoxFit.cover,
                                  height: 104,
                                  width: 160,
                                ),
                              ),
                        Row(
                          children: [
                            imageUrls.isEmpty
                                ? Container(
                                    height: 80,
                                    width: 73, //176
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10)),
                                  )
                                : ClipRRect(
                                    child: Image.network(
                                      '',
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: 73,
                                    ),
                                  ),
                            imageUrls.isEmpty
                                ? Container(
                                    height: 80,
                                    width: 73, //176
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10)),
                                  )
                                : ClipRRect(
                                    child: Image.network(
                                      '',
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: 73,
                                    ),
                                  ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    imageUrls.isEmpty
                        ? Container(
                            height: 89,
                            width: 80, //176
                            margin: const EdgeInsets.only(right: 10, bottom: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                          )
                        : ClipRRect(
                            child: Image.network(
                              '',
                              fit: BoxFit.cover,
                              height: 89,
                              width: 80,
                            ),
                          ),
                    imageUrls.isEmpty
                        ? Container(
                            height: 89,
                            width: 80, //176
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                          )
                        : ClipRRect(
                            child: Image.network(
                              '',
                              fit: BoxFit.cover,
                              height: 89,
                              width: 80,
                            ),
                          ),
                  ],
                ),
                imageUrls.isEmpty
                    ? Container(
                        height: 170,
                        width: 170, //176
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                      )
                    : ClipRRect(
                        child: Image.network(
                          '',
                          fit: BoxFit.cover,
                          height: 170,
                          width: 170,
                        ),
                      ),
                imageUrls.isEmpty
                    ? Container(
                        height: 105,
                        width: 170, //176
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                      )
                    : ClipRRect(
                        child: Image.network(
                          '',
                          fit: BoxFit.cover,
                          height: 105,
                          width: 170,
                        ),
                      ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            imageUrls.isEmpty
                ? Container(
                    height: 100,
                    width: 250, //176
                    margin: const EdgeInsets.only(bottom: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                  )
                : ClipRRect(
                    child: Image.network(
                      '',
                      fit: BoxFit.cover,
                      height: 100,
                      width: 250,
                    ),
                  ),
            imageUrls.isEmpty
                ? Container(
                    height: 100,
                    width: 80, //176
                    margin: const EdgeInsets.only(bottom: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                  )
                : ClipRRect(
                    child: Image.network(
                      '',
                      fit: BoxFit.cover,
                      height: 100,
                      width: 80,
                    ),
                  ),
          ],
        )
      ],
    );
  }
}
