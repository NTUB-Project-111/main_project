import 'package:drw/backend/provider/report_provider.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/pages/tabs/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickPage extends StatefulWidget {
  const PickPage({super.key});

  @override
  State<PickPage> createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final reports = reportProvider.reports;
    return Scaffold(
      appBar: AppBar(title: const Text('所有圖片')),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
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
                              woundType: report.type
                              ),
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
}
