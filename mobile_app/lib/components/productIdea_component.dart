import 'package:flutter/material.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/recommend_service.dart';
import 'package:mobile_app/components/product_card.dart' as component;
import 'package:mobile_app/pages/HomePage.dart';

class ProductIdeaComponent extends StatefulWidget {
  const ProductIdeaComponent({super.key});

  @override
  _ProductIdeaComponentState createState() => _ProductIdeaComponentState();
}

class _ProductIdeaComponentState extends State<ProductIdeaComponent> {
  late Future<List<ProductsModel>> _recommendedProductsFuture;

  @override
  void initState() {
    super.initState();
    _recommendedProductsFuture =
        RecommendService.getRecommendedProductsBasedOnViewed();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title (Centered)
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text(
              'Ý tưởng sản phẩm',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // FutureBuilder to fetch and display recommended products
        FutureBuilder<List<ProductsModel>>(
          future: _recommendedProductsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Lỗi khi tải ý tưởng sản phẩm'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Không có ý tưởng sản phẩm nào hiện tại'),
                ),
              );
            }

            final products =
                snapshot.data!.take(10).toList(); // Limit to 10 products
            return SizedBox(
              height: 280, // Adjust based on ProductCard size
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: products.length + 1, // Add 1 for "Xem thêm"
                itemBuilder: (context, index) {
                  if (index == products.length) {
                    // Display "Xem thêm" at the end
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: const Text(
                            'Xem thêm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2.0,
                    ), // Reduced spacing
                    child: SizedBox(
                      width: 160, // Adjust based on ProductCard
                      child: component.ProductCard(products: products[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
