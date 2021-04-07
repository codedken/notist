import 'package:flutter/material.dart';

class ElevatedButton1 extends StatelessWidget {
  final Function onPressed;
  final Widget child;

  ElevatedButton1({required this.child, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      child: child,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
        ),
      ),
    );
  }
}
