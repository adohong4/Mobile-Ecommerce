import 'package:flutter/material.dart';
import 'package:mobile_app/models/voucher_model.dart';
import 'package:mobile_app/services/voucher_service.dart';

class VoucherProvider with ChangeNotifier {
  final VoucherService _voucherService = VoucherService();
  List<VoucherModel> _vouchers = [];
  VoucherModel? _selectedVoucher;
  bool _isLoading = false;
  String? _errorMessage;

  List<VoucherModel> get vouchers => _vouchers;
  VoucherModel? get selectedVoucher => _selectedVoucher;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserVouchers() async {
    _setLoading(true);
    final result = await _voucherService.getUserVoucherList();
    if (result['success']) {
      _vouchers = result['vouchers'] as List<VoucherModel>;
      _errorMessage = null;
    } else {
      _errorMessage = result['message'];
    }
    _setLoading(false);
  }

  Future<void> fetchVoucherById(String voucherId) async {
    _setLoading(true);
    final result = await _voucherService.getVoucherById(voucherId);
    if (result['success']) {
      _selectedVoucher = result['voucher'] as VoucherModel;
      _errorMessage = null;
    } else {
      _errorMessage = result['message'];
    }
    _setLoading(false);
  }

  Future<String?> useVoucher(String voucherId) async {
    _setLoading(true);
    final result = await _voucherService.useVoucher(voucherId);
    _setLoading(false);
    if (result['success']) {
      await fetchUserVouchers(); // Làm mới danh sách
      return null;
    } else {
      return result['message'];
    }
  }

  Future<String?> addVoucherToUser(String voucherId) async {
    _setLoading(true);
    final result = await _voucherService.addVoucherToUser(voucherId);
    _setLoading(false);
    if (result['success']) {
      await fetchUserVouchers(); // Làm mới danh sách
      return null;
    } else {
      return result['message'];
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
