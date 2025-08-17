import 'package:drw/frontend/utility/front_util.dart';
import 'package:drw/frontend/widgets/report/title.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrontUtil.bkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TitlePart(editable: false,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
