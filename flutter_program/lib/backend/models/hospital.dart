class Hospital {
  //醫院的基本屬性
  final int id;
  final String name;
  final String city;
  final String district;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  String? distance; // 與使用者的距離
  int? walkTime; // 步行時間
  String? openStatus; // 營業狀態
  final String? photoReference; // Google Place API 回傳的圖片

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

 // 從 JSON 資料建立 Hospital 物件
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

// ---------- 物件轉字串 ----------
  @override
  String toString() {
    return '醫院: $name, 地址: $address, 電話: $phone, 經緯度: ($latitude, $longitude)';
  }
}
