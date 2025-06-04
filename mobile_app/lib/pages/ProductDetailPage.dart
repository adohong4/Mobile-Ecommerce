import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/models/models_products.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ProductService.dart';

import '../services/ApiService.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductsModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<ProductsModel> _productFuture;
  int quantity = 1;
  int selectedImageIndex = 0;
  bool _isExpanded = false;
  late List<String> productImages;

  // Biến cho bình luận
  double rating = 0;
  final TextEditingController commentTextController = TextEditingController();

  String formatCurrency(num price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return "${formatter.format(price)} đ";
  }

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService.fetchProductById(widget.product.id);
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<ProductsModel>(
          future: _productFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Product not found'));
            }

            final product = snapshot.data!;
            productImages =
                product.images
                    .map((image) => '${ApiService.imageBaseUrl}$image')
                    .take(3)
                    .toList();

            return Column(
              children: [
                const SizedBox(height: 5),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Banner sản phẩm
                        Stack(
                          children: [
                            productImages.isNotEmpty
                                ? Image.network(
                                  productImages[selectedImageIndex],
                                  height: 350,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                            'assets/images/asus.png',
                                            height: 350,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                )
                                : Image.asset(
                                  'assets/images/asus.png',
                                  height: 350,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                            // Nút quay lại
                            Positioned(
                              left: 10,
                              top: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.black45,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                            // Nút điều hướng ảnh
                            if (selectedImageIndex > 0)
                              Positioned(
                                left: 10,
                                top: 160,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.chevron_left,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedImageIndex--;
                                    });
                                  },
                                ),
                              ),
                            if (selectedImageIndex < productImages.length - 1)
                              Positioned(
                                right: 10,
                                top: 160,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.chevron_right,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedImageIndex++;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),

                        // Ảnh nhỏ dưới
                        if (productImages.length > 1)
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: productImages.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImageIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            selectedImageIndex == index
                                                ? const Color(0xFF194689)
                                                : Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        productImages[index],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                                  'assets/images/asus.png',
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                        // Tên sản phẩm và giá
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  // if (product.oldPrice > product.price)
                                  Text(
                                    formatCurrency(product.price),
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    formatCurrency(product.price),
                                    style: const TextStyle(
                                      color: Color(0xFF194689),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Số lượng
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Text(
                                "Số lượng",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed:
                                          quantity > 1
                                              ? () => setState(() => quantity--)
                                              : null,
                                      color:
                                          quantity > 1
                                              ? Color(0xFF194689)
                                              : Colors.grey,
                                    ),
                                    Text(
                                      quantity.toString(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed:
                                          () => setState(() => quantity++),
                                      color: Color(0xFF194689),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Mô tả sản phẩm (có viền)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF194689),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "MÔ TẢ SẢN PHẨM",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                const SizedBox(height: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.specifications),
                                    // children: widget.product.specifications.entries.map((entry) {
                                    //   return Text("• ${entry.key}: ${entry.value}");
                                    // }).toList(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "MÔ TẢ ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  product.description ?? '',
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: _isExpanded ? null : 3,
                                  overflow:
                                      _isExpanded
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _isExpanded
                                              ? "Thu gọn"
                                              : "Xem chi tiết",
                                          style: const TextStyle(
                                            color: Color(0xFF194689),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          _isExpanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: const Color(0xFF194689),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Bình luận của bạn",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // TextField nhập bình luận
                              TextField(
                                controller: commentTextController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  hintText: "Viết bình luận của bạn...",
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Đánh giá sao
                              Row(
                                children: [
                                  const Text(
                                    "Đánh giá: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ...List.generate(5, (index) {
                                    return IconButton(
                                      icon: Icon(
                                        index < rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: const Color(0xFFFFC107),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          rating = index + 1;
                                        });
                                      },
                                    );
                                  }),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Nút gửi bình luận
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF194689),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: const Size(100, 40),
                                  ),
                                  onPressed: () {
                                    final comment =
                                        commentTextController.text.trim();
                                    if (comment.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Vui lòng nhập bình luận',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    if (rating == 0) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Vui lòng đánh giá sao',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    print(
                                      'Gửi bình luận: $comment, đánh giá: $rating sao',
                                    );

                                    commentTextController.clear();
                                    setState(() {
                                      rating = 0;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Cảm ơn bạn đã bình luận!',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Bình luận",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),

                // Thanh điều hướng dưới
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1AA7DD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "MUA NGAY",
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF194689),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "THÊM GIỎ HÀNG",
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
