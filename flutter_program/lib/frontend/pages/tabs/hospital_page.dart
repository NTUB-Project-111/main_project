import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:drw/backend/services/google_map.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drw/frontend/views/hospital_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String getPhotoUrl(String? reference) {
  final key = dotenv.env['GOOGLE_MAPS_API_KEY'];
  if (reference == null || reference.isEmpty || key == null) return '';
  return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$reference&key=$key';
}

class HospitalPage extends StatelessWidget {
  const HospitalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HospitalView(),
      child: const _HospitalPageView(),
    );
  }
}

class _HospitalPageView extends StatefulWidget {
  const _HospitalPageView();

  @override
  State<_HospitalPageView> createState() => _HospitalPageViewState();
}

class _HospitalPageViewState extends State<_HospitalPageView> {
  final GoogleMapService _mapService = GoogleMapService();
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  String? _selectedHospitalPhotoUrl;

  Future<void> _fetchPhotoFor(String placeName) async {
    final key = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (key == null) return;

    try {
      // 文字搜尋拿 place_id
      final textUrl = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?'
          'query=${Uri.encodeComponent(placeName)}&key=$key');
      final tRes = await http.get(textUrl);
      final tJson = json.decode(tRes.body);
      if (tJson['status'] == 'OK' && (tJson['results'] as List).isNotEmpty) {
        final placeId = tJson['results'][0]['place_id'];
        // 用 details 拿照片
        final detUrl =
            Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?'
                'place_id=$placeId&fields=photo&key=$key');
        final dRes = await http.get(detUrl);
        final dJson = json.decode(dRes.body);
        final photos = dJson['result']?['photos'] as List?;
        if (photos != null && photos.isNotEmpty) {
          final ref = photos[0]['photo_reference'];
          final photoUrl =
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400'
              '&photoreference=$ref&key=$key';
          setState(() {
            _selectedHospitalPhotoUrl = photoUrl;
          });
          return;
        }
      }
    } catch (e) {
      // ignore
    }
    // 若失敗或沒照片
    setState(() => _selectedHospitalPhotoUrl = null);
  }

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final latLng = await _mapService.getCurrentLocation();
    if (!mounted) return;

    if (latLng != null) {
      setState(() => _currentPosition = latLng);

      final hospitalView = Provider.of<HospitalView>(context, listen: false);

      // 自動搜尋使用者附近的醫院
      await hospitalView.fetchHospitalsByDistance(latLng);

      // 使用紅色圖釘標記（下面②你會新增 pinColor）
      await _mapService.setMarkers(
        hospitalView.hospitals,
        (selectedHospital) {
          hospitalView.selectHospital(selectedHospital);
          _fetchPhotoFor(selectedHospital.name);
        },
        latLng,
        pinColor: BitmapDescriptor.hueRed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _mapService,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 229, 248, 248),
        body: Consumer<HospitalView>(
          builder: (context, hospital, _) {
            return Stack(
              children: [
                Column(
                  children: [
                    if (hospital.showDropDownForm) _buildDropdownUI(hospital),
                    if (!hospital.showDropDownForm) _buildTopBar(hospital),
                    Expanded(
                      child: _currentPosition == null
                          ? Center(child: FrontUtil.loading())
                          : Consumer<GoogleMapService>(
                              builder: (context, mapService, _) {
                                return mapService.buildGoogleMap(
                                  currentPosition: _currentPosition!,
                                  onMapCreated: (controller) =>
                                      _mapController = controller,
                                );
                              },
                            ),
                    ),
                  ],
                ),
                if (hospital.showHospitalInfo)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildHospitalCard(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdownUI(HospitalView hospital) => Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom:
                BorderSide(color: Color.fromARGB(255, 90, 141, 147), width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text(
                    '附近醫院',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 2.5,
                        color: Color(0xFF669FA5)),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.close_outlined),
                    onPressed: hospital.toggleMode),
              ],
            ),
            const SizedBox(height: 12),
            _buildDropdownRow(
                '縣市', '請選擇縣市', hospital.counties, hospital.selectedCounty,
                (value) async {
              hospital.selectedCounty = value;
              hospital.selectedDistrict = null;
              hospital.selectedDepartment = null;
              await hospital.loadDistricts(value!);
            }),
            const SizedBox(height: 12),
            _buildDropdownRow(
                '地區',
                '請選擇地區',
                hospital.districts,
                hospital.selectedDistrict,
                hospital.selectedCounty != null
                    ? (value) async {
                        hospital.selectedDistrict = value;
                        hospital.selectedDepartment = null;
                        await hospital.loadDepartments(
                            hospital.selectedCounty!, value!);
                      }
                    : null),
            const SizedBox(height: 12),
            _buildDropdownRow(
                '醫療部門',
                '請選擇部門',
                hospital.departments,
                hospital.selectedDepartment,
                hospital.selectedDistrict != null
                    ? (value) => hospital.selectedDepartment = value
                    : null),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF669FA5),
                shape: const StadiumBorder(),
                minimumSize: const Size(80, 38),
              ),
              onPressed: () async {
                hospital.toggleMode();
                hospital.toggleShowMode();
                final hospitalView =
                    Provider.of<HospitalView>(context, listen: false);
                await hospitalView.fetchHospitals();
                _mapService.setMarkers(
                  hospitalView.hospitals,
                  (selectedHospital) {
                    hospitalView.selectHospital(selectedHospital);
                    _fetchPhotoFor(selectedHospital.name);
                  },
                  _currentPosition!,
                  pinColor: BitmapDescriptor.hueRed,
                );
                // for (var hospital in hospitalView.hospitals) {
                //   debugPrint(hospital.toString());
                // }
              },
              child: const Text('查詢', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
// Top Bar UI
  Widget _buildTopBar(HospitalView hospital) => Container(
        padding: const EdgeInsets.only(left: 25, right: 12, top: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: Color(0xFF589399), width: 2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '附近醫院',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 2.5,
                color: Color(0xFF669FA5),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.search), onPressed: hospital.toggleMode),
          ],
        ),
      );

  // 醫院卡片 UI
// 醫院卡片 UI（右上角：星星＋營業狀態；下一行才是名稱）
  Widget _buildHospitalCard() {
    return Consumer2<HospitalView, GoogleMapService>(
      builder: (context, hospital, mapService, _) {
        final selected = hospital.selectedHospital;
        if (selected == null) return const SizedBox();

        return Align(
          alignment: Alignment.bottomCenter,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.down,
            onDismissed: (_) => hospital.toggleShowMode(),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 上方拖把
                  Container(
                    width: 80,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(50, 88, 146, 153),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),

                  // ❶ 右上角：星星 + 營業狀態（與標題分開一行）
                  // ❶ 右上角：星星 + 營業狀態（與標題分開一行）
                  Row(
                    children: [
                      const Spacer(),
                      // 圖示依目前是否加星而變化
                      IconButton(
                        tooltip: '收藏 / 取消收藏',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          mapService.isStarred(selected.id)
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 22,
                          color: const Color(0xFF669FA5),
                        ),
                        onPressed: () async {
                          // 1) 切換該院所的收藏狀態
                          mapService.toggleStar(selected.id);

                          // 2) 重新繪製地圖上的 markers（用現有的清單與位置）
                          final hv =
                              Provider.of<HospitalView>(context, listen: false);
                          if (_currentPosition != null &&
                              hv.hospitals.isNotEmpty) {
                            await _mapService.setMarkers(
                              hv.hospitals,
                              (h) {
                                hv.selectHospital(h);
                                _fetchPhotoFor(h.name);
                              },
                              _currentPosition!,
                              pinColor: BitmapDescriptor.hueRed,
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selected.openStatus ?? '未營業',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: (selected.openStatus == '營業中')
                              ? Colors.red
                              : const Color(0xFF9AA7AD),
                        ),
                      ),
                    ],
                  ),

                  // ❷ 主內容：左圖 + 右文字
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 左側圖片
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _selectedHospitalPhotoUrl != null
                            ? Image.network(
                                _selectedHospitalPhotoUrl!,
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'images/hospital.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'images/hospital.png',
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 16),

                      // 右側：標題 + 資訊
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ❸ 醫院名稱（獨立一行）
                            Text(
                              selected.name,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.2,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF589399),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),

                            _buildInfoRow(
                              Icons.location_on_outlined,
                              selected.address,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 6),
                            _buildInfoRow(
                                Icons.phone_outlined, '電話：${selected.phone}'),
                            const SizedBox(height: 6),
                            _buildInfoRow(Icons.directions_walk_outlined,
                                '距離：${selected.distance}'),
                            const SizedBox(height: 6),
                            _buildInfoRow(Icons.access_time_outlined,
                                '行走時間：${selected.walkTime} 分鐘'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 導航按鈕
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Icon(
                        Icons.navigation_outlined,
                        size: 18,
                        color: Color.fromRGBO(88, 147, 153, 1),
                      ),
                      label: const Text(
                        '開始導航',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(88, 147, 153, 1),
                        ),
                      ),
                      onPressed: () {
                        Provider.of<GoogleMapService>(context, listen: false)
                            .navigateToHospital(
                          selected.latitude,
                          selected.longitude,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 資訊列 UI
  Widget _buildInfoRow(IconData icon, String text, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF669FA5)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFF669FA5)),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // 通用下拉元件
  Widget _buildDropdownRow(
    String label,
    String hint,
    List<String> options,
    String? selectedValue,
    ValueChanged<String?>? onChanged,
  ) {
    final isDisabled = onChanged == null;

    return Row(
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
            border: Border.all(color: const Color(0xFF669FA5)),
          ),
          child: Center(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF669FA5),
                    height: 2.5,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF669FA5)),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: isDisabled ? Colors.grey.shade200 : Colors.white,
            ),
            padding: const EdgeInsets.only(right: 10),
            child: IgnorePointer(
              ignoring: isDisabled,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  alignment: Alignment.center,
                  isExpanded: true,
                  hint: Text('----- $hint -----',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  value: selectedValue,
                  items: options
                      .map((item) => DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: item,
                            child: Text(item,
                                style: const TextStyle(fontSize: 14)),
                          ))
                      .toList(),
                  onChanged: onChanged,
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF669FA5)),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    elevation: 0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFF669FA5)),
                    ),
                  ),
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.zero,
                    height: 38,
                  ),
                  menuItemStyleData: const MenuItemStyleData(height: 38),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
