// advertise_model.dart
class AdvertiseModel {
  final String id;
  final String imageAds;
  final String classify;
  final String recap;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdvertiseModel({
    required this.id,
    required this.imageAds,
    required this.classify,
    required this.recap,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdvertiseModel.fromJson(Map<String, dynamic> json) {
    return AdvertiseModel(
      id: json['_id'] ?? '',
      imageAds: json['imageAds'] ?? '',
      classify: json['classify'] ?? '',
      recap: json['recap'] ?? '',
      status: json['status'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
