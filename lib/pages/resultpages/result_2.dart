import 'dart:io'; //可以使用File資料型態
import 'package:flutter/material.dart';

class ResultPage2 extends StatefulWidget {
  final String woundType;
  final File image;
  const ResultPage2({super.key, required this.woundType, required this.image});

  @override
  State<ResultPage2> createState() => _ResultPage2State();
}

class _ResultPage2State extends State<ResultPage2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xFF589399),
        width: 2,
      ))),
      height: 230,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(widget.image, width: 180, fit: BoxFit.cover),
            ),
          ),
          // const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(
                    48, 4, 48, 4), //對稱的內間距，讓Container與裡面的子元素的上下間距為n，左右間距為m
                decoration: BoxDecoration(
                  color: const Color(0xFF589399).withOpacity(0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "傷口類型",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text(
                widget.woundType,
                style: const TextStyle(color: Color(0xFF589399),fontSize: 50,),
              ),
              // FittedBox(
              //   fit: BoxFit.scaleDown, // 讓字體縮小
              //   child: Text(
              //     widget.woundType,
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(color: Color(0xFF589399), fontSize: 50),
              //   ),
              // ),
              const SizedBox(
                width: 180,
                child: Row(
                  children: [
                    Text(
                      '預計癒合時間',
                      style: TextStyle(
                        color: Color(0xFF589399),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      ' X~X ',
                      style: TextStyle(
                        color: Color(0xFF589399),
                        fontSize: 26,
                      ),
                    ),
                    Text(
                      '天',
                      style: TextStyle(
                        color: Color(0xFF589399),
                        fontSize: 16,
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
  }
}
