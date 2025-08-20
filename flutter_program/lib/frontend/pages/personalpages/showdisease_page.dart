// import 'package:drw/frontend/pages/personalpages/editdisease_page.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:drw/backend/provider/user_provider.dart';

// class ShowdiseasePage extends StatefulWidget {
//   const ShowdiseasePage({super.key});

//   @override
//   State<ShowdiseasePage> createState() => _ShowdiseasePageState();
// }

// class _ShowdiseasePageState extends State<ShowdiseasePage> {
//   bool showFavorites = false;
//   List<String> mainConditions = [];
//   List<String> compareList = [];
//   List<String> otherConditions = []; // 如果有需要可以初始化內容

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userProvider = context.read<UserProvider>();
//       final user = userProvider.user;
//       final disease = user!.disease.replaceAll("[", "").replaceAll("]", "");
//       mainConditions = disease.split(',').map((e) => e.trim()).toList();
//       compareList = List.from(mainConditions);
//       for (int i = 0; i < mainConditions.length; i++) {
//         otherConditions.remove(mainConditions[i]);
//       }
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     const Color backgroundColor = Color(0xFFE5F7F9);
//     const Color cardColor = Colors.white;
//     const Color textColor = Color(0xFF5A8A90);

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // AppBar 區域
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back, color: textColor),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     "特殊病症",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: textColor,
//                       height: 2,
//                     ),
//                   ),
//                   const Spacer(),
//                   const Icon(Icons.info_outline, color: textColor),
//                 ],
//               ),
//             ),

//             // 中間的卡片與編輯按鈕
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 40),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: cardColor,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 4,
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Consumer<UserProvider>(
//                         builder: (context, userProvider, _) {
//                           final user = userProvider.user; // 取得目前登入的 user
//                           return Text(
//                             user?.disease ?? "未設定", // 如果還沒設定，就顯示「未設定」
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: textColor,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: cardColor,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 4,
//                           // offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const EditDiseasePage(),
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.edit_square, color: textColor),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             const SizedBox(height: 16),
//             // 小熊護士圖片
//             Image.asset(
//               "images/nursebear.png",
//               height: 160,
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:drw/frontend/pages/personalpages/editdisease_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drw/backend/provider/user_provider.dart';

class ShowdiseasePage extends StatefulWidget {
  const ShowdiseasePage({super.key});

  @override
  State<ShowdiseasePage> createState() => _ShowdiseasePageState();
}

class _ShowdiseasePageState extends State<ShowdiseasePage> {
  List<String> mainConditions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      final user = userProvider.user;
      if (user != null && user.disease.isNotEmpty) {
        // 轉換成 ["癌症", "高血壓"] 格式
        final disease = user.disease.replaceAll("[", "").replaceAll("]", "");
        mainConditions = disease.split(',').map((e) => e.trim()).toList();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFE5F7F9);
    const Color cardColor = Colors.white;
    const Color textColor = Color(0xFF5A8A90);

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
                // padding: const EdgeInsets.symmetric(horizontal: 38),
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
                        itemCount: mainConditions.length + 1, // 多一個編輯按鈕
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
                                    color: Color(0xFF5A8A90),
                                    size: 24, // 也縮小
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
                                  color: Color(0xFF5A8A90),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            // 編輯按鈕 + 小熊護士圖片
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Container(
            //         width: 60,
            //         height: 60,
            //         decoration: BoxDecoration(
            //           color: cardColor,
            //           borderRadius: BorderRadius.circular(12),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withOpacity(0.05),
            //               blurRadius: 4,
            //             ),
            //           ],
            //         ),
            //         child: IconButton(
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => const EditDiseasePage(),
            //               ),
            //             );
            //           },
            //           icon: const Icon(Icons.edit_square, color: textColor),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
