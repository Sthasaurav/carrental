import 'package:firebase_2/api/auth_service.dart';
import 'package:firebase_2/constant.dart';
import 'package:firebase_2/customui/custombutton.dart';
import 'package:firebase_2/customui/customtextformfield.dart';
import 'package:firebase_2/provider/signupprovider.dart';
import 'package:firebase_2/screen/main_screen.dart';
import 'package:firebase_2/screen/profile/profile_screen.dart';
import 'package:firebase_2/util/string_const.dart';
import 'package:firebase_2/view/forgotpassword.dart';
import 'package:firebase_2/view/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_2/screen/admin/admin_screen.dart';

import 'package:provider/provider.dart';
import '../api/networkstatus.dart';
import '../helper/helper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Consumer<SignUpProvider>(
          builder: (context, signUpProvider, child) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              text: 'Hi Welcome back, ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "you've been missed",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kprimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 45),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomForm(
                          prefixIcon: Icon(
                            Icons.email,
                            color: kprimaryColor,
                          ),
                          onChanged: (value) {
                            signUpProvider.email = value;
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
                        SizedBox(height: 20),
                        CustomForm(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: kprimaryColor,
                          ),
                          onChanged: (value) {
                            signUpProvider.password = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return passwordValidationStr;
                            } else {
                              return null;
                            }
                          },
                          labelText: passwordStr,
                          obscureText:
                              signUpProvider.showPassword ? false : true,
                          suffixIcon: signUpProvider.showPassword
                              ? IconButton(
                                  onPressed: () {
                                    signUpProvider.passwordVisibility(false);
                                  },
                                  icon: const Icon(Icons.visibility))
                              : IconButton(
                                  onPressed: () {
                                    signUpProvider.passwordVisibility(true);
                                  },
                                  icon: const Icon(Icons.visibility_off)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: kprimaryColor),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: 100,
                    child: Custombutton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await signUpProvider.loginCredentials();
                          if (signUpProvider.logInStatus ==
                                  NetworkStatus.success &&
                              signUpProvider.isUserExist) {
                            // Check if email and password match the admin credentials
                            if (signUpProvider.email == 'admin8989@gmail.com' &&
                                signUpProvider.password == '@dmin5835J') {
                              // Redirect to another page (ProfileScreen)
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              // Redirect to MainScreen for non-admin users
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            }
                          } else if (signUpProvider.logInStatus ==
                                  NetworkStatus.success &&
                              !signUpProvider.isUserExist) {
                            Helper.snackBarMessage(
                                "Invalid Credential", context);
                          } else if (signUpProvider.logInStatus ==
                              NetworkStatus.error) {
                            Helper.snackBarMessage("Failed to Save", context);
                          }
                        }
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPrimary: Colors.white,
                      primary: kprimaryColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  // SizedBox(
                  //   height: 50,
                  //   width: MediaQuery.of(context).size.width * 0.9,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       primary: kprimaryColor,
                  //       onPrimary: Colors.white,
                  //     ),
                  //     onPressed: () {
                  //       googleLogin();
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(FontAwesomeIcons.google),
                  //         SizedBox(
                  //           width: 10,
                  //         ),
                  //         Text(
                  //           "Login with google",
                  //           style: TextStyle(
                  //             fontSize: 18,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ));
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: 'New to Urban Drive? '),
                          TextSpan(
                            text: 'Register Here',
                            style: TextStyle(color: kprimaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  googleLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Sign out in case a user is already signed in with a Google account
    await googleSignIn.signOut();

    // Prompt the user to select a Google account
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;

        print(user!.phoneNumber);

        //to get token
        // var token =await user.getIdToken();
        // print(token);
        //or

        await user.getIdToken().then((value) {
          String? token = value;
          print(token);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
      if (user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ));
      }
    }
  }
}
