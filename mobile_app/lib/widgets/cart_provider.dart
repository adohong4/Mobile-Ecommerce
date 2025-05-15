import 'package:flutter/material.dart';
import 'package:mobile_app/models/models_products.dart';

class CartProvider extends ChangeNotifier {
  final List<ProductModel> _cartItems = [];

  List<ProductModel> get cartItems => _cartItems;

  void add(ProductModel product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void remove(ProductModel product) {
    _cartItems.remove(product);
    notifyListeners();
  }
}
