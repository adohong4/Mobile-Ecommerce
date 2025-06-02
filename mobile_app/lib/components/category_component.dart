// components/category_component.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/models/category_model.dart';
import 'package:mobile_app/services/category_service.dart';

class CategoryComponent extends StatefulWidget {
  const CategoryComponent({super.key});

  @override
  _CategoryComponentState createState() => _CategoryComponentState();
}

class _CategoryComponentState extends State<CategoryComponent> {
  final PageController _categoryController = PageController(
    viewportFraction: 1.0,
  );
  int _categoryPage = 0;
  late Future<List<CategoryModel>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = CategoryService.fetchCategories();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'DANH MỤC SẢN PHẨM',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<CategoryModel>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No categories available'));
                }

                final categories = snapshot.data!;
                // Chia danh mục thành các nhóm (4 danh mục mỗi trang)
                List<List<CategoryModel>> categoryPages = [];
                for (var i = 0; i < categories.length; i += 4) {
                  categoryPages.add(
                    categories.sublist(
                      i,
                      i + 4 > categories.length ? categories.length : i + 4,
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _categoryController,
                        itemCount: categoryPages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _categoryPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final categoryList = categoryPages[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  categoryList.map<Widget>((category) {
                                    return GestureDetector(
                                      onTap: () {
                                        // TODO: Điều hướng đến trang danh mục với categoryIds
                                        print('Tapped on ${category.category}');
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFFFFF),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Color(0xFF194689),
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 6,
                                                  spreadRadius: 1,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child:
                                                  category
                                                          .categoryPic
                                                          .isNotEmpty
                                                      ? Image.network(
                                                        category.categoryPic,
                                                        width: 40,
                                                        height: 32,
                                                        fit: BoxFit.contain,
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) => Icon(
                                                              Icons.error,
                                                            ),
                                                      )
                                                      : Icon(Icons.category),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              category.category,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        categoryPages
                            .length, // Sử dụng categoryPages.length thay vì snapshot.data
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _categoryPage == index ? 16 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color:
                                _categoryPage == index
                                    ? const Color(0xFF1AA7DD)
                                    : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
