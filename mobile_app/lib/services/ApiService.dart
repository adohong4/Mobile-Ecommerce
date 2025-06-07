class ApiService {
  static const String route = "http://192.168.1.9"; //192.168.1.9
  static const String imageBaseUrl = "$route:9004/images/";

  static const String identityService = "$route:9001/v1/api/identity";
  static const String profileService = "$route:9003/v1/api/profile";
  static const String productService = "$route:9004/v1/api/product";
  static const String messageService = "$route:9002/v1/api/message";
  static const String paymentService = "$route:9007/v1/api/payment";
  static const String recommend = "$route:5000/v1/api/recommend/viewed";
  static const String Search = "$route:5001/v1/api/search";

  static const String productList = "$productService/get";
  static const String voucher = "$productService/voucher";

  static const String address = "$profileService/address";
}
