import 'dart:async';
import 'dart:convert';
import '../../services/hospital_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

/// 醫院資料模型（新增 department 欄位）
class Hospital {
  final int id;
  final String name;
  final String city;
  final String district;
  final String department;
  final String address;
  final double latitude;
  final double longitude;
  final String photoUrl; // 目前後端沒給，保留
  final String phone; // 〃
  final bool isOpen; // 〃

  Hospital({
    required this.id,
    required this.name,
    required this.city,
    required this.district,
    required this.department,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.photoUrl = '',
    this.phone = '',
    this.isOpen = false,
  });
  Hospital copyWith({
    int? id,
    String? name,
    String? city,
    String? district,
    String? department,
    String? address,
    double? latitude,
    double? longitude,
    String? photoUrl,
    String? phone,
    bool? isOpen,
  }) {
    return Hospital(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      district: district ?? this.district,
      department: department ?? this.department,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      isOpen: isOpen ?? this.isOpen,
    );
  }
}

///  主畫面 StatefulWidget
class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});
  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  final String googleApiKey = 'AIzaSyCDjOjWfvAM9JpXwMRdJVhKL77lCOfvezs';

  // ─── 地圖 & 定位 ───────────────────────────────────────
  GoogleMapController? _mapController;
  bool _isLoadingPosition = false;
  StreamSubscription<Position>? _positionStreamSubscription;
  LatLng? _currentPosition;
  final LatLng _defaultPosition = const LatLng(25.0336, 121.5646);

  // ─── 資料與篩選 ────────────────────────────────────────
  final List<Hospital> _allHospitals = [];
  List<Hospital> _filteredHospitals = [];
  Set<Marker> _markers = {};
  List<String> _cities = [];
  List<String> _districts = [];
  List<String> _departments = []; // ★ 新增
  String _selectedCity = '';
  String _selectedDistrict = '';
  String _selectedDepartment = ''; // ★ 新增
  bool _isSearchActive = false;
  Hospital? _selectedHospital;
  String? _selectedHospitalPhotoUrl;
  bool _isCitiesLoaded = false;

  // ============ 新增：抓取 Google 照片函式 ============
  Future<String?> fetchHospitalPhoto(String hospitalName) async {
    try {
      final textSearchUrl = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(hospitalName)}&key=$googleApiKey');
      final textSearchRes = await http.get(textSearchUrl);
      final textSearchData = jsonDecode(textSearchRes.body);

      if (textSearchData['status'] == 'OK') {
        final placeId = textSearchData['results'][0]['place_id'];
        final detailUrl = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photo&key=$googleApiKey');
        final detailRes = await http.get(detailUrl);
        final detailData = jsonDecode(detailRes.body);

        if (detailData['status'] == 'OK' && detailData['result']['photos'] != null) {
          final photoRef = detailData['result']['photos'][0]['photo_reference'];
          final photoUrl =
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoRef&key=$googleApiKey';
          return photoUrl;
        }
      }
    } catch (e) {
      print('抓取 Google 照片錯誤: $e');
    }
    return null;
  }

  Future<void> _loadCities() async {
    try {
      final cities = await HospitalService.fetchCities();
      print("抓到城市了：$cities");
      setState(() {
        _cities = cities;
        _isCitiesLoaded = true;
      });
    } catch (e) {
      print('載入城市失敗：$e');
      setState(() {
        _isCitiesLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadHospitalsAndGeocode();
    _loadCities();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: const SnackBarAction(
          label: '設定',
          onPressed: Geolocator.openAppSettings,
        ),
      ),
    );
  }

  //取得手機定位並處理權限
  // ─── 1. 取得使用者位置 ─────────────────────────────────
  Future<void> _determinePosition() async {
    setState(() => _isLoadingPosition = true);

    if (!await Geolocator.isLocationServiceEnabled()) {
      _showLocationError('請先開啟定位服務');
      setState(() => _isLoadingPosition = false);
      return;
    }

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      _showLocationError('定位權限未允許');
      setState(() => _isLoadingPosition = false);
      return;
    }

    try {
      //取得定位座標
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _currentPosition = LatLng(pos.latitude, pos.longitude);

      //抓所有醫院（城市可以依你資料庫有的來換）
      final raw = await HospitalService.fetchHospitals(city: '台北市'); // 或不填 city 改成全抓
      final hospitals = raw
          .map((m) => Hospital(
                id: m['id'],
                name: m['name'],
                city: m['city'],
                district: m['district'],
                department: m['department'] ?? '',
                address: m['address'],
                latitude: m['lat']?.toDouble() ?? 0.0,
                longitude: m['lng']?.toDouble() ?? 0.0,
                phone: m['phone'] ?? '',
              ))
          .toList();

      //依距離排序並取前 10 筆
      hospitals.sort((a, b) {
        double distA = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          a.latitude,
          a.longitude,
        );
        double distB = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          b.latitude,
          b.longitude,
        );
        return distA.compareTo(distB);
      });

      final top10 = hospitals.take(10).toList();

      //更新資料與地圖
      setState(() {
        _allHospitals
          ..clear()
          ..addAll(top10);
        _filteredHospitals = List.from(top10);
        _updateMarkers();
      });

      _moveCameraToCurrentPosition();
    } catch (e) {
      _showLocationError('獲取位置失敗：$e');
    } finally {
      setState(() => _isLoadingPosition = false);
    }
  }

  //從 API 讀資料並 geocode ─────────────────────────
  Future<LatLng> _geocodeAddress(String addr) async {
    List<Location> locs = await locationFromAddress(addr);
    return LatLng(locs.first.latitude, locs.first.longitude);
  }

  Future<void> _loadHospitalsAndGeocode() async {
    //只拿文字，用它立刻填 _cities/_districts/_departments
    final raw =
        await HospitalService.fetchHospitals(city: _selectedCity.isEmpty ? '台北市' : _selectedCity);
    final tmp = raw
        .map((m) => Hospital(
              id: m['id'],
              name: m['name'],
              city: m['city'],
              district: m['district'],
              department: m['department'] ?? '',
              address: m['address'],
              latitude: 0,
              longitude: 0,
              photoUrl: m['photoUrl'] ?? '',
              phone: m['phone'] ?? '',
              isOpen: false, // 或根據你的資料庫資料
            ))
        .toList();

    setState(() {
      _allHospitals
        ..clear()
        ..addAll(tmp);
      _filteredHospitals = List.from(tmp);
      _cities = tmp.map((h) => h.city).toSet().toList();
      _districts = tmp.map((h) => h.district).toSet().toList();
      _departments = tmp.map((h) => h.department).toSet().toList();
    });

    //幕後再跑反向 geocode，更新每筆的 latitude/longitude
    for (var i = 0; i < tmp.length; i++) {
      try {
        final c = await _geocodeAddress(tmp[i].address);
        tmp[i] = tmp[i].copyWith(
          latitude: c.latitude,
          longitude: c.longitude,
        );
      } catch (_) {}
    }
    setState(_updateMarkers);
  }

  //半徑內自動篩選 ─────────────────────────────────
  void _filterHospitalsByRadius() {
    if (_isSearchActive || _currentPosition == null) return;
    const double r = 3000.0;
    var near = _allHospitals.where((h) {
      double d = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        h.latitude,
        h.longitude,
      );
      return d <= r;
    }).toList();
    setState(() => _filteredHospitals = near);
    _updateMarkers();
  }

  //根據下拉選單篩選（不受半徑限制） ───────────────────
  Future<void> _filterHospitals() async {
    if (_selectedCity.isEmpty) return;

    try {
      final raw = await HospitalService.fetchHospitals(
        city: _selectedCity,
        district: _selectedDistrict,
        dept: _selectedDepartment,
      );
      final tmp = raw
          .map((m) => Hospital(
                id: m['id'],
                name: m['name'],
                city: m['city'],
                district: m['district'],
                department: m['department'] ?? '',
                address: m['address'],
                latitude: m['lat']?.toDouble() ?? 0.0,
                longitude: m['lng']?.toDouble() ?? 0.0,
                photoUrl: m['photoUrl'] ?? '',
                phone: m['phone'] ?? '',
                isOpen: false,
              ))
          .toList();

      setState(() {
        _filteredHospitals = tmp;
        _updateMarkers();
        _selectedHospital = null;
      });

      if (tmp.isNotEmpty) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(tmp.first.latitude, tmp.first.longitude),
          ),
        );
      } else {
        _moveCameraToCurrentPosition();
      }
    } catch (e) {
      print('搜尋失敗：$e');
      _moveCameraToCurrentPosition();
    }
  }

  //更新地圖標記 ─────────────────────────────────
  void _updateMarkers() {
    var markers = <Marker>{};
    if (_currentPosition != null) {
      markers.add(Marker(
        markerId: const MarkerId('me'),
        position: _currentPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
    }
    for (var h in _filteredHospitals) {
      markers.add(Marker(
        markerId: MarkerId(h.id.toString()),
        position: LatLng(h.latitude, h.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: h.name,
          snippet: h.address,
          onTap: () async {
            setState(() {
              _selectedHospital = h;
              _selectedHospitalPhotoUrl = null; // 重置，避免殘留舊圖
            });
            final fetchedPhotoUrl = await fetchHospitalPhoto(h.name);
            if (fetchedPhotoUrl != null) {
              setState(() {
                _selectedHospitalPhotoUrl = fetchedPhotoUrl;
              });
            }
          },
        ),
      ));
    }
    setState(() => _markers = markers);
  }

  void _moveCameraToCurrentPosition() {
    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14),
        ),
      );
    }
  }

  //若需要持續監聽位置變化
  void _startPositionStream() {
    bool isFirstPosition = true;
    _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _filterHospitalsByRadius();
      if (isFirstPosition) {
        _moveCameraToCurrentPosition();
        isFirstPosition = false;
      }
    }, onError: (error) {
      _showLocationError('監聽位置變化時發生錯誤：$error');
    });
  }

  /// 搜尋面板：啟動搜尋後停用 3 公里自動篩選
  void _showSearchPanel() {
    // 啟用搜尋模式，停用 3 公里篩選
    setState(() {
      _isSearchActive = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 10, bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "搜尋醫院",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Color(0xFF669FA5),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              child: const Icon(
                                Icons.close,
                                size: 20.0,
                                color: Color(0xFF589393),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 28.0, bottom: 0.0),
                    ),
                    // ===== 縣市 Dropdown =====
                    // 縣市 Dropdown
                    _buildDropdown(
                      label: "縣市",
                      isLoading: !_isCitiesLoaded,
                      selectedValue: _selectedCity,
                      items: _cities,
                      hintText: "---請選擇縣市---",
                      onChanged: (newCity) async {
                        if (newCity == null) return;
                        setModalState(() {
                          _selectedCity = newCity;
                          _selectedDistrict = '';
                          _departments = [];
                        });
                        try {
                          final districts = await HospitalService.fetchDistricts(newCity);
                          setModalState(() {
                            _districts = districts;
                          });
                        } catch (e) {
                          print('載入地區失敗：$e');
                          setModalState(() {
                            _districts = [];
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // 地區 Dropdown
                    _buildDropdown(
                      label: "地區",
                      isLoading: false,
                      selectedValue: _selectedDistrict,
                      items: _districts,
                      hintText: "---請選擇地區---",
                      onChanged: (newDist) async {
                        if (newDist == null) return;
                        setModalState(() {
                          _selectedDistrict = newDist;
                          _selectedDepartment = '';
                        });
                        if (_selectedCity.isNotEmpty) {
                          try {
                            final departments =
                                await HospitalService.fetchDepartments(_selectedCity, newDist);
                            setModalState(() {
                              _departments = departments;
                            });
                          } catch (e) {
                            print('載入部門失敗：$e');
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // 醫療部門 Dropdown
                    _buildDropdown(
                      label: "醫療部門",
                      labelWidth: 120, // 給更寬的 label
                      isLoading: false,
                      selectedValue: _selectedDepartment,
                      items: _departments,
                      hintText: "---請選擇部門---",
                      onChanged: (value) {
                        setModalState(() {
                          _selectedDepartment = value ?? '';
                        });
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 70,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF669FA5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _filterHospitals();
                              Navigator.pop(context);
                              FocusScope.of(context).unfocus(); // 關閉鍵盤
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              '查詢',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header 區塊
        Container(
          padding: const EdgeInsets.fromLTRB(26, 36, 14, 5),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF589399),
                width: 2,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "附近醫院",
                    style: TextStyle(
                      color: Color(0xFF589399),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _showSearchPanel,
                        tooltip: '篩選醫院',
                      ),
                      IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: _isLoadingPosition ? null : _moveCameraToCurrentPosition,
                        tooltip: '回到我的位置',
                      ),
                    ],
                  )
                ],
              ),
              // 可加入選單等其他內容
            ],
          ),
        ),

        // 地圖區塊 - 使用 Expanded 撐滿剩餘空間
        Expanded(
          child: Stack(
            children: [
              _buildGoogleMap(),
              if (_selectedHospital != null) _buildHospitalInfoCard(_selectedHospital!),
              if (_isLoadingPosition)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required bool isLoading,
    required String? selectedValue,
    required List<String> items,
    required String hintText,
    required ValueChanged<String?> onChanged,
    double labelWidth = 89, // 預設寬度，醫療部門會用到更寬的
  }) {
    return Row(
      children: [
        // Label 區塊
        Container(
          width: labelWidth,
          height: 37,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16.0,
                color: Color(0xFF589393),
              ),
            ),
          ),
        ),

        // Dropdown 區塊
        Expanded(
          child: Container(
            height: 37,
            margin: const EdgeInsets.only(left: 6.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: Colors.grey),
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedValue?.isEmpty ?? true ? null : selectedValue,
                      hint: Text(
                        hintText,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(174, 174, 174, 1),
                        ),
                      ),
                      items: items.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              color: selectedValue == item ? const Color(0xFF589393) : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: onChanged,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// 建立 GoogleMap Widget
  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: (controller) {
        _mapController = controller;
        if (_currentPosition != null) {
          _moveCameraToCurrentPosition();
        }
      },
      initialCameraPosition: CameraPosition(
        target: _currentPosition ?? _defaultPosition,
        zoom: 14.0,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      compassEnabled: true,
      mapToolbarEnabled: false,
      onTap: (_) {
        if (_selectedHospital != null) {
          setState(() {
            _selectedHospital = null;
          });
        }
      },
    );
  }

  /// 建立醫院資訊卡 Widget
  Widget _buildHospitalInfoCard(Hospital hospital) {
    // 計算使用者與醫院間的距離及預估步行時間（假設 80 公尺/分鐘）
    String computedDistance = '';
    String computedWalkingTime = '';
    if (_currentPosition != null) {
      // 計算距離
      double distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        hospital.latitude,
        hospital.longitude,
      );

      // 格式化成「xxx 公尺」或「x.x 公里」
      if (distanceInMeters < 1000) {
        computedDistance = '${distanceInMeters.round()} 公尺';
      } else {
        computedDistance = '${(distanceInMeters / 1000).toStringAsFixed(1)} 公里';
      }

      // 預估步行時間
      int walkTime = (distanceInMeters / 80).ceil();
      computedWalkingTime = '$walkTime 分鐘';
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.down,
        onDismissed: (_) {
          if (mounted) {
            setState(() {
              _selectedHospital = null;
            });
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: _selectedHospitalPhotoUrl != null
                            ? Image.network(
                                _selectedHospitalPhotoUrl!,
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 120,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    height: 120,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    height: 120,
                                    color: Colors.grey[200],
                                    child:
                                        Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
                                  );
                                },
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 120,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  hospital.name,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(88, 147, 153, 1),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (hospital.isOpen)
                                const Text(
                                  '營業中',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else
                                const Text(
                                  '休息中',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.location_on_outlined, hospital.address, maxLines: 2),
                          const SizedBox(height: 4),
                          _buildInfoRow(Icons.phone_outlined, hospital.phone),
                          const SizedBox(height: 4),
                          _buildInfoRow(Icons.directions_walk_outlined, '距離：$computedDistance'),
                          const SizedBox(height: 4),
                          _buildInfoRow(Icons.access_time_outlined, '預計：$computedWalkingTime'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: Image.asset(
                      'assets/Maps_icon.png',
                      height: 18,
                      width: 18,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.navigation_outlined, size: 18),
                    ),
                    label: const Text(
                      '開始導航',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromRGBO(88, 147, 153, 1),
                      ),
                    ),
                    onPressed: () async {
                      if (_currentPosition == null) {
                        _showLocationError('無法獲取您目前的位置以進行導航');
                        return;
                      }
                      final uri = Uri.parse(
                          'https://www.google.com/maps/dir/?api=1&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${hospital.latitude},${hospital.longitude}&travelmode=driving');
                      try {
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          _showLocationError('無法開啟 Google Maps 應用程式');
                        }
                      } catch (e) {
                        _showLocationError('開啟導航時發生錯誤');
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(88, 147, 153, 1),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 輔助函數：建立帶圖標的資訊行
  Widget _buildInfoRow(IconData icon, String text, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: const Color.fromRGBO(88, 147, 153, 0.8)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(88, 147, 153, 1),
              height: 1.3,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
