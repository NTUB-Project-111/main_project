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
  final String phone; // 
  final bool isOpen; //

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
