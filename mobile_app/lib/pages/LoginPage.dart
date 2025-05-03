import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/pages/HomePage.dart';
import 'package:mobile_app/pages/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberPassword = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/logo.png', height: 200),
              SizedBox(height: 30.0),

              Text(
                'Tài khoản',
                style: TextStyle(
                  fontSize: 16.0,
                  //   fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'email@gmail.com',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              Text(
                'Mật khẩu',
                style: TextStyle(
                  fontSize: 16.0,
                  //   fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: '*******',
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
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
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: Checkbox(
                          value: _rememberPassword,
                          onChanged: (value) {
                            setState(() {
                              _rememberPassword = value!;
                            });
                          },
                          activeColor: Color(0xFF0D47A1),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        'Nhớ mật khẩu',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Quên mật khẩu ?',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0D47A1),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5.0,
                ),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 18.0,
                    // fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 24.0),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[400])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Đăng nhập với',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[400])),
                ],
              ),
              SizedBox(height: 24.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.facebook,
                      size: 50.0,
                      color: Color.fromARGB(255, 21, 109, 241),
                    ),
                  ),
                  SizedBox(width: 24.0),

                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'Google_Icon.png',
                      width: 60.0,
                      height: 60.0,
                    ),
                  ),
                  SizedBox(width: 24.0),

                  InkWell(
                    onTap: () {},
                    child: Icon(Icons.apple, size: 50.0, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 30.0),

              Text.rich(
                TextSpan(
                  text: 'Tôi chưa có tài khoản? ',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Đăng ký ngay',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              //   print('Đăng ký ngay được nhấn!');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
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
    );
  }
}
