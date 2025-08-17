import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/provider/report_provider.dart';
// import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/headers/header3.dart';
import 'package:drw/frontend/pages/gallerypages/showreport_page.dart';
import 'package:drw/frontend/pages/gallerypages/total_page.dart';
import 'package:drw/frontend/pages/remind_page.dart';
import 'package:drw/frontend/views/gallery_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<UserReport> cuts = [];
    List<UserReport> abrasions = [];
    List<UserReport> bruises = [];
    List<UserReport> burns = [];

    final reportProvider = context.watch<ReportProvider>();
    final reports = reportProvider.reports;
    if (reports.isNotEmpty) {
      for (var report in reports) {
        switch (report.type) {
          case '割傷':
            cuts.add(report);
            break;
          case '擦傷':
            abrasions.add(report);
            break;
          case '瘀青':
            bruises.add(report);
            break;
          case '燒傷':
            burns.add(report);
            break;
        }
      }
    }

    return Scaffold(
        backgroundColor: const Color(0xFFEBFEFF),
        body: Column(
          children: [
            const Header3(
                title: "傷口紀錄冊",
                icon: Icon(
                  Icons.notifications,
                  size: 23,
                  color: Color(0xFF589399),
                ),
                targetPage: RemindPage()),
            Container(
              color: const Color(0xFFCBF0F4),
              child: TabBar(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                labelColor: const Color(0xFF04555D),
                unselectedLabelColor: Colors.blueGrey,
                controller: _tabController,
                indicatorColor: const Color(0xFF04555D),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                tabs: const [
                  Tab(text: ("全部")),
                  Tab(text: ("割傷")),
                  Tab(text: ("擦傷")),
                  Tab(text: ("瘀青")),
                  Tab(text: ("燒傷")),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  _buildImagePage(reports.reversed.toList()),
                  _buildImagePage(cuts.reversed.toList()),
                  _buildImagePage(abrasions.reversed.toList()),
                  _buildImagePage(bruises.reversed.toList()),
                  _buildImagePage(burns.reversed.toList()),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildImagePage(List<UserReport> reports) {
    Gallery gallery = Gallery();
    gallery.sortReports(reports);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "近期傷口",
              style: TextStyle(color: Color(0xFF589399), fontWeight: FontWeight.w700, height: 3),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [for (var report in reports) _buildRecentImage(report)],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildYearlyImage('2025', gallery.reports, reports),
                  _buildYearlyImage('2024', gallery.reports, reports),
                  _buildYearlyImage('2023', gallery.reports, reports),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildGroupSwitcher(List<UserReport> groupReports) {
  //   return _GroupImageSwitcher(reports: groupReports);
  // }

  Widget _buildRecentImage(UserReport report) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          GestureDetector(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 83,
                height: 83,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      report.photo.toString(),
                      width: 83,
                      height: 83,
                      fit: BoxFit.cover,
                    )
                    // child: Image.network(
                    //   Uri.parse(ApiBase.baseUrl).resolve(report.photo).toString(),
                    //   width: 83,
                    //   height: 83,
                    //   fit: BoxFit.cover,
                    // )
                    )),
            onTap: () {
              final extra = isExtra(report);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowReportPage(
                            report: report,
                            isExtra: extra,
                          )));
            },
          ),
          Text(
            report.date,
            style: const TextStyle(
              color: Color(0xFF589399),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildYearlyImage(String y, List<List<UserReport>>? reports, List<UserReport> allReports) {
    List<List<UserReport>> yearlyReports = [];
    for (var report in reports!) {
      if (report.first.date.startsWith(y)) {
        yearlyReports.add(report);
      }
    }
    List<UserReport> allYearlyReports = [];
    for (var report in allReports) {
      if (report.date.startsWith(y)) {
        allYearlyReports.add(report);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$y年',
              style: const TextStyle(color: Color(0xFF589399), fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TotalPage(yearlyReports: allYearlyReports),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(70, 25),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "更多",
                    style: TextStyle(
                      color: Color(0xFF589399),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF589399)),
                ],
              ),
            )
          ],
        ),
        SizedBox(
            height: 220,
            child: yearlyReports.isEmpty
                ? Center(
                    child: Text(
                      '無 $y 年的傷口紀錄',
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  )
                : Row(
                    children: [
                      (yearlyReports.isEmpty || yearlyReports[0].isEmpty)
                          ? Container(
                              width: 176,
                              height: 220,
                              color: const Color(0xFFEBFEFF),
                            )
                          : yearlyReports[0].length == 1
                              ? _buildYearImageBox(
                                  yearlyReports[0].first,
                                  176,
                                  220,
                                  const EdgeInsets.only(right: 10),
                                )
                              : _buildYearGroupSwitcher(
                                  yearlyReports[0],
                                  176,
                                  220,
                                  const EdgeInsets.only(right: 10),
                                ),
                      Column(
                        children: [
                          (yearlyReports.length < 2 || yearlyReports[1].isEmpty)
                              ? Container(
                                  width: 176,
                                  height: 105,
                                  color: const Color(0xFFEBFEFF),
                                )
                              : yearlyReports[1].length == 1
                                  ? _buildYearImageBox(
                                      yearlyReports[1].first,
                                      176,
                                      105,
                                      const EdgeInsets.only(bottom: 10),
                                    )
                                  : _buildYearGroupSwitcher(
                                      yearlyReports[1],
                                      176,
                                      105,
                                      const EdgeInsets.only(bottom: 10),
                                    ),
                          Row(
                            children: [
                              (yearlyReports.length < 3 || yearlyReports[2].isEmpty)
                                  ? Container(
                                      width: 83,
                                      height: 105,
                                      color: const Color(0xFFEBFEFF),
                                    )
                                  : yearlyReports[2].length == 1
                                      ? _buildYearImageBox(
                                          yearlyReports[2].first,
                                          83,
                                          105,
                                          const EdgeInsets.only(right: 10),
                                        )
                                      : _buildYearGroupSwitcher(
                                          yearlyReports[2],
                                          83,
                                          105,
                                          const EdgeInsets.only(right: 10),
                                        ),
                              (yearlyReports.length < 4 || yearlyReports[3].isEmpty)
                                  ? Container(
                                      width: 83,
                                      height: 105,
                                      color: const Color(0xFFEBFEFF),
                                    )
                                  : yearlyReports[3].length == 1
                                      ? _buildYearImageBox(yearlyReports[3].first, 83, 105, null)
                                      : _buildYearGroupSwitcher(yearlyReports[3], 83, 105, null),
                            ],
                          )
                        ],
                      )
                    ],
                  ))
      ],
    );
  }

  Widget _buildYearImageBox(
      UserReport report, double width, double height, EdgeInsetsGeometry? edge) {
    return GestureDetector(
      onTap: () {
        final extra = isExtra(report);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowReportPage(
                      report: report,
                      isExtra: extra,
                    )));
      },
      child: Container(
        width: width,
        height: height,
        margin: edge,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            report.photo.toString(),
            fit: BoxFit.cover,
          ),
          // child: Image.network(
          //   Uri.parse(ApiBase.baseUrl).resolve(report.photo).toString(),
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }

  Widget _buildYearGroupSwitcher(
      List<UserReport> reports, double width, double height, EdgeInsetsGeometry? edge) {
    return Container(
      width: width,
      height: height,
      margin: edge,
      child: _YearImageSwitcher(
        reports: reports,
        width: width,
        height: height,
      ),
    );
  }

  bool isExtra(UserReport report) {
    int groupId = report.groupId;
    UserReport? compareReport;
    List<UserReport> userReports = [];
    final reportProvider = context.read<ReportProvider>();
    final reports = reportProvider.reports;
    if (groupId == 0) {
      return false;
    } else {
      for (var r in reports) {
        if (r.groupId == groupId) {
          userReports.add(r);
        }
      }
    }
    compareReport = userReports.first;
    if (report.id == compareReport.id) {
      return false;
    } else {
      return true;
    }
  }
}

class _YearImageSwitcher extends StatefulWidget {
  final List<UserReport> reports;
  final double width;
  final double height;
  const _YearImageSwitcher({required this.reports, required this.width, required this.height});

  @override
  State<_YearImageSwitcher> createState() => _YearImageSwitcherState();
}

class _YearImageSwitcherState extends State<_YearImageSwitcher> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _startSwitch();
  }

  void _startSwitch() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _index = (_index + 1) % widget.reports.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.reports[_index];
    return GestureDetector(
      onTap: () {
        final extra = isExtra(report);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowReportPage(
                      report: report,
                      isExtra: extra,
                    )));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: Image.network(
            report.photo.toString(),
            key: ValueKey(report.photo),
            fit: BoxFit.cover,
            width: widget.width,
            height: widget.height,
          ),
          // child: Image.network(
          //   Uri.parse(ApiBase.baseUrl).resolve(report.photo).toString(),
          //   key: ValueKey(report.photo),
          //   fit: BoxFit.cover,
          //   width: widget.width,
          //   height: widget.height,
          // ),
        ),
      ),
    );
  }

  bool isExtra(UserReport report) {
    int groupId = report.groupId;
    UserReport? compareReport;
    List<UserReport> userReports = [];
    final reportProvider = context.read<ReportProvider>();
    final reports = reportProvider.reports;
    if (groupId == 0) {
      return false;
    } else {
      for (var r in reports) {
        if (r.groupId == groupId) {
          userReports.add(r);
        }
      }
    }
    compareReport = userReports.first;
    if (report.id == compareReport.id) {
      return false;
    } else {
      return true;
    }
  }
}
