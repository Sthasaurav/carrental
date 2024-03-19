import 'package:firebase_2/view/otpcode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Opt extends StatefulWidget {
  Opt({super.key});

  @override
  State<Opt> createState() => _OptState();
}

class _OptState extends State<Opt> {
  String? phoneCode = "+977";

  String? phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TextFormField(
          onChanged: (value) {
            phoneNumber = value;
          },
          decoration: InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              )),
        ),
        SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              sendVerificationCode(context);
            },
            child: Text("Submit"))
      ],
    ));
  }

  sendVerificationCode(context) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneCode! + phoneNumber!,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OtpCode()));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {}
  }
}
