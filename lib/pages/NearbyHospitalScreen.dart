import 'dart:async';
import 'package:url_launcher/url_launcher.dart'; // 導入 url_launcher
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 匯入 SVG 套件

/// 醫院資料模型
class Hospital {
  final String name;
  final String city; // 縣市
  final String district; // 地區
  final String department; // 醫療部門
  final double latitude;
  final double longitude;
  final String address;
  final String phone;
  final String distance;
  final String time;
  final bool isOpen;
  final String photoUrl;

  Hospital({
    required this.name,
    required this.city,
    required this.district,
    required this.department,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phone,
    required this.distance,
    required this.time,
    required this.isOpen,
    required this.photoUrl,
  });
}

class NearbyHospitalScreen extends StatefulWidget {
  const NearbyHospitalScreen({Key? key}) : super(key: key);

  @override
  _NearbyHospitalScreenState createState() => _NearbyHospitalScreenState();
}

class _NearbyHospitalScreenState extends State<NearbyHospitalScreen> {
  GoogleMapController? _mapController;
  bool _isLoadingPosition = false; // 用於控制加載指示器
  StreamSubscription<Position>? _positionStreamSubscription;
  LatLng? _currentPosition; // 使用者目前位置

  // 預設位置（台北101）
  final LatLng _defaultPosition = const LatLng(25.0336, 121.5646);

  final List<Hospital> _allHospitals = [
    Hospital(
      name: '國泰醫院總院',
      city: '台北市',
      district: '大安區',
      department: '內科',
      latitude: 25.033352,
      longitude: 121.543908,
      address: '台北市大安區仁愛路四段280號',
      phone: '02-27082121',
      distance: '250 公尺', // 初始值（後續會動態計算）
      time: '3 分鐘',       // 初始值（後續會動態計算）
      isOpen: true,
      photoUrl: 'https://picsum.photos/400/300?random=1',
    ),
    Hospital(
      name: '中山醫院',
      city: '台北市',
      district: '松山區',
      department: '外科',
      latitude: 25.048026,
      longitude: 121.544082,
      address: '台北市松山區南京東路XX段XXX號',
      phone: '02-12345678',
      distance: '500 公尺',
      time: '5 分鐘',
      isOpen: true,
      photoUrl: 'https://picsum.photos/400/300?random=2',
    ),
    Hospital(
      name: '國立臺灣大學醫學院附設醫院',
      city: '台北市',
      district: '中山區',
      department: '外科',
      latitude: 25.040654,
      longitude: 121.518549,
      address: '100台北市中正區中山南路7號',
      phone: '02-12345678',
      distance: '500 公尺',
      time: '5 分鐘',
      isOpen: true,
      photoUrl: 'https://picsum.photos/400/300?random=3',
    ),
    // 更多假資料...
  ];

  List<Hospital> _filteredHospitals = []; // 篩選後的醫院列表
  Set<Marker> _markers = {};
  String _selectedCity = '';
  String _selectedDistrict = '';
  String _selectedDepartment = '';
  Hospital? _selectedHospital;

  // 新增旗標：當使用者進行搜尋後停用 3 公里篩選
  bool _isSearchActive = false;

  /// 根據使用者位置篩選 3 公里內的醫療診所
  void _filterHospitalsByRadius() {
    if (_isSearchActive) return; // 搜尋模式時停用自動篩選
    if (_currentPosition == null) return;
    const double radiusInMeters = 3000.0;
    List<Hospital> nearbyHospitals = _allHospitals.where((hospital) {
      double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        hospital.latitude,
        hospital.longitude,
      );
      return distance <= radiusInMeters;
    }).toList();

    setState(() {
      _filteredHospitals = nearbyHospitals;
    });
    _updateMarkers();
  }

  @override
  void initState() {
    super.initState();
    // 初始設定：測試時固定使用者座標為台北101
    _currentPosition = _defaultPosition;
    _filteredHospitals = List.from(_allHospitals);
    _updateMarkers();
    _determinePosition();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  /// 取得使用者位置 (測試模式：固定為台北101)
  Future<void> _determinePosition() async {
    setState(() {
      _isLoadingPosition = true;
    });
    try {
      // 測試模式：直接設定使用者位置為台北101
      setState(() {
        _currentPosition = _defaultPosition;
      });
      _moveCameraToCurrentPosition();
      _filterHospitalsByRadius();
      // 若需持續監聽位置變化可啟用以下 (測試時可暫停)
      // _startPositionStream();
    } catch (e) {
      _showLocationError('獲取位置時發生錯誤：$e');
    } finally {
      setState(() {
        _isLoadingPosition = false;
      });
    }
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: '設定',
          onPressed: () {
            Geolocator.openAppSettings();
          },
        ),
      ),
    );
  }

  /// 若需要持續監聽位置變化 (測試可保留或移除)
  void _startPositionStream() {
    bool isFirstPosition = true;
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
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

  void _moveCameraToCurrentPosition() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition!,
          zoom: 14.0,
        ),
      ),
    );
  }

  void _updateMarkers() {
    final Set<Marker> newMarkers = {};

    // 標記使用者位置
    if (_currentPosition != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: '我在這裡'),
        ),
      );
    }

    // 標記篩選後的醫院
    for (var hospital in _filteredHospitals) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(hospital.name),
          position: LatLng(hospital.latitude, hospital.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: hospital.name,
            snippet: hospital.address,
            onTap: () {
              setState(() {
                _selectedHospital = hospital;
              });
            },
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
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
                      padding: const EdgeInsets.only(top: 46.0, left: 26.0, bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "附近醫院",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Color(0xFF589393),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              child: Icon(
                                Icons.close,
                                size: 20.0,
                                color: Color(0xFF589393),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, bottom: 0.0),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 89,
                          height: 37,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(
                              "縣市",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF589393),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 280,
                          height: 37,
                          margin: const EdgeInsets.only(left: 6.0),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCity.isEmpty ? null : _selectedCity,
                              hint: Text(
                                '---請選擇縣市---',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromRGBO(174, 174, 174, 1),
                                ),
                              ),
                              items: <String>['台北市', '新北市', '桃園市', '台中市', '高雄市']
                                  .map((city) => DropdownMenuItem(
                                        value: city,
                                        child: Text(
                                          city,
                                          style: TextStyle(
                                            color: _selectedCity == city ? Color(0xFF589393) : Colors.black,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setModalState(() {
                                  _selectedCity = value ?? '';
                                });
                              },
                              isExpanded: true,
                              selectedItemBuilder: (BuildContext context) {
                                return <String>['台北市', '新北市', '桃園市', '台中市', '高雄市']
                                    .map<Widget>((String item) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      item,
                                      style: const TextStyle(color: Color(0xFF589393)),
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, top: 20.0, bottom: 0.0),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 89,
                          height: 37,
                          margin: const EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(
                              "地區",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF589393),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 280,
                          height: 37,
                          margin: const EdgeInsets.only(left: 6.0),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDistrict.isEmpty ? null : _selectedDistrict,
                              hint: Text(
                                '---請選擇地區---',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromRGBO(174, 174, 174, 1),
                                ),
                              ),
                              items: <String>['大安區', '信義區', '松山區', '板橋區', '中壢區', '中山區']
                                  .map((dist) => DropdownMenuItem(
                                        value: dist,
                                        child: Text(
                                          dist,
                                          style: TextStyle(
                                            color: _selectedDistrict == dist ? Color(0xFF589393) : Colors.black,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setModalState(() {
                                  _selectedDistrict = value ?? '';
                                });
                              },
                              isExpanded: true,
                              selectedItemBuilder: (BuildContext context) {
                                return <String>['大安區', '信義區', '松山區', '板橋區', '中壢區']
                                    .map<Widget>((String item) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      item,
                                      style: const TextStyle(color: Color(0xFF589393)),
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, top: 20.0, bottom: 0.0),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 37,
                          margin: const EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(
                              "醫療部門",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF589393),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 276,
                            height: 37,
                            margin: const EdgeInsets.only(left: 5.0),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedDepartment.isEmpty ? null : _selectedDepartment,
                                hint: Text(
                                  '---請選擇部門---',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(174, 174, 174, 1),
                                  ),
                                ),
                                items: <String>['內科', '外科', '骨科', '耳鼻喉科', '小兒科']
                                    .map((dept) => DropdownMenuItem(
                                          value: dept,
                                          child: Text(
                                            dept,
                                            style: TextStyle(
                                              color: _selectedDepartment == dept ? Color(0xFF589393) : Colors.black,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setModalState(() {
                                    _selectedDepartment = value ?? '';
                                  });
                                },
                                isExpanded: true,
                                selectedItemBuilder: (BuildContext context) {
                                  return <String>['內科', '外科', '骨科', '耳鼻喉科', '小兒科']
                                      .map<Widget>((String item) {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item,
                                        style: const TextStyle(color: Color(0xFF589393)),
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 70,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF669FA5),
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
                            child: Text(
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
/// 過濾醫院列表 (依據下拉選單條件搜尋，不再限制 3 公里)
  void _filterHospitals() {
    if (_selectedCity.isEmpty &&
        _selectedDistrict.isEmpty &&
        _selectedDepartment.isEmpty) {
      _filteredHospitals = List.from(_allHospitals);
    } else {
      _filteredHospitals = _allHospitals.where((hospital) {
        bool cityMatch =
            _selectedCity.isEmpty || hospital.city == _selectedCity;
        bool districtMatch =
            _selectedDistrict.isEmpty || hospital.district == _selectedDistrict;
        bool departmentMatch = _selectedDepartment.isEmpty ||
            hospital.department == _selectedDepartment;
        return cityMatch && districtMatch && departmentMatch;
      }).toList();
    }
    _updateMarkers();
    setState(() {
      _selectedHospital = null;
    });
    if (_filteredHospitals.isNotEmpty) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            _filteredHospitals.first.latitude,
            _filteredHospitals.first.longitude,
          ),
        ),
      );
    } else if (_currentPosition != null) {
      _moveCameraToCurrentPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('附近醫院'),
        backgroundColor: const Color(0xFF669FA5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchPanel,
            tooltip: '篩選醫院',
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed:
                _isLoadingPosition ? null : _moveCameraToCurrentPosition,
            tooltip: '回到我的位置',
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildGoogleMap(),
          if (_selectedHospital != null)
            _buildHospitalInfoCard(_selectedHospital!),
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF669FA5),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital), label: '附近醫院'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: '傷口拍攝'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: '紀錄'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
        onTap: (index) {
          print('Tapped index: $index');
        },
      ),
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
      myLocationEnabled: false,
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
    String computedDistance = hospital.distance;
    String computedWalkingTime = hospital.time;
    if (_currentPosition != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        hospital.latitude,
        hospital.longitude,
      );
      if (distanceInMeters < 1000) {
        computedDistance = '${distanceInMeters.round()} 公尺';
      } else {
        computedDistance = '${(distanceInMeters / 1000).toStringAsFixed(1)} 公里';
      }
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
                      child: Image.network(
                        hospital.photoUrl,
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
                            child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
                          );
                        },
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
                          _buildInfoRow(Icons.location_on_outlined, hospital.address,
                              maxLines: 2),
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
                        'https://www.google.com/maps/dir/?api=1&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${hospital.latitude},${hospital.longitude}&travelmode=driving'
                      );
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