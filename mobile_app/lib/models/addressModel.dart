class AddressModel {
  final String? id;
  final String? fullname;
  final String? phone;
  final String? street;
  final String? city;
  final String? precinct;
  final String? province;
  final bool active;

  AddressModel({
    this.id,
    this.fullname,
    this.phone,
    this.street,
    this.city,
    this.precinct,
    this.province,
    this.active = false,
  });

  // Parse JSON từ API
  AddressModel.fromJson(Map<String, dynamic> json)
    : id = json['_id'] as String?,
      fullname = json['fullname'] as String?,
      phone = json['phone'] as String?,
      street = json['street'] as String?,
      city = json['city'] as String?,
      precinct = json['precinct'] as String?,
      province = json['province'] as String?,
      active = json['active'] as bool? ?? false;

  // Chuyển thành JSON để gửi API
  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (fullname != null) 'fullname': fullname,
    if (phone != null) 'phone': phone,
    if (street != null) 'street': street,
    if (city != null) 'city': city,
    if (precinct != null) 'precinct': precinct,
    if (province != null) 'province': province,
    'active': active,
  };

  AddressModel copyWith({
    String? id,
    String? fullname,
    String? phone,
    String? street,
    String? city,
    String? precinct,
    String? province,
    bool? active,
  }) {
    return AddressModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      precinct: precinct ?? this.precinct,
      province: province ?? this.province,
      active: active ?? this.active,
    );
  }

  String get fullAddress {
    List<String> parts = [];
    if (street != null) parts.add(street!);
    if (precinct != null) parts.add(precinct!);
    if (city != null) parts.add(city!);
    if (province != null) parts.add(province!);
    return parts.isNotEmpty ? parts.join(', ') : 'Không có địa chỉ';
  }
}
