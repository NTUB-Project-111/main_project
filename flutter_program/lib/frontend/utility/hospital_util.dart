import 'package:drw/backend/models/hospital.dart'; // 引入 Hospital 資料模型
import 'package:drw/backend/services/hospital_service.dart'; // 引入後端 API 服務
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google 地圖套件

class HospitalView extends ChangeNotifier {
  // UI 狀態
  bool showDropDownForm = false; // 控制是否顯示下拉選單表單
  bool showHospitalInfo = false; // 控制是否顯示醫院資訊卡

// 使用者選擇條件
  String? _selectedCounty; // 使用者選擇的縣市
  String? _selectedDistrict; // 使用者選擇的地區
  String? _selectedDepartment; //選擇的醫療部門

// 縣市清單（固定不變）
  List<String> counties = const [
    '臺北市', '新北市', '桃園市', '臺中市', '臺南市', '高雄市',
    '基隆市', '新竹市', '嘉義市', '新竹縣', '苗栗縣', '彰化縣',
    '南投縣', '雲林縣', '嘉義縣', '宜蘭縣', '花蓮縣', '臺東縣',
    '澎湖縣', '金門縣', '連江縣'
  ];
  List<String> districts = []; // 動態載入地區清單
  List<String> departments = []; // 動態載入醫療部門清單

  //醫院資料
  List<Hospital> hospitals = [];  // 儲存 API 回傳的醫院資料
  Hospital? selectedHospital; // 儲存 API 回傳的醫院資料

// API 服務
  final HospitalService _hospitalService = HospitalService();

//醫院選擇與 UI 控制
 // 選擇一間醫院，並顯示醫院資訊卡
  void selectHospital(Hospital hospital) {
    selectedHospital = hospital;
    showHospitalInfo = true;
    notifyListeners(); // 通知 UI 更新
  }

// 切換顯示 / 隱藏下拉選單表單
  void toggleMode() {
    showDropDownForm = !showDropDownForm;
    notifyListeners();
  }

// 切換顯示 / 隱藏醫院資訊卡
  void toggleShowMode() {
    showHospitalInfo = !showHospitalInfo;
    notifyListeners();
  }

//API 呼叫：取得附近醫院 
Future<void> fetchHospitalsByDistance(LatLng userLocation) async {
    try {
      hospitals = await _hospitalService.fetchHospitalsByDistance(userLocation); // 呼叫後端 API 取得距離最近的醫院清單
      if (hospitals.isNotEmpty) { // 如果有資料，預設選第一間
        selectHospital(hospitals.first);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('fetchHospitalsByDistance 發生錯誤: $e');
    }
  }

//API 呼叫：載入地區清單
  Future loadDistricts(String city) async {
    selectedDistrict = null; // 清空舊的選擇與科別資料
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

//API 呼叫：載入醫療部門清單
  Future loadDepartments(String city, String district) async {
    selectedDepartment = null;
    departments = [];
    notifyListeners();
    try {
      // 呼叫後端 API 取得醫療部門清單
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

//API 呼叫：依條件查詢醫院
  Future<void> fetchHospitals() async {
    if (_selectedCounty == null) return;
    try {
      // 呼叫後端 API 查詢醫院
      final raw = await _hospitalService.fetchHospitals(
        city: _selectedCounty!,
        district: _selectedDistrict ?? '',
        dept: _selectedDepartment ?? '',
      );
       // 將 API 回傳的 JSON 轉成 Hospital 物件
      hospitals = raw.map((json) => Hospital.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('醫院查詢失敗: $e');
    }
  }
}
