import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/order_model.dart';
import 'package:mobile_app/models/productModel.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/LoginService.dart';

class PaymentService {
  static const String _baseUrl = ApiService.paymentService;
  static const String _codVerify = '/cod/verify';
  static const String _stripePlace = '/stripe/place';
  static const String _stripeVerify = '/stripe/verify';

  Future<Map<String, dynamic>> _postRequest(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? queryParams,
  }) async {
    final token = await LoginService.getToken();
    if (token == null) {
      throw Exception('Không tìm thấy token. Vui lòng đăng nhập.');
    }

    // Thêm query parameters nếu có
    Uri uri = Uri.parse('$_baseUrl$endpoint');
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final error =
          jsonDecode(response.body)['message'] ?? 'Lỗi không xác định';
      throw Exception(error);
    }
  }

  Future<Map<String, dynamic>> placeCODOrder(Order order) async {
    final body = {
      'items':
          order.items
              .map(
                (item) => {
                  'id': item.id,
                  'quantity': item.quantity,
                  'price': item.price,
                },
              )
              .toList(),
      'amount': order.amount,
      'address': {
        'fullname': order.address.fullname,
        'street': order.address.street,
        'precinct': order.address.precinct,
        'city': order.address.city,
        'province': order.address.province,
      },
      'paymentMethod': 'cod',
    };

    final response = await _postRequest(_codVerify, body);
    if (response['status'] != 201) {
      throw Exception(response['message'] ?? 'Đặt hàng COD thất bại');
    }
    return {
      'orderId': '',
      'message': response['message'] ?? 'Đặt hàng COD thành công',
    };
  }

  Future<Map<String, dynamic>> placeStripeOrder(
    Order order,
    List<ProductsModel> products,
  ) async {
    // Tạo map để ánh xạ id sản phẩm với tên sản phẩm
    final itemNameMap = {
      for (var product in products) product.id: product.name,
    };

    final body = {
      'items':
          order.items
              .map(
                (item) => {
                  'id': item.id,
                  'quantity': item.quantity,
                  'price': item.price,
                  'nameProduct':
                      itemNameMap[item.id] ?? 'Sản phẩm không xác định',
                },
              )
              .toList(),
      'amount': order.amount,
      'address': {
        'fullname': order.address.fullname,
        'street': order.address.street,
        'precinct': order.address.precinct,
        'city': order.address.city,
        'province': order.address.province,
      },
      'useCheckoutSession': true, // Thêm tham số để yêu cầu Checkout Session
    };

    print('Request body: ${jsonEncode(body)}'); // Debug
    final response = await _postRequest(
      _stripePlace,
      body,
      queryParams: {'useCheckoutSession': 'true'}, // Thêm query param
    );
    print('Stripe Response: $response'); // Debug
    if (response['status'] != 200 && response['status'] != 201) {
      throw Exception(
        response['message'] ?? 'Tạo phiên thanh toán Stripe thất bại',
      );
    }
    final metadata = response['metadata'] as Map<String, dynamic>?;
    return {
      'clientSecret': metadata?['clientSecret']?.toString(),
      'sessionId': metadata?['sessionId']?.toString(),
      'sessionUrl': metadata?['sessionUrl']?.toString(),
      'orderId': metadata?['orderId']?.toString() ?? '',
    };
  }

  Future<void> verifyStripeOrder(String orderId, bool success) async {
    final body = {'orderId': orderId, 'success': success.toString()};
    final response = await _postRequest(_stripeVerify, body);
    if (response['status'] != 200) {
      throw Exception(response['message'] ?? 'Xác minh Stripe thất bại');
    }
  }
}
