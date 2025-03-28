import 'package:flutter/material.dart';

class WoundInfoCard extends StatefulWidget {
  final String date;
  final String woundType;
  final String medicationTime;

  const WoundInfoCard({
    super.key,
    required this.date,
    required this.woundType,
    required this.medicationTime,
  });

  @override
  _WoundInfoCardState createState() => _WoundInfoCardState();
}

class _WoundInfoCardState extends State<WoundInfoCard> {
  String selectedFrequency = "周一";
  TimeOfDay selectedTime = TimeOfDay(hour: 18, minute: 30);
  

  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "編輯換藥資訊",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("換藥頻率："),
                  DropdownButton<String>(
                    value: selectedFrequency,
                    items: ["每天","周一", "周二", "周三", "周四", "周五", "周六", "周日"]
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedFrequency = newValue;
                        });
                        Navigator.pop(context);
                        _showEditDialog(context);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("換藥時間："),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: Row(
                      children: [
                        Text(
                          "${selectedTime.hour.toString().padLeft(2, '0')} : ${selectedTime.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.access_time, color: Colors.blue),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("確定"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      Navigator.pop(context);
      _showEditDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("拍攝日： 20XX/XX/XX"),
            SizedBox(height: 5),
            Text("傷口類型： 擦傷"),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("換藥頻率："),
                Text(selectedFrequency),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("換藥時間："),
                Text(
                    "${selectedTime.hour.toString().padLeft(2, '0')} : ${selectedTime.minute.toString().padLeft(2, '0')}"),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.topRight,
              child: TextButton.icon(
                onPressed: () => _showEditDialog(context),
                icon: Icon(Icons.edit, color: Colors.red),
                label: Text(
                  "確認",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
