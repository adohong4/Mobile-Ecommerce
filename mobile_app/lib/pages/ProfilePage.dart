import 'package:flutter/material.dart';
import 'package:mobile_app/pages/viewed_page.dart';
import 'package:mobile_app/services/profile_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import 'package:mobile_app/pages/LoginPage.dart';
import 'package:mobile_app/pages/ShippingAddressPage.dart';
import 'package:mobile_app/pages/OrderDetailPage.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/pages/EditProfilePage.dart';
import 'package:mobile_app/pages/WishList.dart';

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
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: .0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // giữ label đều nhau
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // if (!authProvider.isAuthenticated) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => LoginPage()),
    //     );
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hồ Sơ"),
        centerTitle: true,
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
                    // Background image phía trên thông tin cá nhân
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                _profile!['backgroundImage'] ??
                                    'https://images.unsplash.com/photo-1503264116251-35a269479413?auto=format&fit=crop&w=800&q=60',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF194689),
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      _profile!['profilePic'] != null
                                          ? NetworkImage(
                                            _profile!['profilePic'],
                                          )
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
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _profile?['fullName'] ?? user?['email'] ?? 'Người dùng',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black54,
                                          offset: Offset(1, 1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProfilePage(
                                            profile: _profile!,
                                          ),
                                        ),
                                      ).then((_) => _fetchProfile());
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero, // bỏ padding dư thừa
                                      minimumSize: Size(24, 24), // chỉnh nhỏ nút lại
                                    ),
                                  ),
                                ],
                              ),



                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildInfoRow("Email", user?['email'] ?? 'Chưa cập nhật'),
                                  const Divider(),
                                  _buildInfoRow("Số điện thoại", _profile!['phoneNumber'] ?? 'Chưa cập nhật'),
                                  const Divider(),
                                  _buildInfoRow(
                                    "Ngày sinh",
                                    _profile!['dateOfBirth'] != null
                                        ? _formatDate(_profile!['dateOfBirth'])
                                        : 'Chưa cập nhật',
                                  ),
                                  const Divider(),
                                  _buildInfoRow(
                                    "Giới tính",
                                    _profile!['gender'] == 'MALE'
                                        ? 'Nam'
                                        : (_profile!['gender'] == 'FEMALE' ? 'Nữ' : 'Chưa xác định'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )


                    ),
                    const Divider(height: 00),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text(
                        "Lịch sử mua hàng",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      trailing: const Text(
                        "Chi tiết",
                        style: TextStyle(
                          color: Color(0xFF194689),
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
                      leading: const Icon(Icons.watch_later_outlined),
                      title: const Text(
                        "Đã xem gần đây",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      trailing: const Text(
                        "Chi tiết",
                        style: TextStyle(
                          color: Color(0xFF194689),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViewedPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_border),
                      title: const Text(
                        "Đã thích",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      trailing: const Text(
                        "Chi tiết",
                        style: TextStyle(
                          color: Color(0xFF194689),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WishList(),
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
                        _getActiveAddress(_profile!['address']),
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      trailing: const Text(
                        "Thay đổi địa chỉ",
                        style: TextStyle(
                          color: Color(0xFF194689),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ShippingAddressPage(),
                          ),
                        ).then((_) => _fetchProfile());
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
                            backgroundColor: const Color(0xFF194689),
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
      bottomNavigationBar: CustomBottomNav(
        parentContext: context,
        selectedIndex: 4,
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return date;
    }
  }

  String _getActiveAddress(List<dynamic>? addresses) {
    if (addresses == null || addresses.isEmpty) {
      return 'Chưa cập nhật';
    }

    final activeAddress = addresses.firstWhere(
      (address) => address['active'] == true,
      orElse: () => addresses[0],
    );

    return activeAddress != null
        ? "${activeAddress['street']}, ${activeAddress['city']}${activeAddress['province'] != null ? ', ${activeAddress['province']}' : ''}"
        : 'Chưa cập nhật';
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
