import 'dart:convert';

import 'package:intl/intl.dart';

class ProductsModel {
  final String id;
  final String title;
  final String name;
  final String category;
  final double price; // Giá gốc
  final double? newPrice; // Giá khuyến mãi
  final String? campaignType; // Loại khuyến mãi: percentage hoặc fixed_amount
  final double? campaignValue; // Giá trị khuyến mãi (%, hoặc số tiền cố định)
  final String description;
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
    this.newPrice,
    this.campaignType,
    this.campaignValue,
    required this.description,
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
    final newPrice = (json['newPrice'] as num?)?.toDouble();

    return ProductsModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['nameProduct']?.toString() ?? '',
      name: json['nameProduct']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: price,
      newPrice: newPrice,
      campaignType: json['campaignType']?.toString(),
      campaignValue: (json['campaignValue'] as num?)?.toDouble(),
      description: json['description']?.toString() ?? '',
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
      'newPrice': newPrice,
      'campaignType': campaignType,
      'campaignValue': campaignValue,
      'description': description,
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

  // Giá hiển thị: newPrice nếu có, nếu không thì dùng price
  double get displayPrice => newPrice ?? price;

  // Kiểm tra xem có giảm giá không
  bool get hasDiscount => newPrice != null && newPrice! < price;

  // Tính phần trăm giảm giá dựa trên campaignType và campaignValue
  String? get discountDisplay {
    if (!hasDiscount || campaignType == null || campaignValue == null) {
      return null;
    }
    if (campaignType == 'percentage') {
      return '-${campaignValue!.toInt()}%';
    } else if (campaignType == 'fixed_amount') {
      return '-${formatCurrency(campaignValue!)}';
    }
    return null;
  }

  // Định dạng tiền tệ cho giá trị giảm giá
  String formatCurrency(num price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return "${formatter.format(price)} đ";
  }
}
