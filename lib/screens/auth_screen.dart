import 'package:flutter/material.dart';
import 'package:scholar_ecommerce_app/models/exceptions.dart';
import 'package:scholar_ecommerce_app/providers/auth.dart';
import 'package:scholar_ecommerce_app/screens/admin_panel.dart';
import 'package:scholar_ecommerce_app/screens/home_page.dart';
import 'package:scholar_ecommerce_app/screens/product_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode { Signup, Login }
enum AdminMode { Admin, User }

class AuthScreen extends StatelessWidget {
  static const routename = '/authScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade700,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Image.asset('assets/images/icons/buyicon.png'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    'Buy It',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico'),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            AuthCard(),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  final _auth = Auth();
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  AdminMode _adminMode = AdminMode.User;
  String adminPassword = 'admin1234';
  Map<String, String> _authData = {'email': '', 'password': ''};
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool keepMeLoggedIn = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An Error Occurred'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  // Submit Method
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Signup) {
        await widget._auth.signUp(
            _authData['email'].toString(), _authData['password'].toString());
        Navigator.of(context).pushNamed(ProductScreen.routeName);
      } else {
        await widget._auth.signIn(
            _authData['email'].toString(), _authData['password'].toString());
        if (_authData['password'] == adminPassword) {
          Navigator.of(context).pushNamed(AdminPanel.routeName);
        } else {
          Navigator.of(context).pushNamed(HomePage.routeName);
        }
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAdminMode() {
    if (_adminMode == AdminMode.User) {
      setState(() {
        _adminMode = AdminMode.Admin;
      });
    } else {
      setState(() {
        _adminMode = AdminMode.User;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    print(deviceSize.width);
    return Container(
      height: _authMode == AuthMode.Signup ? 500 : 300,
      constraints: BoxConstraints(
        maxHeight: _authMode == AuthMode.Signup ? 500 : 300,
      ),
      width: deviceSize.width * 0.95,
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white38,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                  labelText: "E-Mail",
                  hintText: 'Enter Your Email',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid Email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.blue,
                        value: keepMeLoggedIn,
                        onChanged: (value) {
                          setState(() {
                            keepMeLoggedIn = value!;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Remember Me ',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                  filled: true,
                  fillColor: Colors.white38,
                  labelText: 'Password',
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              if (_authMode == AuthMode.Signup)
                Column(children: [
                  SizedBox(height: 15),
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white38,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          borderSide: BorderSide(color: Colors.white38)),
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'password doesn\'t match';
                            }
                            return null;
                          }
                        : null,
                  ),
                ]),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  onPressed: () {
                    keepUserLoggedIn();
                    _submit();
                  },
                  child: Container(
                      width: deviceSize.width * .30,
                      child: Center(
                        child: Text(
                            _authMode == AuthMode.Login ? 'Login' : 'SignUp'),
                      )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  color: Colors.black,
                  textColor: Colors.white,
                ),
              FlatButton(
                onPressed: _switchAuthMode,
                child: MediaQuery.of(context).size.width < 400
                    ? Column(
                        children: [
                          Text(
                            '${_authMode == AuthMode.Signup ? 'already have an account?' : 'Don\'t have an account?'}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            '${_authMode == AuthMode.Signup ? 'already have an account?' : 'Don\'t have an account?'}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                              '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                        ],
                      ),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void keepUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('keepMeLoggedIn', keepMeLoggedIn);
  }
}
