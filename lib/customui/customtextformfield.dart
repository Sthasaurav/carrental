import 'package:firebase_2/constant.dart';
import 'package:flutter/material.dart';
class CustomForm extends StatelessWidget {
  const CustomForm({
    Key? key,
    this.labelText,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.obscureText = false,
    this.controller, // Add controller parameter here
  }) : super(key: key);

  final String? labelText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final bool obscureText;
  final TextEditingController? controller; // Define controller here

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Use controller here
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: kprimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kprimaryColor, width: 2),
        ),
      ),
    );
  }
}
