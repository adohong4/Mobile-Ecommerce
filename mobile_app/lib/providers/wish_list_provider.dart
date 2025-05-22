import 'package:flutter/material.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/favourite_service.dart';

class WishListProvider extends ChangeNotifier {
  List<String> _favouriteIds = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<String> get favouriteIds => _favouriteIds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final FavouriteService _favouriteService = FavouriteService();

  // Lấy danh sách yêu thích từ backend
  Future<void> fetchFavourites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _favouriteService.getListFavourite();

    if (result['success']) {
      _favouriteIds = List<String>.from(result['favourites']);
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Thêm sản phẩm vào danh sách yêu thích
  Future<void> add(ProductsModel product) async {
    if (_favouriteIds.contains(product.id)) return;

    _isLoading = true;
    notifyListeners();

    final result = await _favouriteService.addToFavourite(product.id);

    if (result['success']) {
      _favouriteIds = List<String>.from(result['favourites']);
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Xóa sản phẩm khỏi danh sách yêu thích
  Future<void> remove(ProductsModel product) async {
    if (!_favouriteIds.contains(product.id)) return;

    _isLoading = true;
    notifyListeners();

    final result = await _favouriteService.removeFromFavourite(product.id);

    if (result['success']) {
      _favouriteIds = List<String>.from(result['favourites']);
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Kiểm tra sản phẩm có trong danh sách yêu thích hay không
  bool isFavourite(ProductsModel product) {
    return _favouriteIds.contains(product.id);
  }
}
