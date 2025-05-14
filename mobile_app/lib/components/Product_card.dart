import 'package:flutter/material.dart';
import 'package:mobile_app/models/models_products.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(product.image, height: 100, width: double.infinity, fit: BoxFit.cover),
              ),
              if (product.discountPercent > 0)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "-${product.discountPercent}%",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              if (product.isBestSeller)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Image.asset('assets/icons/bestseller.png', height: 24),
                ),
              if (product.isFavorite)
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Icon(Icons.thumb_up, color: Colors.cyan, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Image.asset('assets/logo_ngocnguyen.png', height: 18), // logo thương hiệu
          const SizedBox(height: 4),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                "${product.oldPrice.toStringAsFixed(0)} đ",
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "${product.price.toStringAsFixed(0)} đ",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
