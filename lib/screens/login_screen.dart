import 'package:flutter/material.dart';
import 'package:notist/screens/home_screen.dart';
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

  final auth = Auth();

  bool _isLoading = false;

  Map<String, String> _authData = {
    'email': '',
    'displayName': '',
    'password': '',
  };

  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _displayNameKey = ValueKey('displayName');
  final _passwordKey = ValueKey('password');

  final String _sloganText = 'Note down your ideas so you don\'t forget them';

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authType == AuthType.Login) {
      try {
        await auth.login(_authData['email']!, _authData['password']!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => HomeScreen()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      try {
        await auth.signUp(
          _authData['email']!,
          _authData['password']!,
          _authData['displayName']!,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => HomeScreen()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
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
      resizeToAvoidBottomInset: false,
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
                  child: Form(
                    key: _formKey,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                _authData['email'] = value!.trim();
                              },
                            ),
                            if (_authType == AuthType.Signup)
                              SizedBox(height: 4.0),
                            if (_authType == AuthType.Signup)
                              TextFormField(
                                key: _displayNameKey,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_outlined),
                                  hintText: 'Display Name',
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  border: OutlineInputBorder(),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'enter a display name';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _authData['displayName'] = value!.trim();
                                },
                              ),
                            SizedBox(height: 4.0),
                            TextFormField(
                                key: _passwordKey,
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                  _authData['password'] = value!.trim();
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                  _isLoading
                                      ? CircularProgressIndicator()
                                      : Icon(
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
                  onPressed: () async {
                    try {
                      await signInWithGoogle(context);
                    } catch (e) {
                      print(e);
                    }
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
