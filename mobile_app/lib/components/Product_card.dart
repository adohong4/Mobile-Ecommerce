import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/models/models_products.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/widgets/wish_list_provider.dart';
import 'package:mobile_app/widgets/cart_provider.dart';
import 'package:mobile_app/pages/ProductDetailPage.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  String formatCurrency(num price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return "${formatter.format(price)} đ";
  }

  @override
  Widget build(BuildContext context) {
    final wishList = context.watch<WishListProvider>();
    final cart = context.watch<CartProvider>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh + badges + nút yêu thích + giỏ hàng
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    product.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Badge giảm giá
                if (product.discountPercent > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "-${product.discountPercent}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Nút yêu thích
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        wishList.items.contains(product)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: wishList.items.contains(product)
                            ? Colors.pinkAccent
                            : Colors.grey,
                      ),
                      onPressed: () {
                        if (wishList.items.contains(product)) {
                          wishList.remove(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã bỏ yêu thích')),
                          );
                        } else {
                          wishList.add(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã thêm vào yêu thích')),
                          );
                        }
                      },
                    ),
                  ),
                ),

                // Nút thêm giỏ hàng
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.grey),
                      onPressed: () {
                        cart.add(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã thêm vào giỏ hàng')),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Thương hiệu
            Text(
              product.brand,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            // Tên sản phẩm
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            // Giá
            Row(
              children: [
                if (product.oldPrice > product.price)
                  Text(
                    formatCurrency(product.oldPrice),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(width: 6),
                Text(
                  formatCurrency(product.price),
                  style: const TextStyle(
                    fontSize: 13,
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
