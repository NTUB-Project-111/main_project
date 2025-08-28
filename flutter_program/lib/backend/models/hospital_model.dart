// class Hospital {
//   final int id;
//   final String name;
//   final String city;
//   final String district;
//   final String address;
//   final double latitude;
//   final double longitude;
//   final String phone;
//   String? distance;
//   int? walkTime;
//   String? openStatus;

//   Hospital({
//     required this.id,
//     required this.name,
//     required this.city,
//     required this.district,
//     required this.address,
//     required this.latitude,
//     required this.longitude,
//     required this.phone,
//   });

//   factory Hospital.fromJson(Map<String, dynamic> json) {
//     return Hospital(
//       id: json['id'],
//       name: json['name'],
//       city: json['city'],
//       district: json['district'],
//       address: json['address'],
//       latitude: (json['lat'] ?? 0).toDouble(),
//       longitude: (json['lng'] ?? 0).toDouble(),
//       phone: json['phone'] ?? '',
//     );
//   }

//   @override
//   String toString() {
//     return '醫院: $name, 地址: $address, 電話: $phone, 經緯度: ($latitude, $longitude)';
//   }
// }

class Hospital {
  final int id;
  final String name;
  final String city;
  final String district;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  String? distance;
  int? walkTime;
  String? openStatus;
  final String? photoReference;

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

  @override
  String toString() {
    return '醫院: $name, 地址: $address, 電話: $phone, 經緯度: ($latitude, $longitude)';
  }
}
