import 'package:flutter/material.dart';
import 'package:mobile_app/models/order_model.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ProductService.dart';
import 'package:mobile_app/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  Map<String, int> _cartData = {};
  List<ProductsModel> _cartItems = [];
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, int> get cartData => _cartData;
  List<ProductsModel> get cartItems => _cartItems;
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final CartService _cartService = CartService();

  // Helper method to convert List<dynamic> to Map<String, int>
  Map<String, int> _convertListToMap(List<dynamic> cartList) {
    Map<String, int> cartMap = {};
    for (var item in cartList) {
      String itemId = item['itemId']?.toString() ?? '';
      int quantity =
          item['quantity'] is int
              ? item['quantity']
              : int.tryParse(item['quantity'].toString()) ?? 0;
      if (itemId.isNotEmpty) {
        cartMap[itemId] = quantity;
      }
    }
    return cartMap;
  }

  // Lấy giỏ hàng từ backend với thông tin khuyến mãi
  Future<void> fetchCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _cartService.getListCart();

    if (result['success']) {
      if (result['cartData'] is List<dynamic>) {
        _cartData = _convertListToMap(result['cartData']);
      } else {
        _cartData = Map<String, int>.from(result['cartData'] ?? {});
      }

      if (_cartData.isNotEmpty) {
        final productIds = _cartData.keys.toList();
        try {
          // Gọi fetchCampaignProductById cho từng ID
          _cartItems = await _fetchCampaignProducts(productIds);
          print('Fetched cart items: ${_cartItems.length}');
          for (var item in _cartItems) {
            print(
              'Cart item: ${item.name}, newPrice: ${item.newPrice}, '
              'displayPrice: ${item.displayPrice}, discountDisplay: ${item.discountDisplay}',
            );
          }
        } catch (e) {
          _errorMessage = 'Không lấy được chi tiết sản phẩm khuyến mãi: $e';
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

    final result = await _cartService.addToCart(product.id!);

    if (result['success']) {
      if (result['cartData'] is List<dynamic>) {
        _cartData = _convertListToMap(result['cartData']);
      } else {
        _cartData = Map<String, int>.from(result['cartData'] ?? {});
      }

      final productIds = _cartData.keys.toList();
      try {
        _cartItems = await _fetchCampaignProducts(productIds);
        print('Added product: ${product.name}, newPrice: ${product.newPrice}');
      } catch (e) {
        _errorMessage = 'Không lấy được chi tiết sản phẩm khuyến mãi: $e';
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

    final result = await _cartService.removeFromCart(product.id!);

    if (result['success']) {
      if (result['cartData'] is List<dynamic>) {
        _cartData = _convertListToMap(result['cartData']);
      } else {
        _cartData = Map<String, int>.from(result['cartData'] ?? {});
      }

      final productIds = _cartData.keys.toList();
      try {
        _cartItems = await _fetchCampaignProducts(productIds);
        print('Removed product: ${product.name}');
      } catch (e) {
        _errorMessage = 'Không lấy được chi tiết sản phẩm khuyến mãi: $e';
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

  // Lấy danh sách đơn hàng
  Future<void> fetchUserOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _cartService.getUserOrders();

    if (result['success']) {
      _orders =
          (result['orders'] as List<dynamic>)
              .map(
                (orderJson) => Order.fromJson({
                  'id': orderJson['_id'],
                  'items': orderJson['items'],
                  'amount': orderJson['amount'].toDouble(),
                  'address':
                      orderJson['address'] ??
                      {
                        'fullname': 'Unknown',
                        'street': 'Unknown',
                        'city': 'Unknown',
                        'province': 'Unknown',
                      },
                  'date': orderJson['date'],
                  'paymentMethod': orderJson['paymentMethod'],
                  'status': orderJson['status'],
                  'payment': orderJson['payment'],
                }),
              )
              .toList();
    } else {
      _errorMessage = result['message'];
      _orders = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Helper method to fetch campaign products by IDs
  Future<List<ProductsModel>> _fetchCampaignProducts(
    List<String> productIds,
  ) async {
    final List<ProductsModel> products = [];
    for (var id in productIds) {
      try {
        final product = await ProductService.fetchCampaignProductById(id);
        products.add(product);
      } catch (e) {
        print('Error fetching campaign product $id: $e');
        // Fallback: Lấy sản phẩm không khuyến mãi nếu cần
        try {
          final product = await ProductService.fetchProductById(id);
          products.add(product);
        } catch (e) {
          print('Error fetching product $id: $e');
        }
      }
    }
    return products;
  }
}
