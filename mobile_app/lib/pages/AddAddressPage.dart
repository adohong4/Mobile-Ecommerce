import 'package:flutter/material.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _wardController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _wardController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    super.dispose();
  }

  void _submitAddress() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _wardController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _provinceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thêm địa chỉ không thành công. Vui lòng điền đầy đủ thông tin.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thêm địa chỉ thành công'),
          backgroundColor: Colors.green,
        ),
      );
    }
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
                )
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(label: 'Họ và tên:', controller: _nameController, decoration: inputDecoration),
                _buildTextField(label: 'Số điện thoại:', controller: _phoneController, decoration: inputDecoration),
                _buildTextField(label: 'Địa chỉ:', controller: _addressController, decoration: inputDecoration),
                _buildTextField(label: 'Phường:', controller: _wardController, decoration: inputDecoration),
                _buildTextField(label: 'Thành phố:', controller: _cityController, decoration: inputDecoration),
                _buildTextField(label: 'Tỉnh:', controller: _provinceController, decoration: inputDecoration),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Thêm địa chỉ', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, required InputDecoration decoration}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontFamily: 'Poppins')),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: decoration,
          ),
        ],
      ),
    );
  }
}
