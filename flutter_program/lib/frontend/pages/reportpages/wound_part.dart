import 'package:drw/backend/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WoundPart extends StatefulWidget {
  const WoundPart({super.key});

  @override
  State<WoundPart> createState() => _WoundPartState();
}

class _WoundPartState extends State<WoundPart> {
  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xFF589399),
        width: 2,
      ))),
      height: 230,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(report.image!, width: 180, height: 230, fit: BoxFit.cover),
            ),
          ),
          // const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(
                    48, 4, 48, 4), //對稱的內間距，讓Container與裡面的子元素的上下間距為n，左右間距為m
                decoration: BoxDecoration(
                  color: const Color(0xFF589399).withOpacity(0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "傷口類型",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text(
                report.woundType,
                style: const TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 48,
                ),
              ),
              report.oktime != ""
                  ? Consumer<Report>(
                      builder: (context, report, child) {
                        return SizedBox(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '預計',
                                style: TextStyle(
                                  color: Color(0xFF589399),
                                  fontSize: 16,
                                ),
                              ),
                              report.newOktime.isEmpty
                                  ? Text(
                                      report.oktime,
                                      style: const TextStyle(
                                        color: Color(0xFF589399),
                                        fontSize: 26,
                                      ),
                                    )
                                  : Text(
                                      report.oktime.replaceAll(RegExp(r'\s+'), ''),
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 26,
                                      ),
                                    ),
                              const Text(
                                '癒合',
                                style: TextStyle(
                                  color: Color(0xFF589399),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
