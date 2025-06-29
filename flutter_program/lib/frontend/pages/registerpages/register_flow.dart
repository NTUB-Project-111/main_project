import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../backend/viewmodels/register_view_model.dart';
import './username_page.dart'; // 註冊頁起點

class RegisterFlow extends StatelessWidget {
  const RegisterFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Register(),
      child: const UserNamePage(), // 或是 Navigator/Router 控制流程
    );
  }
}
