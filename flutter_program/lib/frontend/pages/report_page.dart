import 'package:drw/backend/models/report_model.dart';
import 'package:drw/backend/provider/user_provider.dart';
import 'package:drw/frontend/headers/header5.dart';
import 'package:drw/frontend/pages/reportpages/button_part.dart';
import 'package:drw/frontend/pages/reportpages/care_part.dart';
import 'package:drw/frontend/pages/reportpages/hospital_part.dart';
import 'package:drw/frontend/pages/reportpages/record_part.dart';
import 'package:drw/frontend/pages/reportpages/wound_part.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drw/frontend/pages/reportpages/title_part.dart';

class ReportPage extends StatefulWidget {
  final bool isExtra;
  final int? id;
  final String? oktime;
  final String? date;
  final String? woundType;

  const ReportPage({
    super.key,
    required this.isExtra,
    this.id,
    this.oktime,
    this.date,
    this.woundType,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // bool _analyzed = false;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // 確保只分析一次
  //   if (!_analyzed) {
  //     final report = Provider.of<Report>(context, listen: false);
  //     report.loadData();
  //     _analyzed = true;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final report = Provider.of<Report>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final isGuest = userProvider.isGuest;
      final user = userProvider.user;

      report.isLoading = true;

      try {
        await report.loadData(
          isGuest ? "1900" : (user?.birthday ?? "1900"),
          isGuest ? "無" : (user?.disease ?? "無"),
          isGuest ? "每天" : (user?.freq ?? "每天"),
          widget.isExtra,
          widget.oktime,
          widget.date,
          widget.woundType,
        );
      } catch (e, stacktrace) {
        debugPrint('loadData 發生錯誤: $e');
        debugPrint('$stacktrace');
      } finally {
        // 無論成功與否，必須將 isLoading 設為 false
        report.isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = Provider.of<UserProvider>(context).isGuest;

    return Consumer<Report>(
      builder: (context, report, _) {
        if (report.isLoading) {
          return Scaffold(
            body: Center(child: FrontUtil.loading()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFEBFEFF),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const Header5(),
                  const TitlePart(),
                  const WoundPart(),
                  const CarePart(),
                  const HospitalPart(),
                  if (!isGuest) const RecordPart(),
                  if (!isGuest)
                    ButtonPart(
                      isExtra: widget.isExtra,
                      id: widget.id,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
