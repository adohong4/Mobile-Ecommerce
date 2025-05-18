class ProductModel {
  final String name;
  final String brand;
  final double price;
  final double oldPrice;
  final int discountPercent;
  final bool isFavorite;
  final bool isBestSeller;
  final String? description;

  /// Danh sách ảnh sản phẩm (ảnh lớn và ảnh nhỏ bên dưới)
  final List<String> images;

  /// Thông số kỹ thuật sản phẩm (mô tả chi tiết bên dưới)
  final Map<String, String> specifications;

  ProductModel({
    required this.name,
    required this.brand,
    required this.price,
    required this.oldPrice,
    required this.discountPercent,
    required this.images,
    required this.specifications,
    this.description,
    this.isFavorite = false,
    this.isBestSeller = false,
  });
}
