import 'package:firebase_2/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/networkstatus.dart';
import '../customui/custombutton.dart';
import '../customui/customtextformfield.dart';
import '../helper/helper.dart';
import '../provider/signupprovider.dart';
import '../util/string_const.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SignUp",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: kprimaryColor,
      ),
      body: Consumer<SignUpProvider>(
        builder: (context, signUpProvider, child) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.3,
              //   decoration: BoxDecoration(
              //     color: kprimaryColor,
              //     borderRadius: BorderRadius.only(
              //         bottomLeft: Radius.circular(90),
              //         bottomRight: Radius.circular(90),
              //         topLeft: Radius.circular(90),
              //         topRight: Radius.circular(90)),
              //   ),
              //   child: Center(
              //     child: Image.asset(
              //       "assets/images/icon.png",
              //       height: MediaQuery.of(context).size.height * 0.2,
              //     ),
              //   ),
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: _buildForm(signUpProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(SignUpProvider signUpProvider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomForm(
            onChanged: (value) => signUpProvider.name = value,
            labelText: nameStr,
            // labelStyle: TextStyle(color: kprimaryColor),
            validator: (value) {
              if (value!.isEmpty) {
                return nameValidationStr;
              } else if (!RegExp(r'^[a-zA-Z]+(?:\s[a-zA-Z]+)?$')
                  .hasMatch(value)) {
                return 'Enter a valid name';
              }
              return null;
            },
            suffixIcon: const Icon(Icons.person, color: kprimaryColor),
          ),
          const SizedBox(height: 10),
          CustomForm(
            onChanged: (value) => signUpProvider.email = value,
            labelText: emailStr,
            // labelStyle: TextStyle(color: kprimaryColor),
            validator: (value) {
              if (value!.isEmpty) {
                return emailValidationStr;
              } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
            suffixIcon: const Icon(Icons.email, color: kprimaryColor),
          ),
          const SizedBox(height: 10),
          CustomForm(
            onChanged: (value) => signUpProvider.address = value,
            labelText: addressStr,
            // labelStyle: TextStyle(color: kprimaryColor),
            validator: (value) {
              if (value!.isEmpty) {
                return addressValidationStr;
              } else if (!RegExp(r'^[a-zA-Z0-9\s\,\#]+$').hasMatch(value)) {
                return 'Enter a valid address';
              }
              return null;
            },
            suffixIcon: const Icon(Icons.location_city, color: kprimaryColor),
          ),
          const SizedBox(height: 10),
          CustomForm(
            onChanged: (value) => signUpProvider.phone = value,
            labelText: contactStr,
            // labelStyle: TextStyle(color: kprimaryColor),
            validator: (value) {
              if (value!.isEmpty) {
                return contactValidationStr;
              } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                return 'Enter a valid 10 digit phone number';
              }
              return null;
            },
            suffixIcon: const Icon(Icons.phone, color: kprimaryColor),
          ),
          const SizedBox(height: 10),
          CustomForm(
            onChanged: (value) => signUpProvider.password = value,
            labelText: passwordStr,
            obscureText: signUpProvider.showPassword ? false : true,
            // labelStyle: TextStyle(color: kprimaryColor),
            validator: (value) {
              if (value!.isEmpty) {
                return passwordValidationStr;
              } else if (!RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                  .hasMatch(value)) {
                return 'Password must contain at least 8 characters, including uppercase, lowercase, numbers, and special characters.';
              }
              return null;
            },
            suffixIcon: signUpProvider.showPassword
                ? IconButton(
                    onPressed: () => signUpProvider.passwordVisibility(false),
                    icon: const Icon(Icons.visibility, color: kprimaryColor),
                  )
                : IconButton(
                    onPressed: () => signUpProvider.passwordVisibility(true),
                    icon:
                        const Icon(Icons.visibility_off, color: kprimaryColor),
                  ),
          ),
          const SizedBox(height: 10),
          Custombutton(
            primary: kprimaryColor,
            onPrimary: Colors.white,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await signUpProvider.saveCredentials();
                if (signUpProvider.signUpStatus == NetworkStatus.success) {
                  Helper.snackBarMessage("Registered Successfully", context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                } else if (signUpProvider.signUpStatus == NetworkStatus.error) {
                  Helper.snackBarMessage("Registration Failed", context);
                }
              }
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
