import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../MainPage/HomePage.dart';
import 'RegisterPage.dart';
import 'package:doca_project/component/routeGlobal.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //mendeklarasikan variabel yang akan kita guanakan
  String _email = '';
  String _password = '';
  bool _emailError = false;
  bool _passwordError = false;

  //membuat fungsi login yang akan digunakan
  Future<void> _login() async {
    final url = '${baseurl}login';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _email, 'password': _password}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null && jsonResponse['email'] == _email) {
        //pada bagian ini kita akan menggunakan fungsi SharedPreference dimana akan,
        //mengambil semua nilai yang ada kemudian memasukannya kedalam sebuah variabel.
        // Simpan id_user ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id_user', jsonResponse['id_user']);
        await prefs.setString('username', jsonResponse['username']);
        await prefs.setString('email', jsonResponse['email']);
        await prefs.setString('image', jsonResponse['image_path']);

        //jika berhasil akan muncul toast success
        Fluttertoast.showToast(
          msg: "You have successfully logged in",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        //error handlingnya
      } else {
        _showErrorToast("Invalid email/password");
      }
    } else {
      _showErrorToast("Invalid email/password");
    }
  }

  //fungsi untuk menampilkan toast error, dengan pesan yang harus disesuaikan.
  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFA500),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(40.0),
              child: Image.asset(
                'assets/images/OnBoardingIMG.png',
                width: 170,
                height: 170,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              padding: EdgeInsets.only(top: 25.0, right: 15.0, left: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome Back',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Please Sign In to continue',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email*',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: _emailError ? Colors.red : Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _emailError ? Colors.red : Colors.black,
                          width: _emailError ? 2.0 : 1.0,
                        ),
                      ),
                      //jika bentuknya seperti ini menandakan untuk mengecek error dengan kondisi tertentu.
                      errorText: _emailError ? 'Invalid email' : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                        _emailError = !_isValidEmail(value);
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Password*',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: _passwordError ? Colors.red : Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _passwordError ? Colors.red : Colors.black,
                          width: _passwordError ? 2.0 : 1.0,
                        ),
                      ),
                      //jika bentuknya seperti ini menandakan untuk mengecek error dengan kondisi tertentu.
                      errorText: _passwordError ? 'Password must be at least 8 characters' : null,
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                        _passwordError = value.length < 8;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (!_emailError && !_passwordError) {
                        _login();
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Invalid email or password',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 13, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return email.contains('@');
  }
}
