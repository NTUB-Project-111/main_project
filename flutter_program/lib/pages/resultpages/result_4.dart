import 'package:flutter/material.dart';

// const String googleMapsApiKey = "AIzaSyCDjOjWfvAM9JpXwMRdJVhKL77lCOfvezs";

class ResultPage4 extends StatefulWidget {
  final List<Map<String, dynamic>> hospitals ;
  const ResultPage4({super.key, required this. hospitals});

  @override
  State<ResultPage4> createState() => _ResultPage4State();
}

class _ResultPage4State extends State<ResultPage4> {

  @override
  Widget build(BuildContext context) {
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
          // const SizedBox(height: 20),

          ...widget.hospitals.map((hospital) => _buildHospitalItem(
                hospital['name'],
                hospital['distanceText'],
                hospital['durationText'],
                hospital['address'],
              )),
          // _buildHospitalItem('A醫院', '500公尺', '6分鐘'),
          // _buildHospitalItem('B醫院', '1公里', '12分鐘'),
          // _buildHospitalItem('C醫院', '1.2公里', '14分鐘'),
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
