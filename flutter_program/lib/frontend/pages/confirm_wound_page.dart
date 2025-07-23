import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:drw/frontend/pages/tabs/camera_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class ConfirmWoundPage extends StatefulWidget {
  final UserReport report;
  const ConfirmWoundPage({super.key, required this.report});

  @override
  State<ConfirmWoundPage> createState() => _ConfirmWoundPageState();
}

class _ConfirmWoundPageState extends State<ConfirmWoundPage> {
  @override
  Widget build(BuildContext context) {
    final photoPath = widget.report.photo;
    final imageUrl = Uri.parse(ApiBase.baseUrl).resolve(photoPath).toString();
    return Scaffold(
      backgroundColor: FrontUtil.bkColor, // 淡藍底色
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: FrontUtil.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 卡片區塊
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl, // 改成你自己的圖片網址或本地檔案
                      width: 260,
                      height: 270,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '使用者取的傷口名稱',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: FrontUtil.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.report.date,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // 下方兩顆按鈕
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircleButton(
                  icon: Icons.favorite,
                  color: const Color(0xFFFF6262),
                  onPressed: () {
                    FrontUtil.showSelectWoundDialog(context, const Color(0xFFFF6262), '此傷口已經癒合了嗎?',
                        '※『是的』將會關閉傷口的後續追蹤', '還沒', '是的', () {});
                  },
                ),
                const SizedBox(width: 60),
                _buildCircleButton(
                  icon: Icons.check,
                  color: FrontUtil.textColor,
                  onPressed: () {
                    FrontUtil.showSelectWoundDialog(
                        context, FrontUtil.textColor, '確定追蹤該傷口嗎?', null, '取消', '確定', () {
                      debugPrint(widget.report.type);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CameraPage(
                                    isExtra: true,
                                    id: widget.report.id,
                                    oktime: widget.report.oktime,
                                    date: widget.report.date,
                                    woundType: widget.report.type,
                                  )));
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

Widget _buildCircleButton({
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
}) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(30),
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 25),
    ),
  );
}
