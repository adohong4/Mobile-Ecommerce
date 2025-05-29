import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/models/voucher_model.dart';
import 'package:mobile_app/pages/voucher_detail.dart';
import 'package:mobile_app/providers/voucher_provider.dart';

class VoucherSelectPage extends StatefulWidget {
  const VoucherSelectPage({super.key});

  @override
  State<VoucherSelectPage> createState() => _VoucherSelectPageState();
}

class _VoucherSelectPageState extends State<VoucherSelectPage> {
  final TextEditingController _codeController = TextEditingController();
  String? _selectedVoucherId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VoucherProvider>(context, listen: false).fetchUserVouchers();
    });

    _codeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _applyVoucherCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập mã voucher'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = Provider.of<VoucherProvider>(context, listen: false);
    final error = await provider.addVoucherToUser(code);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Áp dụng voucher thành công'),
          backgroundColor: Colors.green,
        ),
      );
      _codeController.clear();
    }
  }

  void _selectVoucher(String? voucherId) {
    setState(() {
      _selectedVoucherId = voucherId;
    });
  }

  void _confirmSelection(List<VoucherModel> vouchers) {
    if (_selectedVoucherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn một voucher'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final selectedVoucher = vouchers.firstWhere(
      (voucher) => voucher.id == _selectedVoucherId,
    );
    Navigator.pop(context, selectedVoucher);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lựa chọn Voucher',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // TextField nhập mã voucher và nút Áp dụng
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        hintText: 'Nhập mã code voucher',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Color(0xFF003366)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        _codeController.text.trim().isEmpty
                            ? null
                            : _applyVoucherCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _codeController.text.trim().isEmpty
                              ? Colors.grey
                              : const Color(0xFF003366),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text(
                      'Áp dụng',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Danh sách voucher
          Expanded(
            child: Consumer<VoucherProvider>(
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.vouchers.length,
                  itemBuilder: (context, index) {
                    final voucher = provider.vouchers[index];
                    return _buildVoucherItem(voucher);
                  },
                );
              },
            ),
          ),
          // Nút Đồng ý
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _selectedVoucherId == null
                        ? null
                        : () => _confirmSelection(
                          Provider.of<VoucherProvider>(
                            context,
                            listen: false,
                          ).vouchers,
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedVoucherId == null
                          ? Colors.grey
                          : const Color(0xFF003366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Đồng ý',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }

  Widget _buildVoucherItem(VoucherModel voucher) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon voucher
            const Icon(Icons.discount, size: 50, color: Color(0xFF003366)),
            const SizedBox(width: 15),
            // Voucher Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giảm ${voucher.formattedDiscount} cho đơn từ ${voucher.minOrderValue} VNĐ',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                        'HSD: ${voucher.formattedEndDate}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          if (voucher.id != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        VoucherDetail(voucherId: voucher.id!),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Điều kiện',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF003366),
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Radio button
            Radio<String?>(
              value: voucher.id,
              groupValue: _selectedVoucherId,
              onChanged: (value) => _selectVoucher(value),
              activeColor: const Color(0xFF003366),
            ),
          ],
        ),
      ),
    );
  }
}
