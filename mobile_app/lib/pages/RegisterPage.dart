import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/pages/LoginPage.dart';
import 'package:mobile_app/services/LoginService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreePolicyAndTerms = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  final LoginService _loginService = LoginService();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreePolicyAndTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đồng ý với Chính sách và Điều khoản'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _loginService.register(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Đăng ký thành công')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/logo.png', height: 200),
                const SizedBox(height: 30.0),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Text(
                  'Tên đăng nhập',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'taikhoan123',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên đăng nhập';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'email@gmail.com',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Mật khẩu',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: '*******',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Nhập lại mật khẩu',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: '*******',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu';
                    }
                    if (value != _passwordController.text) {
                      return 'Mật khẩu không khớp';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: Checkbox(
                            value: _agreePolicyAndTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreePolicyAndTerms = value!;
                              });
                            },
                            activeColor: const Color(0xFF0D47A1),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Tôi đồng ý với ',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextSpan(
                                text: 'Chính sách',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFF0D47A1),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextSpan(
                                text: ' và ',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextSpan(
                                text: 'Điều khoản',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFF0D47A1),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5.0,
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                ),
                const SizedBox(height: 24.0),
                Text.rich(
                  TextSpan(
                    text: 'Tôi đã có tài khoản? ',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Đăng nhập ngay',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Color(0xFF0D47A1),
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
