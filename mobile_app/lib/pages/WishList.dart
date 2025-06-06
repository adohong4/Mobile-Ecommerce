import 'package:flutter/material.dart';
import 'package:mobile_app/pages/HomePage.dart';
import 'package:mobile_app/providers/wish_list_provider.dart';
import 'package:mobile_app/providers/cart_provider.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/pages/ProductDetailPage.dart';
import 'package:intl/intl.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  List<ProductsModel> _products = [];
  bool _isLoadingProducts = true;

  final Color darkBlue = const Color(0xFF194689);
  final Color lightBlue = const Color(0xFF1AA7DD);

  @override
  void initState() {
    super.initState();
    _fetchFavouritesAndProducts();
  }

  String formatCurrency(num price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return "${formatter.format(price)} đ";
  }

  Future<void> _fetchFavouritesAndProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    final wishList = Provider.of<WishListProvider>(context, listen: false);
    await wishList.fetchFavourites();

    if (wishList.favouriteIds.isNotEmpty) {
      try {
        final products = await ProductService.fetchProductsByIds(
          wishList.favouriteIds,
        );
        setState(() {
          _products = products;
          _isLoadingProducts = false;
        });
      } catch (e) {
        setState(() => _isLoadingProducts = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi tải sản phẩm: $e')));
      }
    } else {
      setState(() => _isLoadingProducts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishList = context.watch<WishListProvider>();
    final cart = context.read<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              ),
        ),
        title: const Text(
          "Danh sách yêu thích",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:
          wishList.isLoading || _isLoadingProducts
              ? const Center(child: CircularProgressIndicator())
              : wishList.errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(wishList.errorMessage!),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _fetchFavouritesAndProducts,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
              : _products.isEmpty
              ? const Center(child: Text("Bạn chưa có sản phẩm yêu thích"))
              : Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: _products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (ctx, i) {
                    final product = _products[i];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: product),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: darkBlue.withOpacity(0.3),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child:
                                        product.images.isNotEmpty
                                            ? Image.network(
                                              '${ApiService.imageBaseUrl}${product.images[0]}',
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Image.asset(
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (product.hasDiscount) ...[
                                        Text(
                                          formatCurrency(product.price),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      Text(
                                        formatCurrency(product.displayPrice),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: darkBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        cart.add(product);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Đã thêm vào giỏ hàng",
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.shopping_cart),
                                      label: const Text("Thêm giỏ hàng"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: lightBlue,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 13,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                            if (product.discountDisplay != null)
                              Positioned(
                                top: 8,
                                left: 8,
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
                                    product.discountDisplay!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () async {
                                  await wishList.remove(product);
                                  setState(() {
                                    _products.remove(product);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Đã xóa khỏi yêu thích'),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: const Icon(
                                    Icons.highlight_remove_rounded,
                                    color: Colors.red,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
