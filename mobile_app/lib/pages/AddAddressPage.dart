import 'package:flutter/material.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

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
                _buildTextField(label: 'Họ và tên:', decoration: inputDecoration),
                _buildTextField(label: 'Số điện thoại :', decoration: inputDecoration),
                _buildTextField(label: 'Địa chỉ :', decoration: inputDecoration),
                _buildTextField(label: 'Phường :', decoration: inputDecoration),
                _buildTextField(label: 'Thành phố :', decoration: inputDecoration),
                _buildTextField(label: 'Tỉnh :', decoration: inputDecoration),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366), // Dark blue
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Thêm địa chỉ',  style: TextStyle(color: Colors.white,fontFamily: 'Poppins')),
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

  Widget _buildTextField({required String label, required InputDecoration decoration}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16,fontFamily: 'Poppins'),),
          const SizedBox(height: 6),
          TextField(decoration: decoration),
        ],
      ),
    );
  }
}
