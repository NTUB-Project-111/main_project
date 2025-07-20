import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/pages/tabs/camera_page.dart';
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
      appBar: AppBar(title: const Text('所有圖片')),
      body: ListView.builder(
        itemCount: gallery.reports.length,
        itemBuilder: (context, index) {
          final report = gallery.reports[index].first;
          final photoPath = report.photo;
          final imageUrl = Uri.parse(ApiBase.baseUrl).resolve(photoPath).toString();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: photoPath.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CameraPage(
                              isExtra: true,
                              id: report.id,
                              oktime: report.oktime,
                              date: report.date,
                              woundType: report.type),
                        ),
                      );
                      debugPrint("選擇好照片了!");
                    },
                    child: Image.network(
                      imageUrl,
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Text('無圖片'),
          );
        },
      ),
    );
  }

  Widget _buildWoundSection(UserReport report) {
    final photoPath = report.photo;
    final imageUrl = Uri.parse(ApiBase.baseUrl).resolve(photoPath).toString();
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 82,
            height: 82,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
