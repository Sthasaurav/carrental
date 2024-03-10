import 'package:firebase_2/customui/custombutton.dart';
import 'package:firebase_2/customui/customtextformfield.dart';
import 'package:firebase_2/provider/signupprovider.dart';
import 'package:firebase_2/screen/home_screen.dart';
import 'package:firebase_2/util/string_const.dart';
// import 'package:firebase_2/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/networkstatus.dart';
import '../helper/helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Consumer<SignUpProvider>(
          builder: (context, signUpProvider1, child) => Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                CustomForm(
                  prefixIcon: Icon(Icons.email),
                  onChanged: (value) {
                    signUpProvider1.email = value;
                  },
                  labelText: emailStr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return emailValidationStr;
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomForm(
                    prefixIcon: Icon(Icons.lock),
                    onChanged: (value) {
                      signUpProvider1.password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return passwordValidationStr;
                      } else {
                        return null;
                      }
                    },
                    labelText: passwordStr,
                    obscureText: signUpProvider1.showPassword ? false : true,
                    suffixIcon: signUpProvider1.showPassword
                        ? IconButton(
                            onPressed: () {
                              signUpProvider1.passwordVisibility(false);
                            },
                            icon: const Icon(Icons.visibility))
                        : IconButton(
                            onPressed: () {
                              signUpProvider1.passwordVisibility(true);
                            },
                            icon: const Icon(Icons.visibility_off))),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 100,
                  child: Custombutton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await signUpProvider1.loginCredentials();
                        if (signUpProvider1.logInStatus ==
                                NetworkStatus.success &&
                            signUpProvider1.isUserExist) {
                          Helper.snackBarMessage(
                              "Successfully Logged in", context);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (Route<dynamic> route) => false);
                        } else if (signUpProvider1.logInStatus ==
                                NetworkStatus.success &&
                            !signUpProvider1.isUserExist) {
                          Helper.snackBarMessage("Invalid Credential", context);
                        } else if (signUpProvider1.logInStatus ==
                            NetworkStatus.error) {
                          Helper.snackBarMessage("Failed to Save", context);
                        }
                      }
                    },
                    child: Text("Login"),
                    onPrimary: Colors.white,
                    primary: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
