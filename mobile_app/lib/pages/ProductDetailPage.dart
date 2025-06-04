import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/models/models_products.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/providers/cart_provider.dart';
import 'package:mobile_app/services/comment_service.dart';
import 'package:mobile_app/models/comment_model.dart';
import 'package:mobile_app/models/models_products.dart';
import 'package:mobile_app/providers/wish_list_provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:mobile_app/pages/CheckoutPage.dart';
class ProductDetailPage extends StatefulWidget {
  final ProductsModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<ProductsModel> _productFuture;
  int quantity = 1;
  List<Comment> productComments = [];
  int selectedImageIndex = 0;
  bool _isExpanded = false;

  late List<String> productImages;
  bool _isLoadingComments = false;
  String? _commentError;

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  final TextEditingController commentTextController = TextEditingController();
  double rating = 0;

  String formatCurrency(num price) {
    return NumberFormat('#,###', 'vi_VN').format(price) + ' đ';
  }

  @override
  void initState() {
    super.initState();
    _productFuture = _fetchProductWithErrorHandling();
    _loadComments();
  }

  Future<ProductsModel> _fetchProductWithErrorHandling() async {
    try {
      return await ProductService.fetchProductById(widget.product.id);
    } catch (e) {
      // Xử lý lỗi và trả về sản phẩm mặc định nếu cần
      debugPrint('Error fetching product: $e');
      return widget.product; // Trả về sản phẩm ban đầu nếu fetch thất bại
    }
  }

  Future<void> _loadComments() async {
    if (!mounted) return;

    setState(() {
      _isLoadingComments = true;
      _commentError = null;
    });

    try {
      final result = await CommentService().getCommentsByProduct(widget.product.id);

      if (mounted) {
        setState(() {
          productComments = result['success'] ? result['comments'] : [];
          _commentError = result['success'] ? null : result['message'];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _commentError = 'Lỗi khi tải bình luận';
        });
      }
      debugPrint('Error loading comments: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingComments = false;
        });
      }
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  Widget _buildImageSlider(ProductsModel product) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: productImages.isNotEmpty
              ? Image.network(
            productImages[selectedImageIndex],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          )
              : _buildPlaceholderImage(),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: CircleAvatar(
            backgroundColor: Colors.black45,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        if (selectedImageIndex > 0)
          Positioned(
            left: 10,
            top: 160,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 32),
              onPressed: () => setState(() => selectedImageIndex--),
            ),
          ),
        if (selectedImageIndex < productImages.length - 1)
          Positioned(
            right: 10,
            top: 160,
            child: IconButton(
              icon: const Icon(Icons.chevron_right, size: 32),
              onPressed: () => setState(() => selectedImageIndex++),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Image.asset(
      'assets/images/asus.png',
      fit: BoxFit.cover,
    );
  }

  Widget _buildThumbnailImages() {
    if (productImages.length <= 1) return const SizedBox.shrink();

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: productImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() => selectedImageIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedImageIndex == index
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
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholderImage(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceSection(ProductsModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              Text(
                formatCurrency(product.price),
                style: const TextStyle(
                  color: Color(0xFF194689),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text("Số lượng", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                  color: quantity > 1 ? const Color(0xFF194689) : Colors.grey,
                ),
                Text(quantity.toString(), style: const TextStyle(fontSize: 20)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => quantity++),
                  color: const Color(0xFF194689),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ProductsModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF194689), width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("MÔ TẢ SẢN PHẨM",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const SizedBox(height: 12),
                Text(product.specifications),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("MÔ TẢ", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  product.description ?? '',
                  style: const TextStyle(fontSize: 14),
                  maxLines: _isExpanded ? null : 3,
                  overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isExpanded ? "Thu gọn" : "Xem chi tiết",
                          style: const TextStyle(
                            color: Color(0xFF194689),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: const Color(0xFF194689),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bình luận sản phẩm',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (_isLoadingComments)
            const Center(child: CircularProgressIndicator()),

          if (_commentError != null)
            Text(_commentError!, style: const TextStyle(color: Colors.red)),

          if (!_isLoadingComments && productComments.isEmpty)
            const Text('Chưa có bình luận nào'),

          ...productComments.map((comment) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userId ?? 'Người dùng',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (index) => Icon(
                        index < comment.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.comment),
                const SizedBox(height: 2),
                Text(
                  formatDate(comment.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Consumer<WishListProvider>(
            builder: (context, wishList, child) {
              final isFav = wishList.isFavourite(widget.product);

              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () {
                  if (isFav) {
                    wishList.remove(widget.product);
                  } else {
                    wishList.add(widget.product);
                  }

                  Flushbar(
                    message: isFav ? 'Đã bỏ yêu thích' : 'Đã thêm vào yêu thích',
                    duration: const Duration(seconds: 2),
                    margin: const EdgeInsets.all(12),
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: Colors.black87,
                    flushbarPosition: FlushbarPosition.TOP,
                    icon: Icon(
                      isFav ? Icons.favorite_border : Icons.favorite,
                      color: Colors.white,
                    ),
                  ).show(context);
                },
              );
            },
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
              onPressed: () {
                final selectedItem = {
                  'id': widget.product.id,
                  'name': widget.product.name,
                  'price': widget.product.price,
                  'quantity': quantity,  // hoặc số lượng bạn muốn
                  'image': widget.product.images.isNotEmpty ? widget.product.images[0] : '',
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPage(
                      selectedItems: [selectedItem],
                      total: widget.product.price.toInt(),
                    ),
                  ),
                );
              },
              child: const Text(
                "MUA NGAY",
                style: TextStyle(color: Colors.white),
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
              onPressed: () {
                final cart = context.read<CartProvider>();
                cart.add(widget.product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã thêm vào giỏ hàng')),
                );
              },
              child: const Text(
                "THÊM GIỎ HÀNG",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
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
            }

            final product = snapshot.data ?? widget.product;
            productImages = product.images
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
                        _buildImageSlider(product),
                        _buildThumbnailImages(),
                        _buildPriceSection(product),
                        _buildQuantitySelector(),
                        _buildDescriptionSection(product),
                        _buildCommentsSection(),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
                _buildBottomNavigationBar(),
              ],
            );
          },
        ),
      ),
    );
  }
}