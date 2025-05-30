import 'package:flutter/material.dart';
import 'package:mobile_app/models/order_model.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/pages/ReviewPage.dart';
import 'package:mobile_app/providers/cart_provider.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabTitles = [
    'Chờ xác nhận',
    'Chờ lấy hàng',
    'Chờ giao hàng',
    'Đánh giá',
  ];

  final List<IconData> tabIcons = [
    Icons.access_time,
    Icons.store_mall_directory,
    Icons.delivery_dining,
    Icons.rate_review,
  ];

  final Map<String, String> statusMapping = {
    'pending': 'Chờ xác nhận',
    'confirmed': 'Chờ lấy hàng',
    'shipping': 'Chờ giao hàng',
    'delivered': 'Đánh giá',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
    // Lấy danh sách đơn hàng khi khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).fetchUserOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<ProductsModel?> _fetchProduct(String productId) async {
    try {
      return await ProductService.fetchProductById(productId);
    } catch (e) {
      return null;
    }
  }

  Widget _buildOrderCard({
    required Order order,
    required bool showReviewButton,
  }) {
    return FutureBuilder<List<Widget>>(
      future: Future.wait(
        order.items.map((item) async {
          final product = await _fetchProduct(item.id);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        product?.images.isNotEmpty ?? false
                            ? '${ApiService.imageBaseUrl}${product!.images[0]}'
                            : 'https://via.placeholder.com/80',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Image.asset(
                              'assets/microsoft.png',
                              width: 80,
                              height: 80,
                            ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product?.name ?? 'Sản phẩm không xác định',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 4),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${item.quantity} sản phẩm',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  'x${item.quantity}',
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (product?.oldPrice != null)
                                  Text(
                                    '${product!.oldPrice!.toStringAsFixed(0)} đ',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  '${item.price.toStringAsFixed(0)} đ',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF0D47A1),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${order.payment ? 'Đã thanh toán' : 'Chưa thanh toán'}',
                              style: const TextStyle(fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thành tiền: ${(item.price * item.quantity).toStringAsFixed(0)} đ',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  if (showReviewButton) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReviewPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Đánh giá',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Lỗi khi tải thông tin đơn hàng'));
        }
        return Column(children: snapshot.data!);
      },
    );
  }

  Widget _buildTabContent(String status) {
    final cartProvider = Provider.of<CartProvider>(context);
    if (cartProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (cartProvider.errorMessage != null) {
      return Center(child: Text(cartProvider.errorMessage!));
    }

    final filteredOrders =
        cartProvider.orders
            .where((order) => statusMapping[order.status] == status)
            .toList();

    if (filteredOrders.isEmpty) {
      return const Center(child: Text('Không có đơn hàng nào'));
    }

    return ListView(
      children:
          filteredOrders.map((order) {
            return _buildOrderCard(
              order: order,
              showReviewButton: status == 'Đánh giá',
            );
          }).toList(),
    );
  }

  int _getOrderCountForStatus(String status) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return cartProvider.orders
        .where((order) => statusMapping[order.status] == status)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đơn hàng của tôi',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: const Color(0xFF0D47A1),
            labelColor: const Color(0xFF0D47A1),
            unselectedLabelColor: Colors.black,
            tabs: List.generate(tabTitles.length, (index) {
              final count = _getOrderCountForStatus(tabTitles[index]);
              return SizedBox(
                height: 70,
                child: Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Icon(tabIcons[index], size: 35),
                          if (count > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Center(
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tabTitles[index],
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabTitles.map((title) => _buildTabContent(title)).toList(),
      ),
    );
  }
}
