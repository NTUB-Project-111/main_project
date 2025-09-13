import 'package:drw/backend/viewmodels/report_view_model.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitlePart extends StatefulWidget {
  const TitlePart({super.key});

  @override
  State<TitlePart> createState() => _TitlePartState();
}

class _TitlePartState extends State<TitlePart> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final report = Provider.of<Report>(context, listen: false);
    _controller = TextEditingController(text: report.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 頂部標題列
        Container(
          margin: const EdgeInsets.only(top: 60),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF589399),
                width: 2,
              ),
            ),
          ),
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF669FA5),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 170,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline, // 用基線對齊
                  textBaseline: TextBaseline.alphabetic, // 指定基線類型
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onChanged: (value) {
                          report.setName(value);
                        },
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        maxLength: 20,
                        decoration: const InputDecoration(
                            hintText: '報告名稱',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(87, 102, 159, 165),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            counterText: ''),
                        cursorColor: const Color(0xFF669FA5),
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: FrontUtil.textColor,
                    ),
                  ],
                ),
              ),
              Text(
                report.date,
                style: const TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
