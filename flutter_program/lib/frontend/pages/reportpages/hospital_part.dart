import 'package:drw/backend/viewmodels/report_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HospitalPart extends StatefulWidget {
  const HospitalPart({super.key});

  @override
  State<HospitalPart> createState() => _HospitalPartState();
}

class _HospitalPartState extends State<HospitalPart> {
  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF589399), width: 2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Text(
              '附近相關醫療院所',
              style: TextStyle(
                color: Color(0xFF589399),
                fontSize: 20,
              ),
            ),
          ),
          ...report.hospitals.map((hospital) => _buildHospitalItem(
                hospital['name'],
                hospital['distanceText'],
                hospital['durationText'],
                hospital['address'],
              )),
        ],
      ),
    );
  }

  Widget _buildHospitalItem(String name, String distance, String time, String address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4D000000),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Image.asset('images/hospital.png'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 1)],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xFF589399),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  Text(
                    "地點：$address",
                    style: const TextStyle(
                      color: Color(0xFF589399),
                      fontSize: 14,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "距離：$distance",
                        style: const TextStyle(
                          color: Color(0xFF589399),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "步行時間：$time",
                        style: const TextStyle(
                          color: Color(0xFF589399),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
