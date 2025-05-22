import 'package:flutter/material.dart';
import 'package:mobile_app/pages/HomePage.dart';
import 'package:mobile_app/providers/wish_list_provider.dart';
import 'package:mobile_app/providers/cart_provider.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/pages/ProductDetailPage.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  List<ProductsModel> _products = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _fetchFavouritesAndProducts();
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
        setState(() {
          _isLoadingProducts = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi tải sản phẩm: $e')));
      }
    } else {
      setState(() {
        _isLoadingProducts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishList = context.watch<WishListProvider>();
    final cart = context.read<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              ),
        ),
        title: const Text("Yêu Thích"),
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
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: _products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (ctx, i) {
                    final product = _products[i];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child:
                                    product.images.isNotEmpty
                                        ? Image.network(
                                          '${ApiService.imageBaseUrl}${product.images[0]}',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await wishList.remove(product);
                                      setState(() {
                                        _products.remove(product);
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Đã xóa khỏi yêu thích',
                                          ),
                                        ),
                                      );
                                    },
                                    tooltip: "Xóa khỏi yêu thích",
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      cart.add(product);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Đã thêm vào giỏ hàng"),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.add_shopping_cart),
                                    label: const Text("Giỏ hàng"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(100, 36),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
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
