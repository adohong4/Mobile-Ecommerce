import 'package:flutter/material.dart';
import 'package:mobile_app/pages/ReviewPage.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class Order {
  final String title;
  final String imageUrl;
  final String price;
  final String oldPrice;
  final String status;
  final int quantity;

  Order({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.oldPrice,
    required this.status,
    required this.quantity,
  });
}

class _OrderDetailPageState extends State<OrderDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabTitles = [
    'Chờ xác nhận',
    'Chờ lấy hàng',
    'Chờ giao hàng',
    'Đánh giá',
  ];

  final List<IconData> tabIcons = [
    Icons.access_time,       // Chờ xác nhận
    Icons.store_mall_directory,  // Chờ lấy hàng
    Icons.delivery_dining,   // Chờ giao hàng
    Icons.rate_review,       // Đánh giá
  ];

  // Dữ liệu giả lập
  final List<Order> orders = [
    Order(
      title: 'Màn Hình Di Động Thông Minh SIEGenX 27 inch',
      imageUrl: 'assets/apple.png',
      price: '17.500.000 đ',
      oldPrice: '20.000.000 đ',
      status: 'Chờ lấy hàng',
      quantity: 4,
    ),
    Order(
      title: 'Laptop SIEGenX Pro 15 inch',
      imageUrl: 'assets/apple.png',
      price: '25.000.000 đ',
      oldPrice: '30.000.000 đ',
      status: 'Chờ giao hàng',
      quantity: 2,
    ),
    Order(
      title: 'Tai Nghe SIEGenX BT',
      imageUrl: 'assets/apple.png',
      price: '2.000.000 đ',
      oldPrice: '2.500.000 đ',
      status: 'Đánh giá',
      quantity: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildOrderCard({
    required String title,
    required String imageUrl,
    required String price,
    required String oldPrice,
    required String status,
    required bool showReviewButton,
    required int quantity,
  }) {
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
                Image.asset(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Poppins')),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$quantity sản phẩm',
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'Poppins')),
                          Text('x$quantity', style: const TextStyle(fontFamily: 'Poppins')),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(oldPrice,
                              style: const TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontFamily: 'Poppins')),
                          const SizedBox(width: 8),
                          Text(price,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0D47A1),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text("Thành tiền: $price",
                          style: const TextStyle(
                              fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
            if (showReviewButton) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReviewPage()),
                    );
                  },
                  child: const Text('Đánh giá',
                      style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String status) {
    bool isReviewTab = status == 'Đánh giá';
    List<Order> filteredOrders = orders.where((order) => order.status == status).toList();

    return ListView(
      children: filteredOrders.map((order) {
        return _buildOrderCard(
          title: order.title,
          imageUrl: order.imageUrl,
          price: order.price,
          oldPrice: order.oldPrice,
          status: order.status,
          showReviewButton: isReviewTab,
          quantity: order.quantity,
        );
      }).toList(),
    );
  }

  int _getOrderCountForStatus(String status) {
    return orders.where((order) => order.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi', style: TextStyle(fontFamily: 'Poppins')),
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
