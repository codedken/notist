import 'dart:async';

import 'package:flutter/material.dart';
import '../controllers/google_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  int i = 0;

  final List<String> _sloganText = [
    'Pen down your ideas to never forget them',
    'Free your head from carrying a lot',
    'Create and modify your notes with ease',
  ];
  AnimationController _animationController;
  Animation<double> _opacityTransition;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    _opacityTransition = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInSine,
      ),
    );

    awaitAnim();
  }

  void awaitAnim() async {
    for (int j = 1; j < _sloganText.length; j++) {
      await _animateText(j);
      if (j == _sloganText.length - 1) {
        j = -1;
      }
    }
  }

  Future<void> _animateText(int j) async {
    await Future.delayed(Duration(milliseconds: 500), () {
      _animationController.forward();
    });
    await Future.delayed(Duration(seconds: 6), () async {
      await _awaitAnimDir();
    });

    setState(() {
      i = j;
    });
  }

  Future<void> _awaitAnimDir() {
    return _animationController.reverse();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cover1.png'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              child: FadeTransition(
                opacity: _opacityTransition,
                child: Text(
                  _sloganText[i],
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'lato',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: ElevatedButton(
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
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
