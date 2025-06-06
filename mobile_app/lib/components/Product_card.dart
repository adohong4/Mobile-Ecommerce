import 'package:flutter/material.dart';
import 'package:mobile_app/providers/cart_provider.dart';
import 'package:mobile_app/providers/wish_list_provider.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/pages/ProductDetailPage.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ProductsModel products;

  const ProductCard({super.key, required this.products});

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
            builder: (_) => ProductDetailPage(product: products),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.1,
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
                if (products.discountDisplay != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        products.discountDisplay!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          final wishList = context.read<WishListProvider>();
                          if (wishList.isFavourite(products)) {
                            wishList.remove(products);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã bỏ yêu thích')),
                            );
                          } else {
                            wishList.add(products);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã thêm vào yêu thích'),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              wishList.isFavourite(products)
                                  ? Colors.white
                                  : const Color(0xFF1AA7DD),
                          radius: 18,
                          child: Icon(
                            wishList.isFavourite(products)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                wishList.isFavourite(products)
                                    ? Colors.pinkAccent
                                    : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () {
                          final cart = context.read<CartProvider>();
                          cart.add(products);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã thêm vào giỏ hàng'),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFF194689),
                          radius: 18,
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              products.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (products.hasDiscount)
                  Text(
                    formatCurrency(products.price),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                Text(
                  formatCurrency(products.displayPrice),
                  style: const TextStyle(
                    fontSize: 15,
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
