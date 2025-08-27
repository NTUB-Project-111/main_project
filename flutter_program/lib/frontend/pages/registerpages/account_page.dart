import 'package:drw/backend/viewmodels/register_view_model.dart';
import 'package:drw/frontend/headers/header6.dart';
import 'package:drw/frontend/pages/registerpages/information_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isCodeEnabled = false;
  bool isPwdEnabled = false;
  bool isSending = false;
  bool isVerifing = false;
  bool isAllFilled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkAllFieldsFilled);
    _codeController.addListener(_checkAllFieldsFilled);
    _passwordController.addListener(_checkAllFieldsFilled);
    _confirmPasswordController.addListener(_checkAllFieldsFilled);
  }

  void _checkAllFieldsFilled() {
    final filled = _emailController.text.isNotEmpty &&
        _codeController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;

    if (isAllFilled != filled) {
      setState(() {
        isAllFilled = filled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor2,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Header6(
            title: '註冊帳號',
            icon: Icon(
              Icons.arrow_back,
              color: FrontUtil.textColor,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 100),
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
                    Consumer<Register>(
                      builder: (context, register, _) {
                        return Text(
                          register.name,
                          style: TextStyle(
                            color: FrontUtil.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          maxLines: 1, // 最多顯示一行
                          overflow: TextOverflow.ellipsis, // 超出時以「…」表示
                          textAlign: TextAlign.center, // 可選：讓文字置中對齊
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Consumer<Register>(
                            builder: (context, register, _) {
                              return _buildEmailRow(register);
                            },
                          ),
                          const SizedBox(height: 15),
                          Consumer<Register>(
                            builder: (context, register, _) {
                              return _buildCodeRow(register);
                            },
                          ),
                          const SizedBox(height: 15),
                          Consumer<Register>(
                            builder: (context, register, _) {
                              return _buildPasswordField(
                                  label: '密碼',
                                  hint: '請設定8~16個英文/數字',
                                  controller: _passwordController,
                                  hidden: hidePassword,
                                  enabled: isPwdEnabled,
                                  onToggle: () => setState(
                                        () => hidePassword = !hidePassword,
                                      ),
                                  register: register);
                            },
                          ),
                          const SizedBox(height: 15),
                          Consumer<Register>(
                            builder: (context, register, _) {
                              return _buildPasswordField(
                                  label: '確認密碼',
                                  hint: '需與上面密碼一致',
                                  controller: _confirmPasswordController,
                                  hidden: hideConfirmPassword,
                                  enabled: isPwdEnabled,
                                  onToggle: () => setState(() =>
                                      hideConfirmPassword =
                                          !hideConfirmPassword),
                                  register: register);
                            },
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    if (isAllFilled)
                      IconButton(
                        onPressed: () {
                          final register = context.read<Register>();
                          final error = register.verify();
                          if (error == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: register,
                                  child: const InformationPage(),
                                ),
                              ),
                            );
                          } else {
                            FrontUtil.showFail(
                                error);
                          }
                        },
                        icon: Icon(
                          Icons.arrow_circle_right_sharp,
                          size: 40,
                          color: FrontUtil.textColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// === Email欄位與按鈕 ===
  Widget _buildEmailRow(Register register) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: FrontUtil.textColor),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: FrontUtil.textColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    onChanged: (value) {
                      register.setEmail(value);
                      register.setCode('');
                      register.setPassword('');
                      register.setRePassword('');

                      _codeController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();

                      setState(() {
                        isCodeEnabled = false;
                        isPwdEnabled = false;
                      });
                    },
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'example@gmail.com',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        _roundedButton(isSending ? '傳送中...' : '傳送驗證碼', () async {
          setState(() => isSending = true);
          final error = await register.sendCode();
          if (error == null) {
            setState(() => isCodeEnabled = true);
            FrontUtil.showSuccess('驗證碼已寄出，請於電子郵件查看');
          } else {
            FrontUtil.showFail(error);
          }
          setState(() => isSending = false);
        }, true, isSending),
      ],
    );
  }

  /// === 驗證碼欄位與按鈕 ===
  Widget _buildCodeRow(Register register) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isCodeEnabled ? Colors.white : Colors.grey[200],
              border: Border.all(color: FrontUtil.textColor),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  '驗證碼',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: FrontUtil.textColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    onChanged: (value) => register.setCode(value),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 16),
                    enabled: isCodeEnabled,
                    decoration: const InputDecoration(
                      hintText: 'xxxxxx',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        _roundedButton(isVerifing ? '驗證中...' : '驗證', () async {
          setState(() => isVerifing = true);
          final error = await register.verifyCode();
          if (error == null) {
            setState(() => isPwdEnabled = true);
            FrontUtil.showSuccess('驗證成功 ! 請設定密碼');
          } else {
            FrontUtil.showFail(error);
          }
          setState(() => isVerifing = false);
        }, isCodeEnabled, isVerifing),
      ],
    );
  }

  /// === 密碼欄位（密碼 / 確認密碼 共用） ===
  Widget _buildPasswordField(
      {required String label,
      required String hint,
      required TextEditingController controller,
      required bool hidden,
      required bool enabled,
      required VoidCallback onToggle,
      required Register register}) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[200],
        border: Border.all(color: FrontUtil.textColor),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: FrontUtil.textColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (value) => label == '密碼'
                  ? register.setPassword(value)
                  : register.setRePassword(value),
              obscureText: hidden,
              style: const TextStyle(fontSize: 16),
              enabled: enabled,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              hidden ? Icons.visibility_off : Icons.visibility,
              color: FrontUtil.textColor,
            ),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }

  /// === 右側按鈕樣式 ===
  Widget _roundedButton(
      String text, VoidCallback onPressed, bool enabled, bool isLoading) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isLoading ? Colors.grey : FrontUtil.textColor,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
