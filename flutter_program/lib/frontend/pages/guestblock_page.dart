import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'registerpages/disclaimer_page.dart';

class GuestBlockPage extends StatefulWidget {
  const GuestBlockPage({super.key});

  @override
  State<GuestBlockPage> createState() => _GuestBlockPage();
}

class _GuestBlockPage extends State<GuestBlockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/doctor_bear.png', width: 200),
            const SizedBox(height: 13),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DisclaimerPage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    '註冊帳號',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
                Text(
                  ' 開啟更多功能',
                  style: TextStyle(
                    color: FrontUtil.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              '(護理提醒、紀錄冊、我的)',
              style: TextStyle(color: FrontUtil.textColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
