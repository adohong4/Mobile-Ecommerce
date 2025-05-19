import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import 'package:mobile_app/pages/LoginPage.dart';
import 'package:mobile_app/pages/AddAddressPage.dart';
import 'package:mobile_app/pages/OrderDetailPage.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      debugShowCheckedModeBanner: false,
      home: const ProfilePage(),
    );
  }
}

// Fake data class
class FakeUserData {
  static const String name = "Nguyễn Việt Anh";
  static const String email = "nguyenvana123@gmail.com";
  static const String phone = "0901.234.567";
  static const String birthDate = "15/08/1995";
  static const String gender = "Nam";
  static const String address = "123 Đường ABC, Quận 1, TP. HCM";
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            child: Icon(Icons.pets, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(FakeUserData.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: const [
                UserInfoRow(label: "Email", value: FakeUserData.email),
                UserInfoRow(label: "Số điện thoại", value: FakeUserData.phone),
                UserInfoRow(label: "Ngày sinh", value: FakeUserData.birthDate),
                UserInfoRow(label: "Giới tính", value: FakeUserData.gender),
              ],
            ),
          ),
          const Divider(height: 30),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Lịch sử mua hàng", style: TextStyle(fontFamily: 'Poppins',)),
            trailing:
            const Text("Chi tiết", style: TextStyle(color: Colors.blue,fontSize: 14, fontFamily: 'Poppins')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderDetailPage(),),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text("Địa chỉ nhận hàng", style: TextStyle(fontFamily: 'Poppins')),
            subtitle: Text(FakeUserData.address, style: TextStyle(fontFamily: 'Poppins')),
            trailing: const Text("Thay đổi địa chỉ",
                style: TextStyle(color: Colors.blue, fontFamily: 'Poppins',fontSize: 14)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAddressPage(),
                ),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text("Đăng xuất", style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              ),
            ),
          )
        ],
      ),
        bottomNavigationBar: CustomBottomNav(parentContext: context),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

}
