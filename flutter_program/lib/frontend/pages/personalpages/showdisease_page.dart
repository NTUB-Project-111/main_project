import 'package:drw/frontend/pages/personalpages/editdisease_page.dart';
import 'package:drw/frontend/pages/personalpages/nodisease_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drw/backend/provider/user_provider.dart';

class ShowdiseasePage extends StatelessWidget {
  const ShowdiseasePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFE5F7F9);
    const Color textColor = Color(0xFF5A8A90);

    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    // 把 disease 轉換成 List<String>
    final List<String> mainConditions = (user == null || user.disease.isEmpty)
        ? []
        : user.disease
            .replaceAll("[", "")
            .replaceAll("]", "")
            .split(",")
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    if (mainConditions.isEmpty) {
      return const NoDiseasePage();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar 區域
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: textColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "特殊病症",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      height: 2,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.info_outline, color: textColor),
                ],
              ),
            ),

            // 疾病卡片 GridView
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(38, 20, 38, 70),
                child: mainConditions.isEmpty
                    ? const Center(
                        child: Text(
                          "尚未設定疾病",
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 每行 3 個
                          crossAxisSpacing: 35,
                          mainAxisSpacing: 35,
                          childAspectRatio: 1, // 1:1 方形
                        ),
                        itemCount: mainConditions.length + 1, // 疾病 + 編輯按鈕
                        itemBuilder: (context, index) {
                          if (index == mainConditions.length) {
                            // 編輯按鈕
                            return Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditDiseasePage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.edit_square,
                                    color: textColor,
                                    size: 24,
                                  ),
                                ),
                              ),
                            );
                          }

                          // 疾病卡片
                          final disease = mainConditions[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                disease,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            // 小熊護士圖片
            Center(
              child: Image.asset(
                "images/nursebear.png",
                height: 160,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
