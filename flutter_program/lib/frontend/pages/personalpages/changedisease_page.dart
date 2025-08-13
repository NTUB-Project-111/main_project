// import 'package:flutter/material.dart';

// class ChangediseasePage extends StatefulWidget {
//   const ChangediseasePage({super.key});

//   @override
//   State<ChangediseasePage> createState() => _ChangediseasePageState();
// }

// class _ChangediseasePageState extends State<ChangediseasePage> {
//   bool showFavorites = false;
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
//                     "特殊症狀",
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

//             // const SizedBox(height: 30),

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
//                           // offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text(
//                         "高血壓",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: textColor,
//                           fontWeight: FontWeight.bold,
//                         ),
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
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             showFavorites = !showFavorites;
//                           });
//                         },
//                         icon: const Icon(Icons.add_circle, color: textColor)),
//                   ),
//                 ],
//               ),
//             ),

//             const Spacer(),

//             // 小熊護士圖片
//             Image.asset(
//               "images/nursebear.png",
//               height: 150,
//             ),

//             const SizedBox(height: 60),
//             // 收藏列表

//           ],

//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ChangediseasePage extends StatefulWidget {
  const ChangediseasePage({super.key});

  @override
  State<ChangediseasePage> createState() => _ChangediseasePageState();
}

class _ChangediseasePageState extends State<ChangediseasePage> {
  bool showFavorites = false;

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFE5F7F9);
    const Color cardColor = Colors.white;
    const Color textColor = Color(0xFF5A8A90);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
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
                    "特殊症狀",
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

            // 中間的卡片與編輯按鈕
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "高血壓",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          showFavorites = !showFavorites;
                        });
                      },
                      icon: const Icon(Icons.add_circle, color: textColor),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const SizedBox(height: 16),
            // 小熊護士圖片
            Image.asset(
              "images/nursebear.png",
              height: 150,
            ),
            const SizedBox(height: 60),
            
          ],
        ),
      ),
    );
  }
}
