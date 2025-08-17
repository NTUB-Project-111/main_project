import 'package:drw/backend/models/report_model.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitlePart extends StatefulWidget {
  final bool editable; // 新增參數：是否可編輯
  final String reportDate;
  const TitlePart({super.key, this.editable = true, this.reportDate = ''});

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

    return Container(
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
          // 返回按鈕
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
          const SizedBox(width: 10),

          // 中間標題：可輸入 / 只顯示
          SizedBox(
            width: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: widget.editable
                      ? TextField(
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
                            counterText: '',
                          ),
                          cursorColor: const Color(0xFF669FA5),
                        )
                      : Text(
                          report.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
                if (widget.editable)
                  Icon(
                    Icons.edit,
                    size: 18,
                    color: FrontUtil.textColor,
                  ),
              ],
            ),
          ),

          // 日期
          widget.editable
              ? Text(
                  report.date,
                  style: const TextStyle(
                    color: Color(0xFF589399),
                    fontSize: 12,
                  ),
                )
              : Text(
                  widget.reportDate,
                  style: const TextStyle(
                    color: Color(0xFF589399),
                    fontSize: 12,
                  ),
                )
        ],
      ),
    );
  }
}
