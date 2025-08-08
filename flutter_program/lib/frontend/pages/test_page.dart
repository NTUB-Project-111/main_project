import 'package:drw/backend/services/careinfo_gpt.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             
              SizedBox(
                width: 170,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: (value) {
                    setState(() {});
                  },
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: '報告名稱',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(87, 102, 159, 165),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    counterText: '',
                    suffixIcon: Icon(
                      Icons.edit,
                      color: FrontUtil.textColor,
                      size: 24,
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                  cursorColor: const Color(0xFF669FA5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
