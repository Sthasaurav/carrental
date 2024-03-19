import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  CustomForm({
    super.key,
    this.labelText,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.obscureText = false,
  });

  String? labelText;
  String? Function(String?)? validator;
  Widget? suffixIcon;
  Widget? prefixIcon;
  Function(String)? onChanged;
  bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        labelText: labelText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
