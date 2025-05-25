import 'package:flutter/material.dart';

//白底右邊有Icon的header
class HeaderPage1 extends StatefulWidget {
  final String title;
  final Icon icon;
  final Widget? targetPage; // 可選的跳轉頁面
  final Function(bool)? onValueReturned; // 回傳值的 Callback
  const HeaderPage1({
    super.key,
    required this.title,
    required this.icon,
    this.targetPage, // 可選，若未提供則不進行跳轉
    this.onValueReturned// 可選，優先處理自訂事件
  });

  @override
  State<HeaderPage1> createState() => _HeaderPage1State();
}

class _HeaderPage1State extends State<HeaderPage1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 36, 14, 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
          color: Color(0xFF589399),
          width: 2,
        )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Color(0xFF589399),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          IconButton(
              onPressed: () {
                if (widget.onValueReturned != null) {
                  // _open = !_open;
                  // widget.onValueReturned!(_open);
                } else if (widget.targetPage != null) {
                  // 若無自訂事件且提供 targetPage，執行跳轉
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => widget.targetPage!),
                  );
                }
              },
              icon: widget.icon)
        ],
      ),
    );
  }
}
