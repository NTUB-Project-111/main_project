import 'package:drw/backend/services/record_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // <-- 引入輪播套件

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final RecordService recordService = RecordService();
  final TextEditingController adviceController = TextEditingController();

  bool isLoading = false;
  List<String> imageUrls = []; // 存多張圖片
  int currentIndex = 0; // 當前輪播索引

  @override
  void dispose() {
    adviceController.dispose();
    super.dispose();
  }

  Future<void> _generateImages() async {
    if (adviceController.text.isEmpty) return;

    setState(() {
      isLoading = true;
      imageUrls = [];
      currentIndex = 0;
    });

    final steps = adviceController.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final results = await recordService.generateImages(steps);

    setState(() {
      isLoading = false;
      imageUrls = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final steps = adviceController.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("生成護理圖片")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: adviceController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "輸入護理步驟（每行一個）",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateImages,
              child: const Text("生成圖片"),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else if (imageUrls.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    // 輪播圖
                    CarouselSlider.builder(
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index, realIndex) {
                        return Column(
                          children: [
                            Text(
                              "步驟 ${index + 1}：${steps[index]}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        height: 400,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 頁面指示器
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageUrls.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentIndex == entry.key
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
