import 'package:flutter/material.dart';
import 'package:mobile_app/pages/ReviewPage.dart';

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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('1 sản phẩm',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Poppins')),
                          Text('x1', style: TextStyle(fontFamily: 'Poppins')),
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
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      // Text(status,
                      //     style: const TextStyle(
                      //         color: Colors.red,
                      //         fontSize: 14,
                      //         fontFamily: 'Poppins')),
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
                      backgroundColor: Color(0xFF0D47A1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReviewPage()),
                    );
                  },
                  child: const Text('Đánh giá',
                      style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                  ),
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

    return ListView(
      children: [
        _buildOrderCard(
          title: 'Màn Hình Di Động Thông Minh SIEGenX 27 inch',
          imageUrl: 'assets/apple.png',
          price: '17.500.000 đ',
          oldPrice: '20.000.000 đ',
          status: status,
          showReviewButton: isReviewTab,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi',
            style: TextStyle(fontFamily: 'Poppins')),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Color(0xFF0D47A1),
          labelColor: Color(0xFF0D47A1),
          unselectedLabelColor: Colors.black,
          labelStyle: const TextStyle(fontFamily: 'Poppins'),
          tabs: tabTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabTitles.map((title) => _buildTabContent(title)).toList(),
      ),
    );
  }
}
