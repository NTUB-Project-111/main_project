import 'package:drw/backend/models/family.dart';
import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/provider/family_provider.dart';
import 'package:drw/backend/viewmodels/report_view_model.dart';
import 'package:drw/backend/provider/user_provider.dart';
// import 'package:drw/frontend/headers/header5.dart';
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
  final UserReport? report;
  final String? member;
  const ReportPage({super.key, required this.isExtra, this.id, this.report, this.member});

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
      final familyProvider = Provider.of<FamilyProvider>(context, listen: false);
      final members = familyProvider.members;
      UserFamily selectedMember = members[0];
      report.isLoading = true; // <-- 這行很關鍵！每次都要先設為 loading
      for (var member in members) {
        if (member.role == widget.member) {
          selectedMember = member;
          break;
        }
      }
      await report.loadData(
          selectedMember.userId,
          selectedMember.memberId,
          selectedMember.birthyear.toString(),
          selectedMember.disease,
          selectedMember.freq,
          widget.isExtra,
          widget.report);
      // await report.loadData(
      //     members[0].userId,
      //     members[0].memberId,
      //     members[0].birthyear.toString(),
      //     members[0].disease,
      //     members[0].freq,
      //     widget.isExtra,
      //     widget.report); // 這樣 Consumer 才會觸發 CircularProgressIndicator
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;
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
                  // const Header5(),
                  const TitlePart(),
                  const WoundPart(),
                  report.woundType != '無異常' ? CarePart(isExtra: widget.isExtra) : const SizedBox(),
                  report.woundType != '無異常' ? const HospitalPart() : const SizedBox(),
                  report.woundType == '無異常' || user!.id == -1
                      ? const SizedBox()
                      : const RecordPart(),
                  report.woundType == '無異常' || user!.id == -1
                      ? const SizedBox()
                      : ButtonPart(isExtra: widget.isExtra, id: widget.id, report: widget.report),
                ],
              ),
            )));
      },
    );
  }
}
