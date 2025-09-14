import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
class DevelopPage extends StatefulWidget {
  const DevelopPage({super.key});

  @override
  State<DevelopPage> createState() => _DevelopPage();
}

class _DevelopPage extends State<DevelopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEBFEFF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: FrontUtil.textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                Text(
                  '此功能正在開發中...敬啟期待',
                  style: TextStyle(
                    color: FrontUtil.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
