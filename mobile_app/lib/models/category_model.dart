// category_model.dart
class CategoryModel {
  final String id;
  final String category;
  final String categoryIds;
  final String categoryPic;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.category,
    required this.categoryIds,
    required this.categoryPic,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      categoryIds: json['categoryIds'] ?? '',
      categoryPic: json['categoryPic'] ?? '',
      active: json['active'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
