import 'package:drw/backend/models/report_model.dart';
import 'package:drw/frontend/headers/header5.dart';
import 'package:drw/frontend/pages/reportpages/button_part.dart';
import 'package:drw/frontend/pages/reportpages/care_part.dart';
import 'package:drw/frontend/pages/reportpages/hospital_part.dart';
import 'package:drw/frontend/pages/reportpages/record_part.dart';
import 'package:drw/frontend/pages/reportpages/wound_part.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drw/frontend/pages/reportpages/title_part.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool _analyzed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 確保只分析一次
    if (!_analyzed) {
      final report = Provider.of<Report>(context, listen: false);
      report.loadData();
      _analyzed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Report>(
      builder: (context, report, _) {
        if (report.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const Scaffold(
            backgroundColor: Color(0xFFEBFEFF),
            body: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Header5(),
                  TitlePart(),
                  WoundPart(),
                  CarePart(),
                  HospitalPart(),
                  RecordPart(),
                  ButtonPart()
                ],
              ),
            )));
      },
    );
  }
}
