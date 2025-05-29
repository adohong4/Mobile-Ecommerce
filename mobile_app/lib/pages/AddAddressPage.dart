import 'package:flutter/material.dart';
import 'package:mobile_app/models/addressModel.dart';
import 'package:mobile_app/services/address_service.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _wardController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final AddressService _addressService = AddressService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _wardController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    super.dispose();
  }

  Future<void> _submitAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final address = AddressModel(
        fullname: _nameController.text,
        phone: _phoneController.text,
        street: _streetController.text,
        precinct: _wardController.text.isNotEmpty ? _wardController.text : null,
        city: _cityController.text,
        province:
            _provinceController.text.isNotEmpty
                ? _provinceController.text
                : null,
        isDefault: false,
      );

      final result = await _addressService.createAddress(address);
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        // Xóa sạch các trường nhập liệu
        _nameController.clear();
        _phoneController.clear();
        _streetController.clear();
        _wardController.clear();
        _cityController.clear();
        _provinceController.clear();

        // Hiển thị thông báo thành công từ JSON với màu xanh lá cây
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm địa chỉ thành công'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Quay lại ShippingAddressPage
      } else {
        // Hiển thị thông báo lỗi với màu đỏ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Không thể tạo địa chỉ'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Kiểm tra định dạng số điện thoại Việt Nam (bắt đầu bằng 0, theo sau là 9 số)
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ (phải bắt đầu bằng 0 và có 10 số)';
    }
    return null;
  }

  // Kiểm tra địa chỉ (đường, quận/huyện): không quá ngắn, không chứa ký tự đặc biệt không mong muốn
  String? _validateAddress(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    if (value.length < 3) {
      return '$fieldName quá ngắn (tối thiểu 3 ký tự)';
    }
    final addressRegex = RegExp(r'^[a-zA-Z0-9\sÀ-ỹ]+$');
    if (!addressRegex.hasMatch(value)) {
      return '$fieldName chứa ký tự không hợp lệ';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm địa chỉ mới'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    label: 'Họ và tên:',
                    controller: _nameController,
                    decoration: inputDecoration,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Vui lòng nhập họ tên' : null,
                  ),
                  _buildTextField(
                    label: 'Số điện thoại:',
                    controller: _phoneController,
                    decoration: inputDecoration,
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                  ),
                  _buildTextField(
                    label: 'Đường:',
                    controller: _streetController,
                    decoration: inputDecoration,
                    validator: (value) => _validateAddress(value, 'Tên đường'),
                  ),
                  _buildTextField(
                    label: 'Phường/Xã (tùy chọn):',
                    controller: _wardController,
                    decoration: inputDecoration,
                  ),
                  _buildTextField(
                    label: 'Quận/Huyện:',
                    controller: _cityController,
                    decoration: inputDecoration,
                    validator: (value) => _validateAddress(value, 'Quận/Huyện'),
                  ),
                  _buildTextField(
                    label: 'Tỉnh/Thành phố (tùy chọn):',
                    controller: _provinceController,
                    decoration: inputDecoration,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Thêm địa chỉ',
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
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required InputDecoration decoration,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            decoration: decoration,
            keyboardType: keyboardType,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
