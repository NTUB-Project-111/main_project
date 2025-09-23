import 'package:dropdown_button2/dropdown_button2.dart';// 下拉選單 UI
import 'package:drw/backend/services/google_map.dart'; // Google 地圖服務
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 狀態管理
import 'package:drw/frontend/utility/hospital_util.dart'; // 醫院相關工具
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 取得醫院照片 URL
String getPhotoUrl(String? reference) {
  final key = dotenv.env['GOOGLE_MAPS_API_KEY'];
  if (reference == null || reference.isEmpty || key == null) return '';
  return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$reference&key=$key';
}

// 主頁面：附近醫院
class HospitalPage extends StatelessWidget {
  const HospitalPage({super.key});

  @override
  Widget build(BuildContext context) { // 用 Provider 管理 HospitalView 狀態
    return ChangeNotifierProvider(
      create: (_) => HospitalView(),
      child: const _HospitalPageView(),
    );
  }
}

// 狀態管理用 StatefulWidget
class _HospitalPageView extends StatefulWidget {
  const _HospitalPageView();

  @override
  State<_HospitalPageView> createState() => _HospitalPageViewState();
}

class _HospitalPageViewState extends State<_HospitalPageView> {
  final GoogleMapService _mapService = GoogleMapService(); // 地圖服務
  GoogleMapController? _mapController; // 地圖控制器
  LatLng? _currentPosition; // 使用者當前位置

  // 顯示醫院資訊卡時的狀態 
  String? _selectedHospitalPhotoUrl; // 醫院照片
  double _infoCardHeight = 260; // 資訊卡高度

  final GlobalKey _infoCardKey = GlobalKey();

// 透過 Google API 取得醫院照片
  Future<void> _fetchPhotoFor(String placeName) async {
    final key = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (key == null) return;

    try {  // 先用關鍵字搜尋地點
      final textUrl = Uri.parse( 
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(placeName)}&key=$key');
      final tRes = await http.get(textUrl);
      final tJson = json.decode(tRes.body);
       // 如果找到地點，再去拿照片資訊
      if (tJson['status'] == 'OK' && (tJson['results'] as List).isNotEmpty) {
        final placeId = tJson['results'][0]['place_id'];
        final detUrl = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photo&key=$key');
        final dRes = await http.get(detUrl);
        final dJson = json.decode(dRes.body);
        final photos = dJson['result']?['photos'] as List?;
         // 如果有照片，更新 UI
        if (photos != null && photos.isNotEmpty) {
          final ref = photos[0]['photo_reference'];
          setState(() {
            _selectedHospitalPhotoUrl =
                'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$ref&key=$key';
          });
          return;
        }
      }
    } catch (_) {}
    // 沒找到照片，設為空
    setState(() => _selectedHospitalPhotoUrl = null);
  }

  @override
  void initState() {
    super.initState();

    // 初始化收藏功能，預設 guest
    _mapService.initFavorites(userId: 'guest');
// 取得使用者位置並載入地圖
    _initLocation();
  }

 // 取得目前位置並顯示地圖與醫院
  Future<void> _initLocation() async {
    final latLng = await _mapService.getCurrentLocation();
    if (!mounted) return;

    if (latLng != null) {
      setState(() => _currentPosition = latLng);

      final hospitalView = Provider.of<HospitalView>(context, listen: false);

      // 取得附近醫院資料
      await hospitalView.fetchHospitalsByDistance(latLng);

       // 在地圖上畫標記
      await _mapService.setMarkers(
        hospitalView.hospitals,
        (h) {
          context.read<HospitalView>().selectHospital(h);
          _fetchPhotoFor(h.name);
        },
        latLng,
        pinColor: BitmapDescriptor.hueRed,
      );

      // 自動移鏡頭到最近的醫院
      if (hospitalView.hospitals.isNotEmpty) {
        final first = hospitalView.hospitals.first;
        _fetchPhotoFor(first.name);
        try {
          await _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(first.latitude, first.longitude),
              16,
            ),
          );
        } catch (_) {}
      }
    }
  }

 // 主要畫面：上方選單 + 地圖 + 資訊卡
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

                // 收藏浮動按鈕（依卡片高度上移）
                Positioned(
                  left: 16,
                  bottom:
                      hospital.showHospitalInfo ? (_infoCardHeight + 28) : 24,
                  child: SafeArea(
                    minimum: const EdgeInsets.only(left: 8),
                    child: _FavoritesFab(
                      onTap: () => _openFavoritesSheet(context),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 下拉選單 UI：控制縣市 / 地區 / 部門的選擇
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
            // 標題 + 關閉按鈕
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
                    onPressed: hospital.toggleMode), // 點擊關閉下拉表單
              ],
            ),
            const SizedBox(height: 12),
            // 縣市下拉
            _buildDropdownRow(
                '縣市', '請選擇縣市', hospital.counties, hospital.selectedCounty,
                (value) async {
              hospital.selectedCounty = value; // 選擇縣市
              hospital.selectedDistrict = null; // 清空地區
              hospital.selectedDepartment = null; // 清空部門
              await hospital.loadDistricts(value!); // 載入地區
            }),
            const SizedBox(height: 12),
            // 地區下拉
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
            // 醫療部門下拉
            _buildDropdownRow(
                '醫療部門',
                '請選擇部門',
                hospital.departments,
                hospital.selectedDepartment,
                hospital.selectedDistrict != null
                    ? (value) => hospital.selectedDepartment = value
                    : null),
            const SizedBox(height: 10),
             // 查詢按鈕
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF669FA5),
                shape: const StadiumBorder(),
                minimumSize: const Size(80, 38),
              ),
              onPressed: () async {
                hospital.toggleMode();  // 關閉下拉表單
                hospital.toggleShowMode(); // 顯示醫院資訊卡
                final hospitalView =
                    Provider.of<HospitalView>(context, listen: false);
                await hospitalView.fetchHospitals(); // 從後端載入醫院資料
                _mapService.setMarkers(
                  hospitalView.hospitals,
                  (selectedHospital) {
                    hospitalView.selectHospital(selectedHospital); // 選取醫院
                    _fetchPhotoFor(selectedHospital.name); // 載入醫院照片
                  },
                  _currentPosition!,
                  pinColor: BitmapDescriptor.hueRed,
                );
              },
              child: const Text('查詢', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );

  // 頂部 Bar：顯示標題 + 搜尋按鈕
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

  // 醫院資訊卡：顯示地圖下方的醫院詳細資訊
  Widget _buildHospitalCard() {
    return Consumer2<HospitalView, GoogleMapService>(
      builder: (context, hospital, mapService, _) {
        final selected = hospital.selectedHospital;
        if (selected == null) return const SizedBox(); // 如果沒有選取醫院，回傳空白

        // 量測資訊卡高度，避免遮擋收藏按鈕
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box =
              _infoCardKey.currentContext?.findRenderObject() as RenderBox?;
          final h = box?.size.height;
          if (h != null && (h - _infoCardHeight).abs() > 2) {
            setState(() => _infoCardHeight = h);
          }
        });

        return Align(
          alignment: Alignment.bottomCenter,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.down, // 向下滑可以關閉卡片
            onDismissed: (_) => hospital.toggleShowMode(),
            child: Container(
              key: _infoCardKey,
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
                   // 上方小橫條，表示可拖曳
                  Container(
                    width: 80,
                    height: 5,
                   
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(50, 88, 146, 153),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),

                  // 右上角：收藏按鈕 + 營業狀態
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // 整組靠右

                    children: [
                      IconButton(
                        tooltip: '收藏 / 取消收藏',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          mapService.isStarred(selected.id)
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 24,
                          color: mapService.isStarred(selected.id)
                              ? const Color.fromARGB(255, 255, 214, 93)
                              : const Color(0xFF589399),
                        ),
                        onPressed: () {
                          mapService.toggleStar(selected.id); // 切換收藏狀態
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

                  // 左側：醫院圖片 / 右側：詳細資訊
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             // 醫院名稱
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

                             // 地址、電話、距離、行走時間
                            _buildInfoRow(
                                Icons.location_on_outlined, selected.address,
                                maxLines: 2),
                            const SizedBox(height: 6),
                            _buildInfoRow(
                                Icons.phone_outlined, '${selected.phone}'),
                            const SizedBox(height: 6),
                            _buildInfoRow(Icons.directions_walk_outlined,
                                '${selected.distance}'),
                            const SizedBox(height: 6),
                            _buildInfoRow(Icons.access_time_outlined,
                                '行走 ${selected.walkTime} 分鐘'),
                          ],
                        ),
                      ),
                    ],
                  ),

 // 導航按鈕
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0), // 和下方的距離
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.navigation_outlined,
                          size: 17,
                          color: Colors.white,
                        ),
                        label: const Text(
                          '開始導航',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(88, 147, 153, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// 顯示單行資訊，例如地址、電話、距離等
  Widget _buildInfoRow(IconData icon, String text, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF669FA5)), // 左側小圖示
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text, // 顯示的文字
            style: const TextStyle(fontSize: 12, color: Color(0xFF669FA5)),
            maxLines: maxLines, // 最多顯示行數
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

// 通用下拉選單元件，label 在左，選單在右
  Widget _buildDropdownRow(
    String label,  // 左邊的標籤文字
    String hint, // 下拉選單提示文字
    List<String> options, // 下拉選項
    String? selectedValue, // 已選擇的值
    ValueChanged<String?>? onChanged, // 當選擇改變時觸發
  ) {
    final isDisabled = onChanged == null; // 如果 onChanged 為 null，代表此選單不可用

    return Row(
      children: [
        // 左邊標籤
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
        // 右邊下拉選單
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
              ignoring: isDisabled, // 禁用時無法點擊
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  alignment: Alignment.center,
                  isExpanded: true,
                  hint: Text('----- $hint -----',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  value: selectedValue, // 當前選中的值
                  items: options // 將字串選項轉換成 DropdownMenuItem
                      .map((item) => DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: item,
                            child: Text(item,
                                style: const TextStyle(fontSize: 14)),
                          ))
                      .toList(),
                  onChanged: onChanged, // 點擊選項時觸發的 callback
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

// 左下角的收藏按鈕，顯示收藏數量
  Widget _FavoritesFab({required VoidCallback onTap}) {
    return Consumer2<GoogleMapService, HospitalView>(
      builder: (context, mapService, hv, _) {
        final count =
            hv.hospitals.where((h) => mapService.isStarred(h.id)).length; // 收藏數

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap, // 點擊後打開收藏清單
            borderRadius: BorderRadius.circular(28),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: const Color(0xFF669FA5), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFF669FA5), size: 20),
                  const SizedBox(width: 6),
                  const Text(
                    '收藏',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF669FA5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 收藏數角標
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF669FA5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count', // 收藏數字
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
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

// 收藏清單：底部可拖拉視窗，顯示收藏的醫院列表
  Future<void> _openFavoritesSheet(BuildContext context) async {
    final mapService = context.read<GoogleMapService>();
    final hv = context.read<HospitalView>();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.35,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            final favorites =
                hv.hospitals.where((h) => mapService.isStarred(h.id)).toList();

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 上方拖曳條
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        '收藏列表',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF589399),
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                   // 收藏列表內容
                  Expanded(
                    child: favorites.isEmpty
                        ? const Center(
                            child: Text('尚未收藏任何醫療院所',
                                style: TextStyle(color: Color(0xFF9AA7AD))),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: favorites.length,
                            itemBuilder: (_, i) {
                              final h = favorites[i];
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                leading: const Icon(
                                    Icons.local_hospital_outlined,
                                    color: Color(0xFF669FA5)),
                                title: Text(
                                  h.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF589399),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone_outlined,
                                            size: 14, color: Color(0xFF9AA7AD)),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            h.phone.isEmpty ? '—' : h.phone,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF65747A)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.location_on_outlined,
                                            size: 14, color: Color(0xFF9AA7AD)),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            h.address,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF65747A)),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.info_outline,
                                            size: 14, color: Color(0xFF9AA7AD)),
                                        const SizedBox(width: 6),
                                        Text(
                                          h.openStatus ?? '狀態未知',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: (h.openStatus == '營業中')
                                                ? Colors.red
                                                : const Color(0xFF9AA7AD),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  tooltip: '取消收藏',
                                  icon: const Icon(Icons.star_rounded,
                                      color: Color(0xFF669FA5)),
                                  onPressed: () {
                                    mapService.toggleStar(h.id);
                                    final left = hv.hospitals
                                        .where(
                                            (x) => mapService.isStarred(x.id))
                                        .length;
                                    if (left == 0 &&
                                        Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop(); // 全部刪掉時自動關閉
                                    } else {
                                      setState(() {}); // 更新數字
                                    }
                                  },
                                ),
                                onTap: () async {
                                  context
                                      .read<HospitalView>()
                                      .selectHospital(h);
                                  try {
                                    await _mapController?.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                        LatLng(h.latitude, h.longitude),
                                        16,
                                      ),
                                    );
                                  } catch (_) {}
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
