import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/addressModel.dart';
import 'package:mobile_app/pages/AddAddressPage.dart';
import 'package:mobile_app/services/address_service.dart';

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  List<AddressModel> addresses = [];
  bool isLoading = true;
  final AddressService _addressService = AddressService();
  final Color darkBlue = const Color(0xFF194689);
  final Color lightBlue = const Color(0xFF1AA7DD);

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    setState(() => isLoading = true);
    final result = await _addressService.getAddresses();
    if (result['success']) {
      setState(() {
        addresses = result['addresses'];
        isLoading = false;
        if (!addresses.any((address) => address.active) &&
            addresses.isNotEmpty) {
          _setDefaultAddress(0);
        }
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  Future<void> _setDefaultAddress(int index) async {
    final addressId = addresses[index].id;
    if (addressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi: Địa chỉ không hợp lệ')),
      );
      return;
    }

    final result = await _addressService.setDefaultAddress(addressId);
    if (result['success']) {
      setState(() {
        addresses =
            addresses
                .map((address) => address.copyWith(active: false))
                .toList();
        addresses[index] = addresses[index].copyWith(active: true);
      });
      Flushbar(
        message: 'Đã đặt địa chỉ làm mặc định',
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.green,
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.location_on, color: Colors.white),
      ).show(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  Future<void> _deleteAddress(String? addressId, int index) async {
    if (addressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi: Địa chỉ không hợp lệ')),
      );
      return;
    }
    final result = await _addressService.deleteAddress(addressId);
    if (result['success']) {
      setState(() {
        addresses.removeAt(index);
      });

      Flushbar(
        message: 'Đã xóa địa chỉ',
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.location_on, color: Colors.white),
      ).show(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  void _showEditDialog(int index) {
    final address = addresses[index];
    final fullnameController = TextEditingController(text: address.fullname);
    final phoneController = TextEditingController(text: address.phone);
    final streetController = TextEditingController(text: address.street);
    final cityController = TextEditingController(text: address.city);
    final precinctController = TextEditingController(
      text: address.precinct ?? '',
    );
    final provinceController = TextEditingController(
      text: address.province ?? '',
    );

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Chỉnh sửa địa chỉ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF194689),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: fullnameController,
                      decoration: InputDecoration(
                        labelText: "Họ tên",
                        labelStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1AA7DD),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Số điện thoại",
                        labelStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1AA7DD),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: streetController,
                      decoration: InputDecoration(
                        labelText: "Đường",
                        labelStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1AA7DD),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: "Quận/Huyện",
                        labelStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1AA7DD),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: precinctController,
                      decoration: InputDecoration(
                        labelText: "Phường/Xã (tùy chọn)",
                        labelStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1AA7DD),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: provinceController,
                      decoration: InputDecoration(
                        labelText: "Tỉnh/Thành phố (tùy chọn)",
                        labelStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1AA7DD),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                            textStyle: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Hủy"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1AA7DD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () async {
                            final updatedAddress = AddressModel(
                              id: address.id,
                              fullname: fullnameController.text,
                              phone: phoneController.text,
                              street: streetController.text,
                              city: cityController.text,
                              precinct:
                                  precinctController.text.isNotEmpty
                                      ? precinctController.text
                                      : null,
                              province:
                                  provinceController.text.isNotEmpty
                                      ? provinceController.text
                                      : null,
                              active: address.active,
                            );
                            final result = await _addressService.createAddress(
                              updatedAddress,
                            );
                            if (result['success']) {
                              setState(() {
                                addresses[index] = updatedAddress;
                              });
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã cập nhật địa chỉ'),
                                ),
                              );
                            } else {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result['message'])),
                              );
                            }
                          },
                          child: const Text(
                            "Lưu",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildAddressCard(int index) {
    final address = addresses[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${address.fullname ?? 'Không có tên'} | ${address.phone ?? 'Không có số'}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                if (address.active)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Mặc định",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address.fullAddress,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      address.active ? null : () => _setDefaultAddress(index),
                  child: Text(
                    "Chọn làm mặc định",
                    style: TextStyle(
                      color: address.active ? Colors.grey : lightBlue,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _showEditDialog(index),
                  child: const Text(
                    "Sửa",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF1AA7DD),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Địa chỉ giao hàng",
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : addresses.isEmpty
              ? const Center(
                child: Text(
                  'Không có địa chỉ nào',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              )
              : ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return Dismissible(
                    key: Key(address.id ?? address.phone ?? index.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Xác nhận"),
                              content: const Text(
                                "Bạn có chắc chắn muốn xóa địa chỉ này?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text("Hủy"),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text(
                                    "Xóa",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                    onDismissed:
                        (direction) => _deleteAddress(address.id, index),
                    child: _buildAddressCard(index),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkBlue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAddressPage()),
          ).then((_) => _fetchAddresses());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
