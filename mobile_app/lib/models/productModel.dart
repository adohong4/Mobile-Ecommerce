import 'dart:convert';

class ProductsModel {
  final String id;
  final String title;
  final String name;
  final String category;
  final double price;
  final String description;
  final double? oldPrice;
  final int? discountPercent;
  final List<String> images;
  final String specifications;
  final int quantity;
  final bool active;
  final String productSlug;
  final bool isFavorite;
  final bool isBestSeller;

  ProductsModel({
    required this.id,
    required this.title,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    this.oldPrice,
    this.discountPercent,
    required this.images,
    required this.specifications,
    required this.quantity,
    required this.active,
    required this.productSlug,
    this.isFavorite = false,
    this.isBestSeller = false,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    final price = (json['price'] as num?)?.toDouble() ?? 0.0;
    // Tính toán oldPrice và discountPercent
    double? oldPrice = price * 1.2;
    int? discountPercent =
        oldPrice > price ? ((1 - price / oldPrice) * 100).round() : 0;

    return ProductsModel(
      id: json['_id']?.toString() ?? '', // Xử lý null
      title: json['title']?.toString() ?? '',
      name: json['nameProduct']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: price,
      description: json['description']?.toString() ?? '',
      oldPrice: oldPrice,
      discountPercent: discountPercent,
      images: List<String>.from(json['images'] ?? []),
      specifications: json['specifications']?.toString() ?? '',
      quantity: json['quantity'] as int? ?? 0,
      active: json['active'] as bool? ?? false,
      productSlug: json['product_slug']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'nameProduct': name,
      'category': category,
      'price': price,
      'description': description,
      'oldPrice': oldPrice,
      'discountPercent': discountPercent,
      'images': images,
      'specifications': specifications,
      'quantity': quantity,
      'active': active,
      'product_slug': productSlug,
      'isFavorite': isFavorite,
      'isBestSeller': isBestSeller,
    };
  }

  Map<String, String> get parsedSpecifications {
    try {
      if (specifications.isNotEmpty) {
        final Map<String, dynamic> specMap = jsonDecode(specifications);
        return specMap.map((key, value) => MapEntry(key, value.toString()));
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
