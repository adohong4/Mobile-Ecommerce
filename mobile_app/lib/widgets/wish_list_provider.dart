import 'package:flutter/material.dart';
import 'package:mobile_app/models/models_products.dart';

class WishListProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => _items;

  void add(ProductModel product) {
    if (!_items.contains(product)) {
      _items.add(product);
      notifyListeners();
    }
  }

  void remove(ProductModel product) {
    _items.remove(product);
    notifyListeners();
  }
}
