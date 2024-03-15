import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
   void Function()? onPressed;
  String? text;
Color? primary;
Color? onprimary;
Widget? child;
OutlinedBorder? shape;

 CustomElevatedButton({super.key, this.shape,required this.onPressed,this.text,this.primary,this.onprimary,this.child});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(

     style: ElevatedButton.styleFrom( primary: primary,onPrimary: onprimary,shape: shape),
      
      onPressed: onPressed, child: child );
      
      
  }
}