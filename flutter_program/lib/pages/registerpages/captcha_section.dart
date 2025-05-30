import 'package:flutter/material.dart';

//改成表單
class CaptchaSection extends StatelessWidget {
  const CaptchaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '驗證碼',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF669FA5),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF669FA5)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 61),
                child: const Text(
                  '請輸入右側的驗證碼',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA5A1A1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Image.asset(
            //   'assets/images/captcha.png',
            //   width: 116,
            //   height: 40,
            // ),
          ],
        ),
        const SizedBox(height: 23),
        
      ],
    );
  }
}
