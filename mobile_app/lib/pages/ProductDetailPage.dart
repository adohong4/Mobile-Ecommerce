import 'package:flutter/material.dart';
import 'package:mobile_app/models/models_products.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  String formatCurrency(num price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return "${formatter.format(price)} đ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang chi tiết sản phẩm')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(product.image, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency(product.price),
                    style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
                  ),
                  if (product.oldPrice > product.price)
                    Text(
                      formatCurrency(product.oldPrice),
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    "Mô tả sản phẩm",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description ?? 'Chưa có mô tả chi tiết.',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
