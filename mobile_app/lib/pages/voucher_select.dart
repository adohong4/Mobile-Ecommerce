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
      // Làm mới danh sách voucher để hiển thị voucher vừa thêm
      await provider.fetchUserVouchers();
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
    // Cập nhật selectedVoucher trong VoucherProvider
    Provider.of<VoucherProvider>(
      context,
      listen: false,
    ).fetchVoucherById(_selectedVoucherId!);
    // Quay lại CheckoutPage với voucher đã chọn
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
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB74D), // Màu cam
            ),
            child: Image.asset(
              'assets/banner_2.png',
              height: 200,
              fit: BoxFit.cover,
            ),
          ),



          // TextField nhập mã voucher và nút Áp dụng
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        hintText: 'Nhập mã code voucher',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), // bo góc mềm
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF003366)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _codeController.text.trim().isEmpty ? null : _applyVoucherCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _codeController.text.trim().isEmpty
                          ? Colors.grey.shade400
                          : const Color(0xFF003366),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // bo góc button
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      elevation: _codeController.text.trim().isEmpty ? 0 : 4,
                    ),
                    child: const Text(
                      'Áp dụng',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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
                  return Center(
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }
                if (provider.vouchers.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không có voucher nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: provider.vouchers.length,
                  itemBuilder: (context, index) {
                    final voucher = provider.vouchers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: _buildVoucherItem(voucher),
                    );
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
              height: 52,
              child: ElevatedButton(
                onPressed: _selectedVoucherId == null
                    ? null
                    : () => _confirmSelection(
                  Provider.of<VoucherProvider>(context, listen: false).vouchers,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedVoucherId == null
                      ? Colors.grey.shade400
                      : const Color(0xFF003366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: _selectedVoucherId == null ? 0 : 5,
                ),
                child: const Text(
                  'Đồng ý',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
    final isSelected = voucher.id == _selectedVoucherId;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? const Color(0xFF003366) : Colors.transparent,
          width: 2,
        ),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => _selectVoucher(voucher.id),
        borderRadius: BorderRadius.circular(12),
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
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color:
                            isSelected ? const Color(0xFF003366) : Colors.black,
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
                              decoration: TextDecoration.underline,
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
      ),
    );
  }
}
