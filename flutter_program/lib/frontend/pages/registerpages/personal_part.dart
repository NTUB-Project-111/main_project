import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../backend/models/register_model.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');
    final register = Provider.of<Register>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '個人資料',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF669FA5),
              letterSpacing: 2,
              height: 3.5),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFB2DFDB)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        const Text(
                          '姓名',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF669FA5),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            onChanged: (value) => register.setName(value),
                            style: const TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              hintText: '輸入本名或暱稱',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              isCollapsed: true, // 讓 padding 由外層控制
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: register.birthday ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) register.setBirthday(picked);
                    },
                    child: AbsorbPointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFB2DFDB)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            const Text(
                              '生日',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF669FA5),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                register.birthday != null
                                    ? formatter.format(register.birthday!)
                                    : 'YYYY-MM-DD',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: register.birthday != null
                                      ? Colors.black87
                                      : Colors.grey, // 若未選則用灰色提示文字
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFB2DFDB)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          '性別',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF669FA5),
                              height: 3),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [
                            buildGenderOption('男', 'M', register),
                            buildGenderOption('女', 'F', register),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  register.setProfileImage(File(pickedFile.path));
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 15),
                width: 120,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFB2DFDB)),
                  borderRadius: BorderRadius.circular(12),
                  image: register.picture != null
                      ? DecorationImage(
                          image: FileImage(register.picture!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: register.picture == null
                    ? const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF669FA5),
                        size: 35,
                      )
                    : null,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }

  Widget buildGenderOption(String label, String value, Register register) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: register.gender,
          fillColor: WidgetStateProperty.all(const Color(0xFF669FA5)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          onChanged: (val) => register.setGender(val!),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF669FA5),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
