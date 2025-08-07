// import 'package:drw/backend/models/report_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class TitlePart extends StatefulWidget {
//   const TitlePart({super.key});

//   @override
//   State<TitlePart> createState() => _TitlePartState();
// }

// class _TitlePartState extends State<TitlePart> {
//   @override
//   Widget build(BuildContext context) {
//     final report = Provider.of<Report>(context, listen: false);
//     return Container(
      
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           bottom: BorderSide(
//             color: Color(0xFF589399),
//             width: 2,
//           ),
//         ),
//       ),
//       height: 55,
//       // padding: const EdgeInsets.only(left: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Color(0xFF669FA5),
//             ),
//             padding: EdgeInsets.zero, // 移除 padding
//             constraints: const BoxConstraints(), // 移除預設大小
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 23),
//             child: Text(
//               '診斷報告',
//               style: TextStyle(
//                 color: Color(0xFF589399),
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           // 使用系統抓取的日期顯示
//           Text(
//             report.date,
//             style: const TextStyle(
//               color: Color(0xFF589399),
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:drw/backend/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitlePart extends StatefulWidget {
  const TitlePart({super.key});

  @override
  State<TitlePart> createState() => _TitlePartState();
}

class _TitlePartState extends State<TitlePart> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final report = Provider.of<Report>(context, listen: false);
    _controller = TextEditingController(text: report.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 頂部標題列
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF589399),
                width: 2,
              ),
            ),
          ),
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF669FA5),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 23),
                child: Text(
                  '診斷報告',
                  style: TextStyle(
                    color: Color(0xFF589399),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                report.date,
                style: const TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // 輸入診斷內容
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: TextField(
            controller: _controller,
            maxLines: null,
            decoration: InputDecoration(
              hintText: report.name,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF589399)),
              ),
            ),
            onChanged: (value) {
              report.setName(value); // 使用 setter 更新 provider
            },
          ),
        ),
      ],
    );
  }
}
