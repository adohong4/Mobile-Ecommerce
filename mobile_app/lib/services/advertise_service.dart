// advertise_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/advertise_model.dart';
import 'package:mobile_app/services/ApiService.dart';

class AdvertiseService {
  static const String baseUrl = ApiService.productService;

  // Lấy danh sách banner
  static Future<List<AdvertiseModel>> fetchBanners() async {
    final response = await http.get(Uri.parse('$baseUrl/advertise/banner'));

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> bannersJson = jsonData['metadata'];
      return bannersJson.map((json) => AdvertiseModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load banners: ${response.statusCode}');
    }
  }

  // Lấy danh sách quảng cáo (dùng cho popup)
  static Future<List<AdvertiseModel>> fetchAdvertisements() async {
    final response = await http.get(Uri.parse('$baseUrl/advertise/adver'));

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> adsJson = jsonData['metadata'];
      return adsJson.map((json) => AdvertiseModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load advertisements: ${response.statusCode}');
    }
  }
}
