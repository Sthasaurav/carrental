import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  Custombutton(
      {super.key, this.onPressed, this.child, this.primary, this.onPrimary});
  Function()? onPressed;
  Widget? child;
  Color? primary;
  Color? onPrimary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: child,
        style:
            ElevatedButton.styleFrom(primary: primary, onPrimary: onPrimary));
  }
}
