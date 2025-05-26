import 'package:flutter/material.dart';
import 'package:mobile_app/pages/AddAddressPage.dart';

class Address {
  final String name;
  final String phone;
  final String address;
  final bool isDefault;

  Address({
    required this.name,
    required this.phone,
    required this.address,
    this.isDefault = false,
  });

  Address copyWith({
    String? name,
    String? phone,
    String? address,
    bool? isDefault,
  }) {
    return Address(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  List<Address> addresses = [
    Address(
      name: "Nguyễn Văn A",
      phone: "0901234567",
      address: "123 Lê Lợi, Quận 1, TP.HCM",
      isDefault: true,
    ),
    Address(
      name: "Trần Thị B",
      phone: "0912345678",
      address: "456 Nguyễn Trãi, Quận 5, TP.HCM",
    ),
    Address(
      name: "Lê Văn C",
      phone: "0923456789",
      address: "789 Phạm Văn Đồng, Thủ Đức, TP.HCM",
    ),
  ];

  final Color darkBlue = const Color(0xFF194689);
  final Color lightBlue = const Color(0xFF1AA7DD);

  void setDefaultAddress(int index) {
    setState(() {
      addresses = addresses.map((address) => address.copyWith(isDefault: false)).toList();
      addresses[index] = addresses[index].copyWith(isDefault: true);
    });
  }

  void showEditDialog(int index) {
    final nameController = TextEditingController(text: addresses[index].name);
    final phoneController = TextEditingController(text: addresses[index].phone);
    final addressController = TextEditingController(text: addresses[index].address);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Họ tên",
                    labelStyle: const TextStyle(fontFamily: 'Poppins'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF1AA7DD)),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF1AA7DD)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Địa chỉ",
                    labelStyle: const TextStyle(fontFamily: 'Poppins'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF1AA7DD)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          addresses[index] = Address(
                            name: nameController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                            isDefault: addresses[index].isDefault,
                          );
                        });
                        Navigator.of(context).pop();
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
                Text("${address.name} | ${address.phone}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Poppins')),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("Mặc định",
                        style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Poppins')),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(address.address,
                style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', color: Colors.black87)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setDefaultAddress(index),
                  child: Text("Chọn làm mặc định",
                      style: TextStyle(
                          color: address.isDefault ? Colors.grey : lightBlue,
                          fontFamily: 'Poppins')),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => showEditDialog(index),
                  child: const Text("Sửa", style: TextStyle(fontFamily: 'Poppins')),
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
      body: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final address = addresses[index];
          return Dismissible(
            key: Key(address.phone),
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
                builder: (context) => AlertDialog(
                  title: const Text("Xác nhận"),
                  content: const Text("Bạn có chắc chắn muốn xóa địa chỉ này?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Hủy"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Xóa", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              setState(() {
                addresses.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa địa chỉ')),
              );
            },
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
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
