import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:wounddetection/feature/database.dart';

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({super.key});

  @override
  _PersonalInfoSectionState createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  String? _selectedGender;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  File? _profileImage;
  final Map<String, String> genderMap = {
    "M": "男",
    "F": "女",
    "Other": "其他",
  };

  @override
  void initState() {
    super.initState();
    DatabaseHelper.userInfo["name"] = '';
    DatabaseHelper.userInfo["birthday"] = '';
    DatabaseHelper.userInfo["gender"] = '';

    _nameController.addListener(() {
      DatabaseHelper.userInfo["name"] = _nameController.text;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        const SizedBox(height: 25),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildTextField(
                    label: '姓名',
                    hint: '請輸入您的姓名/暱稱',
                    controller: _nameController,
                    readOnly: false,
                    onTap: null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: '生日',
                    hint: 'YYYY-MM-DD',
                    controller: _birthdateController,
                    readOnly: true,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderSelection(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: _pickImage,
              child: Container(
                width: 116,
                height: 167,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 242, 242, 242),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF669FA5)),
                ),
                child: _profileImage == null
                    ? const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF669FA5),
                        size: 40,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _profileImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool readOnly,
    required VoidCallback? onTap,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF669FA5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF669FA5),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.6,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: AbsorbPointer(
                absorbing: readOnly,
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 61, 103, 108),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Color(0xFFA5A1A1),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  readOnly: readOnly,
                  maxLength: label == '姓名' ? 50 : null,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF669FA5),
            colorScheme: const ColorScheme.light(primary: Color(0xFF669FA5)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _birthdateController.text = _dateFormat.format(pickedDate);
        DatabaseHelper.userInfo["birthday"] = _dateFormat.format(pickedDate);
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        DatabaseHelper.userInfo["picture"] = _profileImage;
      });
    }
  }

  Widget _buildGenderSelection() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF669FA5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '性別',
            style: TextStyle(
              color: Color(0xFF669FA5),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(width: 1),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGenderOption('女'),
                _buildGenderOption('男'),
                _buildGenderOption('其他'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: Radio<String>(
            value: gender,
            groupValue: genderMap[_selectedGender],
            onChanged: (String? value) {
              setState(() {
                if (value == "男") {
                  _selectedGender = "M";
                } else if (value == "女") {
                  _selectedGender = "F";
                } else if (value == "其他") {
                  _selectedGender = "Other";
                }
                DatabaseHelper.userInfo["gender"] = _selectedGender;
              });
            },
            fillColor: WidgetStateProperty.resolveWith<Color>(
              (states) => const Color(0xFF669FA5),
            ),
          ),
        ),
        Text(
          gender,
          style: const TextStyle(
            color: Color(0xFF669FA5),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
