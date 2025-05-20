import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_app/services/LoginService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _token;
  bool _isAuthenticated = false;

  // Getter
  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  // Khởi tạo trạng thái từ SharedPreferences
  Future<void> initAuth() async {
    final token = await LoginService.getToken();
    final user = await LoginService.getUser();

    if (token != null && user != null) {
      _token = token;
      _user = user;
      _isAuthenticated = true;
    } else {
      _token = null;
      _user = null;
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  // Cập nhật trạng thái đăng nhập
  void setUser(Map<String, dynamic> userData, String token) {
    _user = userData;
    _token = token;
    _isAuthenticated = true;
    notifyListeners();
  }

  // Đăng xuất
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user');
    await prefs.remove('cookies');
    _user = null;
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
