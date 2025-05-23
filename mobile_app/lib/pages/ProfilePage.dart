import 'package:flutter/material.dart';
import 'package:mobile_app/services/profile_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import 'package:mobile_app/pages/LoginPage.dart';
import 'package:mobile_app/pages/AddAddressPage.dart';
import 'package:mobile_app/pages/OrderDetailPage.dart';
import 'package:mobile_app/providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _profile;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ProfileService().getProfile();

    setState(() {
      _isLoading = false;
      if (result['success']) {
        _profile = result['profile'];
      } else {
        _errorMessage = result['message'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hồ Sơ"),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage!,
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _fetchProfile,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
              : _profile == null
              ? const Center(
                child: Text(
                  'Không tải được hồ sơ',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          _profile!['profilePic'] != null
                              ? NetworkImage(_profile!['profilePic'])
                              : null,
                      child:
                          _profile!['profilePic'] == null
                              ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _profile!['fullName'] ?? user?['email'] ?? 'Người dùng',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          UserInfoRow(
                            label: "Email",
                            value: user?['email'] ?? 'Chưa cập nhật',
                          ),
                          UserInfoRow(
                            label: "Số điện thoại",
                            value: _profile!['phoneNumber'] ?? 'Chưa cập nhật',
                          ),
                          UserInfoRow(
                            label: "Ngày sinh",
                            value:
                                _profile!['dateOfBirth'] != null
                                    ? _formatDate(_profile!['dateOfBirth'])
                                    : 'Chưa cập nhật',
                          ),
                          UserInfoRow(
                            label: "Giới tính",
                            value: _profile!['gender'] ?? 'Chưa cập nhật',
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 30),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text(
                        "Lịch sử mua hàng",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      trailing: const Text(
                        "Chi tiết",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderDetailPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: const Text(
                        "Địa chỉ nhận hàng",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      subtitle: Text(
                        _profile!['address']?.isNotEmpty == true
                            ? "${_profile!['address'][0]['street']}, ${_profile!['address'][0]['city']}"
                            : 'Chưa cập nhật',
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      trailing: const Text(
                        "Thay đổi địa chỉ",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddAddressPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                          ),
                          onPressed: () async {
                            await Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            ).logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Đăng xuất",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: CustomBottomNav(parentContext: context),
    );
  }

  // Hàm định dạng ngày sinh
  String _formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return date;
    }
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
              style: const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
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
