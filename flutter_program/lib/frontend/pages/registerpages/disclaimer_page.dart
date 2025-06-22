import 'package:drw/frontend/headers/header1.dart';
import 'package:flutter/material.dart';
import '../register_page.dart';

class DisclaimerPage extends StatelessWidget {
  final void Function()? onAgree;

  const DisclaimerPage({super.key, this.onAgree});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      body: Column(
        children: [
          const Header1(title: '免責聲明'),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '本應用程式所提供之資訊僅供參考用途，並不構成專業建議或診斷。使用者請自行判斷並承擔使用本應用程式所產生之任何風險與後果。',
                    style: TextStyle(fontSize: 16, color: Color(0xFF669FA5)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '開發者不對因使用本應用程式所導致的任何損失或損害負責，包括但不限於資料遺失、或個人健康損害等。',
                    style: TextStyle(fontSize: 16, color: Color(0xFF669FA5)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '使用本應用程式即表示您已閱讀、理解並同意本免責聲明之內容。',
                    style: TextStyle(fontSize: 16, color: Color(0xFF669FA5)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: onAgree ??
                        () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF669FA5),
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("我同意",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2)),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("不同意",
                        style: TextStyle(
                            color: Color(0xFF669FA5),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2)),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
