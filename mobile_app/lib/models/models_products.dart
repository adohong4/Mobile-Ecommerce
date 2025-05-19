class ProductModel {
  final String name;
  final String brand;
  final double price;
  final double oldPrice;
  final int discountPercent;
  final bool isFavorite;
  final bool isBestSeller;
  final String? description;

  final List<String> images;

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
