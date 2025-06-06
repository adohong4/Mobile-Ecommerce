import 'package:flutter/material.dart';
import 'package:mobile_app/pages/HomePage.dart';
import 'package:mobile_app/services/payment_service.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  @override
  void initState() {
    super.initState();
    // Lấy query parameters từ URL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = Uri.base; // Lấy URL hiện tại
      final success = uri.queryParameters['success'] == 'true';
      final orderId = uri.queryParameters['orderId'];
      if (orderId != null) {
        _verifyOrder(orderId, success);
      } else {
        _showError('Không tìm thấy ID đơn hàng');
      }
    });
  }

  Future<void> _verifyOrder(String orderId, bool success) async {
    try {
      final paymentService = PaymentService();
      await paymentService.verifyStripeOrder(orderId, success);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Thanh toán thành công' : 'Thanh toán bị hủy',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      // Chuyển về HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      _showError('Lỗi: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    // Chuyển về HomePage sau lỗi
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
