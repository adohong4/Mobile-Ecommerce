import 'package:flutter/material.dart';
import 'package:mobile_app/services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> profile;

  const EditProfilePage({Key? key, required this.profile}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  String? _gender;
  bool _isProfileSaved = false; // Theo dõi trạng thái lưu hồ sơ
  late bool _isProfileEmpty; // Kiểm tra hồ sơ có rỗng không

  final Color primaryColor = const Color(0xFF194689);
  final Color secondaryColor = const Color(0xFF1AA7DD);
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    // Kiểm tra hồ sơ có rỗng không
    _isProfileEmpty =
        widget.profile.isEmpty ||
        (widget.profile['fullName'] == null &&
            widget.profile['phoneNumber'] == null &&
            widget.profile['dateOfBirth'] == null &&
            widget.profile['gender'] == null);

    _fullNameController = TextEditingController(
      text: widget.profile['fullName'] ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.profile['phoneNumber'] ?? '',
    );
    _dobController = TextEditingController(
      text:
          widget.profile['dateOfBirth'] != null
              ? _formatDateForDisplay(widget.profile['dateOfBirth'])
              : '',
    );
    _gender = widget.profile['gender'];
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Chuyển đổi định dạng ngày từ ISO (Date) hoặc string sang DD-MM-YYYY
  String _formatDateForDisplay(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}';
    } catch (e) {
      if (_isValidDateFormat(date)) return date;
      return '';
    }
  }

  // Hiển thị DatePicker và cập nhật _dobController
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _dobController.text.isNotEmpty
              ? _parseDate(_dobController.text)
              : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryColor,
            colorScheme: ColorScheme.light(primary: secondaryColor),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  // Parse ngày từ DD-MM-YYYY sang DateTime
  DateTime _parseDate(String date) {
    try {
      final parts = date.split('-');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }

  // Kiểm tra định dạng DD-MM-YYYY và ngày hợp lệ
  bool _isValidDateFormat(String date) {
    final regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!regex.hasMatch(date)) return false;

    try {
      final parts = date.split('-');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      if (year < 1900 || year > DateTime.now().year) return false;
      if (month < 1 || month > 12) return false;
      if (day < 1 || day > 31) return false;

      final maxDays = DateTime(year, month + 1, 0).day;
      if (day > maxDays) return false;

      DateTime.parse(
        '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveChanges() async {
    if (_fullNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!_isValidDateFormat(_dobController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ngày sinh phải có định dạng DD-MM-YYYY và hợp lệ!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await _profileService.updateProfile(
      fullName: _fullNameController.text,
      gender: _gender!,
      phoneNumber: _phoneController.text,
      dateOfBirth: _dobController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['message'],
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );

    if (result['success']) {
      setState(() {
        _isProfileSaved = true; // Đánh dấu hồ sơ đã lưu thành công
      });
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  // Xử lý nút quay lại
  Future<bool> _onWillPop() async {
    if (!_isProfileEmpty || _isProfileSaved) {
      // Cho phép quay lại nếu hồ sơ đã có thông tin hoặc đã lưu thành công
      return true;
    } else {
      // Hiển thị thông báo yêu cầu lưu thông tin
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng lưu thông tin hồ sơ trước khi thoát!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false; // Chặn nút quay lại
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Gắn hàm xử lý nút quay lại
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Chỉnh sửa hồ sơ',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.white,
          foregroundColor: primaryColor,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputLabel("Họ và tên"),
              _buildTextField(_fullNameController, hint: 'Nhập họ và tên'),
              const SizedBox(height: 16),
              _buildInputLabel("Số điện thoại"),
              _buildTextField(
                _phoneController,
                hint: 'Nhập số điện thoại',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildInputLabel("Ngày sinh"),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: _buildTextField(
                    _dobController,
                    hint: 'DD-MM-YYYY',
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildInputLabel("Giới tính"),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: primaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'MALE', child: Text('Nam')),
                  DropdownMenuItem(value: 'FEMALE', child: Text('Nữ')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Khác')),
                ],
                onChanged: (value) => setState(() => _gender = value),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Lưu thay đổi',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: primaryColor,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: const TextStyle(fontFamily: 'Poppins'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'Poppins'),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
