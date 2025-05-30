import 'package:flutter/material.dart';
import 'package:mobile_app/pages/CartPage.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/models/voucher_model.dart';
import 'package:mobile_app/pages/voucher_detail.dart';
import 'package:mobile_app/providers/voucher_provider.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  @override
  void initState() {
    super.initState();
    // Lấy danh sách voucher khi khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VoucherProvider>(context, listen: false).fetchUserVouchers();
    });
  }

  Future<void> _useVoucher(String voucherId) async {
    final provider = Provider.of<VoucherProvider>(context, listen: false);
    final error = await provider.useVoucher(voucherId);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sử dụng voucher thành công'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ưu đãi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<VoucherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          if (provider.vouchers.isEmpty) {
            return const Center(child: Text('Không có voucher nào'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.vouchers.length,
            itemBuilder: (context, index) {
              final voucher = provider.vouchers[index];
              return _buildVoucherCard(voucher);
            },
          );
        },
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }

  Widget _buildVoucherCard(VoucherModel voucher) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${voucher.code} - Giảm ${voucher.formattedDiscount} tối đa ${voucher.formattedMaxDiscount}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'HSD: ${voucher.formattedEndDate}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sử dụng ngay',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => VoucherDetail(voucherId: voucher.id!),
                      ),
                    );
                  },
                  child: const Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF003366),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
