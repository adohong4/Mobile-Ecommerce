import 'package:flutter/material.dart';
import 'package:mobile_app/models/models_products.dart';
import 'package:mobile_app/models/productModel.dart';

class CartProvider extends ChangeNotifier {
  final List<ProductsModel> _cartItems = [];

  List<ProductsModel> get cartItems => _cartItems;

  void add(ProductsModel product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void remove(ProductModel product) {
    _cartItems.remove(product);
    notifyListeners();
  }
}
