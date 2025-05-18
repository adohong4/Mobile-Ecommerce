import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/models/models_products.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  int selectedImageIndex = 0;

  late List<String> productImages;

  String formatCurrency(num price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return "${formatter.format(price)} đ";
  }

  @override
  void initState() {
    super.initState();
    // Giả sử bạn chỉ có 1 ảnh sản phẩm, tạm thời lặp lại ảnh đầu tiên trong danh sách images
    productImages = [
      widget.product.images.isNotEmpty ? widget.product.images[0] : '',
      widget.product.images.isNotEmpty ? widget.product.images[1] : '',
      widget.product.images.isNotEmpty ? widget.product.images[2] : '',
    ];
  }


  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Banner sản phẩm
                    Stack(
                      children: [
                        Image.asset(
                          productImages[selectedImageIndex],
                          height: 250,
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
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        const Positioned(left: 50, top: 100, child: Icon(Icons.chevron_left, size: 32)),
                        const Positioned(right: 10, top: 100, child: Icon(Icons.chevron_right, size: 32)),
                      ],
                    ),


                    // Ảnh nhỏ dưới
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                  color: selectedImageIndex == index ? Colors.orange : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Image.asset(productImages[index], width: 60, height: 60),
                            ),
                          );
                        },
                      ),
                    ),

                    // Tên sản phẩm và giá
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (product.oldPrice > product.price)
                                Text(
                                  formatCurrency(product.oldPrice),
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                formatCurrency(product.price),
                                style: const TextStyle(color: Colors.blue, fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Mô tả sản phẩm
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("MÔ TẢ SẢN PHẨM", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("• Hệ điều hành: Android TV"),
                                Text("• Ngôn ngữ: Tiếng Việt, Tiếng Anh, Tiếng Trung"),
                                Text("• Độ phân giải: 3840x2160 (4K)"),
                                Text("• Tốc độ làm mới: 60Hz"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Số lượng
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Text("Số lượng", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() => quantity--);
                                    }
                                  },
                                ),
                                Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() => quantity++);
                                  },
                                ),
                              ],
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {},
                      child: const Text("MUA NGAY"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300),
                      onPressed: () {},
                      child: const Text("THÊM VÀO GIỎ HÀNG", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
