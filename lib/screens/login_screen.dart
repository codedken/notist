import 'package:flutter/material.dart';
import '../controllers/google_auth.dart';

import '../controllers/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum AuthType {
  Login,
  Signup,
}

class _LoginScreenState extends State<LoginScreen> {
  int i = 0;
  AuthType _authType = AuthType.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String _sloganText = 'Note down your ideas so you don\'t forget them';

  Auth _auth = Auth();

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    if (_authType == AuthType.Login) {
      await _auth.login(_authData['email']!, _authData['password']!);
    } else {
      await _auth.signUp(_authData['email']!, _authData['password']!);
    }
  }

  void _toggleAuth() {
    if (_authType == AuthType.Login) {
      _authType = AuthType.Signup;
    } else {
      _authType = AuthType.Login;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/images/notistlogo.png',
            height: 70.0,
          ),
        ),
        title: Text(
          'Notist',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.0,
            fontFamily: 'lato',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _toggleAuth();
              });
            },
            child: Text(
              _authType == AuthType.Login ? 'Create an account' : 'Login Here',
              style: TextStyle(
                color: Colors.grey[300],
                fontFamily: 'lato',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: Text(
                    _sloganText,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.grey[200],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'lato',
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: _authType == AuthType.Login ? 240.0 : 320.0,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: 'Email Address',
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'enter an email address';
                                }
                                if (!value.contains("@")) {
                                  return 'email is not valid';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['email'] = value!;
                              },
                            ),
                            SizedBox(height: 4.0),
                            TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outlined),
                                  hintText: 'Password',
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'password must be 6 characters or above';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _authData['password'] = value!;
                                }),
                            if (_authType == AuthType.Signup)
                              SizedBox(height: 4.0),
                            if (_authType == AuthType.Signup)
                              TextFormField(
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.check_circle_outline_outlined,
                                  ),
                                  hintText: 'Confirm Password',
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'confirm password';
                                  }
                                  if (value != _passwordController.value.text) {
                                    return 'password does not match';
                                  }
                                  return null;
                                },
                              ),
                            SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                _saveForm();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _authType == AuthType.Login
                                        ? 'LOGIN'
                                        : 'SUBMIT',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'lato',
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(
                                    Icons.login_outlined,
                                    size: 32.0,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.grey[700],
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    signInWithGoogle(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'lato',
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Image.asset(
                        'assets/images/googlelogo.png',
                        width: 30.0,
                        height: 30.0,
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.grey[700],
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
