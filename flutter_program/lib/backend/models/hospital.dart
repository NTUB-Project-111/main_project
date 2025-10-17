//統一管理醫院資料結構（Model），方便 Flutter 在地圖、卡片或收藏中顯示醫院資訊。


class Hospital {
  // 醫院基本屬性
  final int id;
  final String name;
  final String city;
  final String district;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;

  // 額外資訊（非資料庫原生）
  String? distance; // 使用者距離
  int? walkTime; // 步行時間（分鐘）
  String? openStatus; // 營業中 or 已打烊
  final String? photoReference; // Google Place 圖片參考代碼

  // 建構子
  Hospital({
    required this.id,
    required this.name,
    required this.city,
    required this.district,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.photoReference,
  });

  // 從 JSON 建立 Hospital 物件
  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      district: json['district'],
      address: json['address'],
      latitude: (json['lat'] ?? 0).toDouble(),
      longitude: (json['lng'] ?? 0).toDouble(),
      phone: json['phone'] ?? '',
      photoReference: json['photoReference'] as String?,
    );
  }

  // 轉字串（方便除錯）
  @override
  String toString() {
    return '醫院: $name, 地址: $address, 電話: $phone, 經緯度: ($latitude, $longitude)';
  }
}
