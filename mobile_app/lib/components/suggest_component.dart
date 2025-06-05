import 'package:flutter/material.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/recommend_service.dart';
import 'package:mobile_app/components/product_card.dart' as component;

class SuggestComponent extends StatefulWidget {
  const SuggestComponent({super.key});

  @override
  _SuggestComponentState createState() => _SuggestComponentState();
}

class _SuggestComponentState extends State<SuggestComponent> {
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
        // Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Gợi ý ngày hôm nay',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  child: Text('Lỗi khi tải gợi ý'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Không có gợi ý nào hiện tại'),
                ),
              );
            }

            final products = snapshot.data!;
            return GridView.builder(
              shrinkWrap: true, // Ensure GridView takes only the space it needs
              physics:
                  const NeverScrollableScrollPhysics(), // Disable GridView scrolling
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 4.0,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 products per row
                childAspectRatio: 0.65, // Adjust based on ProductCard size
                crossAxisSpacing: 8.0, // Space between columns
                mainAxisSpacing: 8.0, // Space between rows
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return component.ProductCard(products: products[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
