import 'package:flutter/material.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  Map<String, int> _cartData = {};
  List<ProductsModel> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, int> get cartData => _cartData;
  List<ProductsModel> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final CartService _cartService = CartService();

  // Lấy giỏ hàng từ backend
  Future<void> fetchCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _cartService.getListCart();

    if (result['success']) {
      _cartData = Map<String, int>.from(result['cartData']);
      if (_cartData.isNotEmpty) {
        final productIds = _cartData.keys.toList();
        try {
          _cartItems = await ProductService.fetchProductsByIds(productIds);
        } catch (e) {
          _errorMessage = 'Không lấy được chi tiết sản phẩm: $e';
          _cartItems = [];
        }
      } else {
        _cartItems = [];
      }
    } else {
      _errorMessage = result['message'];
      _cartItems = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Thêm sản phẩm vào giỏ hàng
  Future<void> add(ProductsModel product) async {
    _isLoading = true;
    notifyListeners();

    final result = await _cartService.addToCart(product.id);

    if (result['success']) {
      _cartData = Map<String, int>.from(result['cartData']);
      final productIds = _cartData.keys.toList();
      try {
        _cartItems = await ProductService.fetchProductsByIds(productIds);
      } catch (e) {
        _errorMessage = 'Không lấy được chi tiết sản phẩm: $e';
      }
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> remove(ProductsModel product) async {
    _isLoading = true;
    notifyListeners();

    final result = await _cartService.removeFromCart(product.id);

    if (result['success']) {
      _cartData = Map<String, int>.from(result['cartData']);
      final productIds = _cartData.keys.toList();
      try {
        _cartItems = await ProductService.fetchProductsByIds(productIds);
      } catch (e) {
        _errorMessage = 'Không lấy được chi tiết sản phẩm: $e';
      }
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Cập nhật số lượng sản phẩm
  Future<void> updateQuantity(ProductsModel product, int quantity) async {
    if (quantity <= 0) {
      await remove(product);
      return;
    }

    _isLoading = true;
    notifyListeners();

    final currentQuantity = _cartData[product.id] ?? 0;
    if (quantity > currentQuantity) {
      for (int i = currentQuantity; i < quantity; i++) {
        await add(product);
      }
    } else if (quantity < currentQuantity) {
      for (int i = currentQuantity; i > quantity; i--) {
        await remove(product);
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
