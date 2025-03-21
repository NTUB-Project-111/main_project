import 'package:flutter/material.dart';

class RemindPage extends StatefulWidget {
  const RemindPage({super.key});

  @override
  State<RemindPage> createState() => _RemindPageState();
}

class _RemindPageState extends State<RemindPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back))),
    );
  }
}
