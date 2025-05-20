import 'package:flutter/material.dart';
import 'package:mobile_app/models/models_products.dart';
import 'package:mobile_app/models/productModel.dart';

class WishListProvider extends ChangeNotifier {
  final List<ProductsModel> _items = [];

  List<ProductsModel> get items => _items;

  void add(ProductsModel product) {
    if (!_items.contains(product)) {
      _items.add(product);
      notifyListeners();
    }
  }

  void remove(ProductsModel product) {
    _items.remove(product);
    notifyListeners();
  }
}
