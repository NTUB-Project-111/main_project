// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:drw/backend/models/hospital_model.dart';
// // import 'package:drw/backend/services/apibase.dart';
// // import 'package:drw/backend/services/hospital_service.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:flutter/foundation.dart'; 

// // class HospitalView extends ChangeNotifier {
// //   bool showDropDownForm = false;
// //   bool showHospitalInfo = false;
// //   String? _selectedCounty;
// //   String? _selectedDistrict;
// //   String? _selectedDepartment;
// //   List<String> counties = [
// //     '臺北市',
// //     '新北市',
// //     '桃園市',
// //     '臺中市',
// //     '臺南市',
// //     '高雄市',
// //     '基隆市',
// //     '新竹市',
// //     '嘉義市',
// //     '新竹縣',
// //     '苗栗縣',
// //     '彰化縣',
// //     '南投縣',
// //     '雲林縣',
// //     '嘉義縣',
// //     '宜蘭縣',
// //     '花蓮縣',
// //     '臺東縣',
// //     '澎湖縣',
// //     '金門縣',
// //     '連江縣'
// //   ];
// //   List<String> districts = [];
// //   List<String> departments = [];
// //   List<Hospital> hospitals = [];
// //   Hospital? selectedHospital;


// //   void selectHospital(Hospital hospital) {
// //     selectedHospital = hospital;
// //     showHospitalInfo = true;
// //     notifyListeners();
// //   }

// //   final HospitalService _hospitalService = HospitalService();

// //   void toggleMode() {
// //     showDropDownForm = !showDropDownForm;
// //     notifyListeners();
// //   }

// //   void toggleShowMode() {
// //     showHospitalInfo = !showHospitalInfo;
// //     notifyListeners();
// //   }

// // Future<void> fetchHospitalsByDistance(LatLng userLocation) async {
// //   try {
// //     hospitals = await _hospitalService.fetchHospitalsByDistance(userLocation);
// //     notifyListeners();
// //   } catch (e) {
// //     debugPrint('fetchHospitalsByDistance 發生錯誤: $e');
// //   }
// // }

// //   Future loadDistricts(String city) async {
// //     selectedDistrict = null; // 清除舊選擇
// //     selectedDepartment = null;
// //     departments = []; // 清除舊的科別
// //     notifyListeners();
// //     try {
// //       districts = await _hospitalService.fetchDistricts(city);
// //       // debugPrint('區域：$districts');
// //       notifyListeners();
// //     } catch (e) {
// //       debugPrint('載入失敗: $e');
// //     }
// //   }

// //   Future loadDepartments(String city, String district) async {
// //     selectedDepartment = null;
// //     departments = [];
// //     notifyListeners(); // 只 UI 清空

// //     try {
// //       departments = await _hospitalService.fetchDepartments(city, district);
// //       // debugPrint('取得科別清單：$departments');
// //       notifyListeners();
// //     } catch (e) {
// //       debugPrint('錯誤：$e');
// //     }
// //   }

// //   String? get selectedCounty => _selectedCounty;
// //   set selectedCounty(String? value) {
// //     _selectedCounty = value;
// //     selectedDistrict = null;
// //     selectedDepartment = null;
// //     notifyListeners();
// //   }

// //   String? get selectedDistrict => _selectedDistrict;
// //   set selectedDistrict(String? value) {
// //     _selectedDistrict = value;
// //     selectedDepartment = null;
// //     notifyListeners();
// //   }

// //   String? get selectedDepartment => _selectedDepartment;
// //   set selectedDepartment(String? value) {
// //     _selectedDepartment = value;
// //     notifyListeners();
// //   }



// //   Future<void> fetchHospitals() async {
// //     if (_selectedCounty == null) return;

// //     try {
// //       final List<Map<String, dynamic>> rawData = await _hospitalService.fetchHospitals(
// //         city: _selectedCounty!,
// //         district: _selectedDistrict ?? '',
// //         dept: _selectedDepartment ?? '',
// //       );
// //       hospitals = rawData.map((json) => Hospital.fromJson(json)).toList();
// //       notifyListeners();
// //     } catch (e) {
// //       debugPrint('醫院查詢失敗: $e');
// //     }
// //   }
// // }

// import 'package:drw/backend/models/hospital_model.dart';
// import 'package:drw/backend/services/hospital_service.dart';
// import 'package:flutter/material.dart';

// class HospitalView extends ChangeNotifier {
//   bool showDropDownForm = false;
//   bool showHospitalInfo = false;
//   String? _selectedCounty;
//   String? _selectedDistrict;
//   String? _selectedDepartment;
//   List<String> counties = [
//     '臺北市',
//     '新北市',
//     '桃園市',
//     '臺中市',
//     '臺南市',
//     '高雄市',
//     '基隆市',
//     '新竹市',
//     '嘉義市',
//     '新竹縣',
//     '苗栗縣',
//     '彰化縣',
//     '南投縣',
//     '雲林縣',
//     '嘉義縣',
//     '宜蘭縣',
//     '花蓮縣',
//     '臺東縣',
//     '澎湖縣',
//     '金門縣',
//     '連江縣'
//   ];
//   List<String> districts = [];
//   List<String> departments = [];
//   List<Hospital> hospitals = [];
//   Hospital? selectedHospital;


//   void selectHospital(Hospital hospital) {
//     selectedHospital = hospital;
//     showHospitalInfo = true;
//     notifyListeners();
//   }

//   final HospitalService _hospitalService = HospitalService();

//   void toggleMode() {
//     showDropDownForm = !showDropDownForm;
//     notifyListeners();
//   }

//   void toggleShowMode() {
//     showHospitalInfo = !showHospitalInfo;
//     notifyListeners();
//   }

//   Future loadDistricts(String city) async {
//     selectedDistrict = null; // 清除舊選擇
//     selectedDepartment = null;
//     departments = []; // 清除舊的科別
//     notifyListeners();
//     try {
//       districts = await _hospitalService.fetchDistricts(city);
//       // debugPrint('區域：$districts');
//       notifyListeners();
//     } catch (e) {
//       debugPrint('載入失敗: $e');
//     }
//   }

//   Future loadDepartments(String city, String district) async {
//     selectedDepartment = null;
//     departments = [];
//     notifyListeners(); // 只 UI 清空

//     try {
//       departments = await _hospitalService.fetchDepartments(city, district);
//       // debugPrint('取得科別清單：$departments');
//       notifyListeners();
//     } catch (e) {
//       debugPrint('錯誤：$e');
//     }
//   }

//   String? get selectedCounty => _selectedCounty;
//   set selectedCounty(String? value) {
//     _selectedCounty = value;
//     selectedDistrict = null;
//     selectedDepartment = null;
//     notifyListeners();
//   }

//   String? get selectedDistrict => _selectedDistrict;
//   set selectedDistrict(String? value) {
//     _selectedDistrict = value;
//     selectedDepartment = null;
//     notifyListeners();
//   }

//   String? get selectedDepartment => _selectedDepartment;
//   set selectedDepartment(String? value) {
//     _selectedDepartment = value;
//     notifyListeners();
//   }

//   Future<void> fetchHospitals() async {
//     if (_selectedCounty == null) return;

//     try {
//       final List<Map<String, dynamic>> rawData = await _hospitalService.fetchHospitals(
//         city: _selectedCounty!,
//         district: _selectedDistrict ?? '',
//         dept: _selectedDepartment ?? '',
//       );
//       hospitals = rawData.map((json) => Hospital.fromJson(json)).toList();
//       notifyListeners();
//     } catch (e) {
//       debugPrint('醫院查詢失敗: $e');
//     }
//   }
// }

import 'package:drw/backend/models/hospital_model.dart';
import 'package:drw/backend/services/hospital_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalView extends ChangeNotifier {
  bool showDropDownForm = false;
  bool showHospitalInfo = false;

  String? _selectedCounty;
  String? _selectedDistrict;
  String? _selectedDepartment;

  List<String> counties = const [
    '臺北市', '新北市', '桃園市', '臺中市', '臺南市', '高雄市',
    '基隆市', '新竹市', '嘉義市', '新竹縣', '苗栗縣', '彰化縣',
    '南投縣', '雲林縣', '嘉義縣', '宜蘭縣', '花蓮縣', '臺東縣',
    '澎湖縣', '金門縣', '連江縣'
  ];
  List<String> districts = [];
  List<String> departments = [];
  List<Hospital> hospitals = [];
  Hospital? selectedHospital;

  final HospitalService _hospitalService = HospitalService();

  void selectHospital(Hospital hospital) {
    selectedHospital = hospital;
    showHospitalInfo = true;
    notifyListeners();
  }

  void toggleMode() {
    showDropDownForm = !showDropDownForm;
    notifyListeners();
  }

  void toggleShowMode() {
    showHospitalInfo = !showHospitalInfo;
    notifyListeners();
  }

Future<void> fetchHospitalsByDistance(LatLng userLocation) async {
    try {
      hospitals = await _hospitalService.fetchHospitalsByDistance(userLocation);
      if (hospitals.isNotEmpty) {
        // 自動選最近的第一筆
        selectHospital(hospitals.first);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('fetchHospitalsByDistance 發生錯誤: $e');
    }
  }


  Future loadDistricts(String city) async {
    selectedDistrict = null;
    selectedDepartment = null;
    departments = [];
    notifyListeners();
    try {
      districts = await _hospitalService.fetchDistricts(city);
      notifyListeners();
    } catch (e) {
      debugPrint('載入失敗: $e');
    }
  }

  Future loadDepartments(String city, String district) async {
    selectedDepartment = null;
    departments = [];
    notifyListeners();
    try {
      departments = await _hospitalService.fetchDepartments(city, district);
      notifyListeners();
    } catch (e) {
      debugPrint('錯誤：$e');
    }
  }

  String? get selectedCounty => _selectedCounty;
  set selectedCounty(String? value) {
    _selectedCounty = value;
    selectedDistrict = null;
    selectedDepartment = null;
    notifyListeners();
  }

  String? get selectedDistrict => _selectedDistrict;
  set selectedDistrict(String? value) {
    _selectedDistrict = value;
    selectedDepartment = null;
    notifyListeners();
  }

  String? get selectedDepartment => _selectedDepartment;
  set selectedDepartment(String? value) {
    _selectedDepartment = value;
    notifyListeners();
  }

  Future<void> fetchHospitals() async {
    if (_selectedCounty == null) return;
    try {
      final raw = await _hospitalService.fetchHospitals(
        city: _selectedCounty!,
        district: _selectedDistrict ?? '',
        dept: _selectedDepartment ?? '',
      );
      hospitals = raw.map((json) => Hospital.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('醫院查詢失敗: $e');
    }
  }
}
