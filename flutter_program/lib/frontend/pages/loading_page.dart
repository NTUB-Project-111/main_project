import 'package:drw/backend/services/user_service.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String status = "正在連線伺服器...";
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _warmUpServer();
  }

  Future<void> _warmUpServer() async {
    final message = await userService.wakeUpServer();
    if (message) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
      FrontUtil.showSuccess("伺服器連線成功");
    } else {
      FrontUtil.showFail("伺服器連線失敗，請稍後再試");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FrontUtil.loading(),
            const SizedBox(height: 20),
            Text(status),
          ],
        ),
      ),
    );
  }
}
