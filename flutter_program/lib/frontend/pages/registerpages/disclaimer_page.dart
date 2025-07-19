import 'package:drw/frontend/pages/registerpages/register_flow.dart';
import 'package:flutter/material.dart';

class DisclaimerPage extends StatelessWidget {
  final void Function()? onAgree;

  const DisclaimerPage({super.key, this.onAgree});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      body: Center(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const double maxContentWidth = 500;
              final double targetWidth = constraints.maxWidth * 0.85;

              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 20),
                    // const Header1(title: '免責聲明'),
                    // const SizedBox(height: 10),

                    Image.asset(
                      'images/nurse_bear.png',
                      width: 130,
                      height: 130,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),

                    // ✅ 90% 寬度免責區塊
                    Center(
                      child: Container(
                        width: targetWidth > maxContentWidth
                            ? maxContentWidth
                            : targetWidth,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x80669FA5),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '⚠️ 免責聲明',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF669FA5),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '本應用程式所提供之資訊僅供參考用途，並不構成專業建議或診斷。使用者請自行判斷，並承擔使用本應用程式所產生之任何風險與後果。',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF669FA5),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 12),
                            Text(
                              '開發者不對因使用本應用程式所導致的任何損失或損害負責，包括但不限於資料遺失、或個人健康損害等。',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF669FA5),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 12),
                            Text(
                              '使用本應用程式即表示您已閱讀、理解並同意本免責聲明之內容。',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF669FA5),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel,
                              size: 40, color: Color(0xFF669FA5)),
                          tooltip: '不同意',
                        ),
                        const SizedBox(width: 50),
                        IconButton(
                          onPressed: onAgree ??
                              () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterFlow(),
                                  ),
                                );
                              },
                          icon: const Icon(Icons.check_circle,
                              size: 40, color: Color(0xFF669FA5)),
                          tooltip: '我同意',
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
