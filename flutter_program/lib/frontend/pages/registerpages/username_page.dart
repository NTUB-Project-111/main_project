import 'package:drw/backend/viewmodels/register_view_model.dart';
// import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/registerpages/account_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNamePage extends StatefulWidget {
  const UserNamePage({super.key});

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool showButton = false;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() {
      setState(() {
        showButton = _nameController.text.trim().isNotEmpty;
      });
    });

    _focusNode.addListener(() {
      setState(() {
        isEditing = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final register = Provider.of<Register>(context);

    return Scaffold(
      backgroundColor: FrontUtil.bkColor2,
      body: Column(
        children: [
          // Header6(
          //   title: '註冊帳號',
          //   icon: Icon(Icons.arrow_back, color: FrontUtil.textColor),
          // ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.all(5),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: FrontUtil.textColor, width: 1.5),
                    ),
                    child: ClipOval(
                      child: Image.asset('images/register_icon.png'),
                    ),
                  ),

                  // 名稱輸入欄位（自動寬度 + icon動畫）
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // 設定最大寬度為螢幕的 70%，最高不超過 300
                          final double maxWidth =
                              (constraints.maxWidth * 0.35).clamp(0, 300);

                          return SizedBox(
                            width: maxWidth,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // 實際輸入框（透明文字）
                                    TextField(
                                      controller: _nameController,
                                      focusNode: _focusNode,
                                      onChanged: (value) {
                                        register.setName(value); // 即時儲存名稱
                                      },
                                      style: const TextStyle(
                                        color: Colors.transparent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 8),
                                      ),
                                      cursorColor: FrontUtil.textColor,
                                    ),

                                    // 顯示用文字 + icon（有底線）
                                    IgnorePointer(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // ✅ Flexible 包住 Text，讓文字可壓縮
                                          Flexible(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2),
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Color(0xFF669FA5),
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                _nameController.text.isEmpty
                                                    ? '請輸入您的名稱'
                                                    : _nameController.text,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: _nameController
                                                          .text.isEmpty
                                                      ? FrontUtil.textColor
                                                          .withOpacity(0.6)
                                                      : FrontUtil.textColor,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // ✅ 不要被擠壓的 Icon
                                          if (_nameController.text.isNotEmpty &&
                                              !_focusNode.hasFocus)
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              transitionBuilder:
                                                  (child, animation) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: ScaleTransition(
                                                    scale: animation,
                                                    child: child,
                                                  ),
                                                );
                                              },
                                              child: const Icon(
                                                key: ValueKey('edit'),
                                                Icons.edit,
                                                color: Color(0xCC669FA5),
                                                size: 20,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ▶️ 下一步按鈕
                  if (showButton)
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: register,
                              child: const AccountPage(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_circle_right_sharp,
                        size: 40,
                        color: FrontUtil.textColor,
                      ),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
