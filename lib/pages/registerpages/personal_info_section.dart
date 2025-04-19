import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 用於選擇或拍攝照片
import 'package:intl/intl.dart'; // 用來格式化日期
import 'dart:io'; // 用於處理文件

class PersonalInfoSection extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const PersonalInfoSection({super.key, required this.onDataChanged});
  @override
  // ignore: library_private_types_in_public_api
  _PersonalInfoSectionState createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  String? _selectedGender;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  File? _profileImage;
  String? _errorMessage = "";

  Map<String, dynamic> getPersonalInfo() {
    return {
      'name': _nameController.text,
      'birthday': _birthdateController.text,
      'gender': _selectedGender,
      'profileImage': _profileImage,
    };
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (_nameController.text.length > 50) {
        setState(() {
          _errorMessage = "姓名長度不可超過50";
        });
      } else {
        if (_errorMessage != null) {
          setState(() {
            _errorMessage = null;
          });
        }
      }
      _sendData();
    });
    _birthdateController.addListener(_sendData);
  }

  void _sendData() {
    widget.onDataChanged({
      'name': _nameController.text,
      'birthday': _birthdateController.text,
      'gender': _selectedGender,
      'profileImage': _profileImage, // 只回傳路徑，避免直接傳 `File`
    });
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
                    controller: _nameController, // 可輸入文字
                    readOnly: false, // 允許輸入
                    onTap: null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: '生日',
                    hint: 'YYYY-MM-DD',
                    controller: _birthdateController,
                    readOnly: true, // 禁止手動輸入
                    onTap: _pickDate, // 點擊開啟月曆
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
              onTap: onTap, // 讓生日欄位點擊時開啟日期選擇器
              child: AbsorbPointer(
                absorbing: readOnly, // 讓生日欄位無法手動輸入
                child: TextFormField(
                  controller: controller, // **這裡加上 controller**
                  style: const TextStyle(
                      color: Color.fromARGB(255, 61, 103, 108), fontSize: 14), // 輸入文字大小
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Color(0xFFA5A1A1),
                      fontSize: 14, // 提示字體
                    ),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  readOnly: readOnly, // 生日欄位不能手動輸入
                  maxLength: label == '姓名' ? 50 : null, // 只限制姓名欄
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 打開日期選擇器
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
        _birthdateController.text = _dateFormat.format(pickedDate); // 更新輸入框顯示
      });
    }
  }

  // 選擇或拍攝圖片
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
      _sendData();
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 均勻分布性別選項
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
          const SizedBox(width: 1), // 與選項間的間距
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 均勻分布選項
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
            value: gender, // UI 顯示的選項 "男", "女", "其他"
            groupValue: _selectedGender == "M"
                ? "男"
                : _selectedGender == "F"
                    ? "女"
                    : _selectedGender == "Other"
                        ? "其他"
                        : null, // 確保 groupValue 與 value 一致
            onChanged: (String? value) {
              setState(() {
                // 轉換 UI 選項為存儲值
                if (value == "男") {
                  _selectedGender = "M";
                } else if (value == "女") {
                  _selectedGender = "F";
                } else if (value == "其他") {
                  _selectedGender = "Other";
                }
                _sendData(); // 更新數據
              });
            },
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              return const Color(0xFF669FA5);
            }),
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
