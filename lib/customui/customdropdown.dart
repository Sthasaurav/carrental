import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  Function(String?)? onChanged;
  InputDecoration? decoration;
  Widget? icon;
  String? value;
  String? Function(String?)? validator;
  CustomDropDown(
      {super.key,
      required this.itemList,
      this.onChanged,
      this.decoration,
      this.icon,
      this.validator,
      this.value});
  List<String> itemList;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: itemList
          .map((e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: onChanged,
      decoration: decoration,
      icon: icon,
      validator: validator,
      value: value,
    );
  }
}
