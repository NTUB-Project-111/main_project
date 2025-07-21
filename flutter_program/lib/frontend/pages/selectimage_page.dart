import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/pages/tabs/camera_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/views/gallery_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectImagePage extends StatefulWidget {
  const SelectImagePage({super.key});

  @override
  State<SelectImagePage> createState() => _SelectImagePageState();
}

class _SelectImagePageState extends State<SelectImagePage> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final reports = reportProvider.reports;
    Gallery gallery = Gallery();
    gallery.sortReports(reports);
    return Scaffold(
      backgroundColor: FrontUtil.bkColor,
      appBar: AppBar(
        backgroundColor: FrontUtil.bkColor,
        title: const Text(''),
        iconTheme: IconThemeData(color: FrontUtil.textColor),
      ),
      body: ListView.builder(
        itemCount: gallery.reports.length,
        itemBuilder: (context, index) {
          final report = gallery.reports[index].first;
          // final photoPath = report.photo;
          // final imageUrl = Uri.parse(ApiBase.baseUrl).resolve(photoPath).toString();
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _buildWoundSection(report));
          // return Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: photoPath.isNotEmpty
          //       ? GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (_) => CameraPage(
          //                     isExtra: true,
          //                     id: report.id,
          //                     oktime: report.oktime,
          //                     date: report.date,
          //                     woundType: report.type),
          //               ),
          //             );
          //             debugPrint("選擇好照片了!");
          //           },
          //           child: Image.network(
          //             imageUrl,
          //             width: 82,
          //             height: 82,
          //             fit: BoxFit.cover,
          //           ),
          //         )
          //       : const Text('無圖片'),
          // );
        },
      ),
    );
  }

  Widget _buildWoundSection(UserReport report) {
    final photoPath = report.photo;
    final imageUrl = Uri.parse(ApiBase.baseUrl).resolve(photoPath).toString();
    final woundList = _getWoundList(report);
    return Container(
      // color: FrontUtil.bkColor,
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      child: Row(
        children: [
          Container(
              width: 82,
              height: 82,
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.grey,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.network(
                  imageUrl,
                  width: 82,
                  height: 82,
                  fit: BoxFit.cover,
                ),
              )),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '使用者取的傷口名稱',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: FrontUtil.textColor, // 深藍綠
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  report.date,
                  style: TextStyle(
                    fontSize: 14,
                    color: FrontUtil.textColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5),
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
            decoration: BoxDecoration(
              color: woundList[1], // 綠色背景
              shape: BoxShape.circle,
            ),
            child: Text(
              woundList[0],
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _getWoundList(UserReport report) {
    List<dynamic> woundList = ['', Colors.grey];
    if (report.type == '手術傷口') {
      woundList[0] = '術';
      woundList[1] = const Color(0xFFBFADFF);
    } else {
      woundList[0] = report.type.substring(0, 1);
      if (report.type == '擦傷') {
        woundList[1] = const Color(0xFF8CB083);
      } else if (report.type == '割傷') {
        woundList[1] = const Color(0xFFFEC1D9);
      } else if (report.type == '燙傷' || report.type == '燒傷') {
        woundList[1] = const Color(0xFFFFCA98);
      } else if (report.type == '嚴重傷口') {
        woundList[1] = const Color(0xFFFF6A6A);
      } else if (report.type == '刺傷') {
        woundList[1] = const Color(0xFFA68894);
      } else if (report.type == '瘀青') {
        woundList[1] = const Color(0xFFC1D3FE);
      }
    }
    return woundList;
  }
}
