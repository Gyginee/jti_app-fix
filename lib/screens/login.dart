import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jti_app/main.dart';
import 'package:jti_app/providers/constants.dart';
import 'package:jti_app/providers/shared.dart';
import 'package:jti_app/providers/utility.dart';
import 'package:jti_app/screens/homepage.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  void checkLoggedIn() {
    int? uid = UserData.getUserId();
    if (uid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => DashboardScreen()));
      });
    }
  }

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    if (await Utility.isInternetConnected()) {
      var url = Uri.parse("${Constants.API_URL}auth/login");
      var response = await http.post(url, body: {
        "username": _email,
        "password": _password,
      });
      var data = json.decode(response.body);
      if (response.statusCode == 200 && data['isSuccess'] == true) {
        var userId = data['data']['id'];
        var username = data['data']['username'];
        await UserData.saveUserId(userId);
        await UserData.saveUsername(username);
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => DashboardScreen()));
        });
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else {
      Utility.errorInterner();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2FD),
        appBar: AppBar(
          title: const Text('Đăng nhập'),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Center(
                          child: Image.asset('assets/logo.png'),
                        ),
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                      // TextFormField(
                      //   decoration:
                      //       const InputDecoration(labelText: 'Password'),
                      //   obscureText: true,
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter your password';
                      //     }
                      //     return null;
                      //   },
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _password = value;
                      //     });
                      //   },
                      // ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // Xử lý logic đăng nhập ở đây
                            login();
                          }
                        },
                        child: Image.asset('assets/btn_login.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ));
  }
}
