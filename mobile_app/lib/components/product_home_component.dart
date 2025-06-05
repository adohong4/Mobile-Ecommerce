import 'package:flutter/material.dart';
import 'package:mobile_app/models/category_model.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/pages/SearchPage.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/components/productCardHome.dart' as component;
import 'package:mobile_app/services/category_service.dart';

class ProductHomeComponent extends StatefulWidget {
  const ProductHomeComponent({super.key});

  @override
  _ProductHomeComponentState createState() => _ProductHomeComponentState();
}

class _ProductHomeComponentState extends State<ProductHomeComponent> {
  late Future<List<Map<String, dynamic>>> _randomProductsFuture;
  late Future<List<CategoryModel>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _randomProductsFuture = ProductService.fetchRandomProductsByCategories();
    _categoriesFuture = CategoryService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 4,
      ), // Loại bỏ padding ngang
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([_randomProductsFuture, _categoriesFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final List<Map<String, dynamic>> randomProducts = snapshot.data![0];
          final List<CategoryModel> categories = snapshot.data![1];

          // Tạo map ánh xạ categoryIds sang category (tên đầy đủ)
          final Map<String, String> categoryMap = {
            for (var category in categories)
              category.categoryIds: category.category,
          };

          return Column(
            children:
                randomProducts.map((categoryData) {
                  final String categoryId = categoryData['category'];
                  final List<ProductsModel> products = categoryData['products'];
                  final String categoryName =
                      categoryMap[categoryId] ?? categoryId.toUpperCase();

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 0,
                    ), // Loại bỏ margin ngang
                    padding: const EdgeInsets.all(
                      0,
                    ), // Loại bỏ padding của Container
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Xóa borderRadius để không bo góc
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                categoryName.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SearchPage(
                                            categoryId: categoryId,
                                            categoryName: categoryName,
                                          ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Xem thêm',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: SizedBox(
                                  width: 150,
                                  child: component.ProductCardHome(
                                    products: products[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
