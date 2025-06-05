import 'package:flutter/material.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/pages/ProductDetailPage.dart';
import 'package:intl/intl.dart';

class ProductCardHome extends StatelessWidget {
  final ProductsModel products;

  const ProductCardHome({super.key, required this.products});

  String formatCurrency(num price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return "${formatter.format(price)} đ";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: products),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: AspectRatio(
                aspectRatio: 1.2,
                child:
                    products.images.isNotEmpty
                        ? Image.network(
                          '${ApiService.imageBaseUrl}${products.images[0]}',
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Image.asset(
                                'assets/images/asus.png',
                                fit: BoxFit.cover,
                              ),
                        )
                        : Image.asset(
                          'assets/images/asus.png',
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            const SizedBox(height: 4),

            Expanded(
              child: Text(
                products.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 2),
            // Giá
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (products.oldPrice != null &&
                    products.oldPrice! > products.price)
                  Text(
                    formatCurrency(products.oldPrice!),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                Text(
                  formatCurrency(products.price),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
