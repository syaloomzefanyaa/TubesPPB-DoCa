import 'dart:convert';
import 'package:doca_project/CompleteDataPet/CompleteImage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'LoginPage.dart';
import 'package:doca_project/component/routeGlobal.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _username = '';
  String _email = '';
  String _password = '';
  bool _usernameError = false;
  bool _emailError = false;
  bool _passwordError = false;

  Future<void> _register() async {
    print('Username: $_username');
    print('Email: $_email');
    print('Password: $_password');

    // Proses registrasi ke server
    final url = '${baseurl}register';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _username,
        'email': _email,
        'password': _password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null && jsonResponse['id_user'] != null) {
        Fluttertoast.showToast(
          msg: "Your account has been successfully registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        int idUser = jsonResponse['id_user'];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompleteImage(idUser: idUser)),
        );
        //jika bentuknya seperti ini menandakan untuk mengecek error dengan kondisi tertentu.
      } else {
        _showErrorToast("Registration failed. try again.");
      }
    } else {
      _showErrorToast("Registration failed. try again.");
    }
  }

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
                    'Create An Account',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Username*',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: _usernameError ? Colors.red : Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _usernameError ? Colors.red : Colors.black,
                          width: _usernameError ? 2.0 : 1.0,
                        ),
                      ),
                      errorText: _usernameError ? 'Username Invalid' : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _username = value;
                        _usernameError = !_isValidUsername(value);
                      });
                    },
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
                      errorText: _emailError ? 'Email Invalid' : null,
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
                      errorText: _passwordError ? 'at least 8 character password' : null,
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
                      if (!_usernameError && !_emailError && !_passwordError) {
                        _register();
                      } else {
                        _showErrorToast('Please Fill The Form Correctly');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Sign Up'),
                  ),
                  SizedBox(height: 20),
                  // Widget lainnya
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have account? ',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              'Sign In',
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

  bool _isValidUsername(String username) {
    final RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$');
    return regex.hasMatch(username);
  }
}
