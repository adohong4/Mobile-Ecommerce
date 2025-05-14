class ProductModel {
  final String image;
  final String brand;
  final String name;
  final double price;
  final double oldPrice;
  final int discountPercent;
  final bool isFavorite;
  final bool isBestSeller;

  ProductModel({
    required this.image,
    required this.brand,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.discountPercent,
    this.isFavorite = false,
    this.isBestSeller = false,
  });
}
