import 'package:firebase_2/api/api_service_impl.dart';
import 'package:firebase_2/api/apiservice.dart';
import 'package:firebase_2/constant.dart';
// import 'package:firebase_2/api/status_util.dart';
import 'package:firebase_2/custom_ui/customelevatedbutton.dart';
import 'package:firebase_2/custom_ui/customform.dart';
import 'package:firebase_2/helper/helper.dart';
import 'package:firebase_2/provider/passwordvisibility.dart';
import 'package:firebase_2/screen/main_screen.dart';
import 'package:firebase_2/util/string_const.dart';
import 'package:firebase_2/view/forgetpassword.dart';
// import 'package:firebase_2/view/navbar.dart';
// import 'package:firebase_2;

import 'package:firebase_2/view/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../api/auth_service.dart';

class LoginUi extends StatefulWidget {
  LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  ApiService apiService = ApiServiceImpl();
  AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<Passwordvisibility>(
      builder: (context, passwordVisibility, child) => Stack(children: [
        Container(
          color: kcontentColor,
        ),
        SingleChildScrollView(child: loginUi(context, passwordVisibility)),
      ]),
    ));
  }

  Widget loginUi(BuildContext context, Passwordvisibility passwordVisibility) {
    //function
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height *
              0.2, // Adjust the height of the logo container
          color: Colors.transparent,
          // child: Center(
          //   // Center the image
          //   child: Image(
          //     image: AssetImage("assets/logo_project.png"),
          //     height: MediaQuery.of(context).size.height *
          //         0.2, // Adjust the height of the image
          //   ),
          // ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(40), topLeft: Radius.circular(40)),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loginnowStr,
                        style: TextStyle(
                            color: kprimaryColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text(
                          userStr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        ClipRRect(
                          child: SizedBox(
                            height: 31,
                            child: TextButton(
                              onPressed: () {
                                //print("button pressed");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentForm()));
                              },
                              child: Text(
                                accountStr,
                                style: TextStyle(color: kprimaryColor),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    CustomForm(
                      hintText: EmailaddressStr,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return emailValidationStr;
                        } else if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        passwordVisibility.email = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomForm(
                      hintText: passwordStr,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: kprimaryColor,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return passwordValidationStr;
                        } else if (!passwordRegex.hasMatch(value)) {
                          return 'Must have 8 char(include uppercase,lowercase & number)';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        passwordVisibility.password = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 65,
                      child: CustomElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            User? user =
                                await _authService.signInWithEmailAndPassword(
                              passwordVisibility.email!,
                              passwordVisibility.password!,
                            );

                            if (user != null) {
                              Helper.snackBarMessage(
                                  "Successfully Logged in", context);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              Helper.snackBarMessage(
                                  "Invalid Credential!!!", context);
                            }
                          }
                        },
                        child: Text("Log In"),
                        primary: kprimaryColor,
                        onprimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              //  print("forget password button is pressed");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgetPasswordPage(),
                                  ));
                            },
                            child: Text(
                              ForgetpassStr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            )),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              //  print("Signup password button is pressed");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentForm(),
                                  ));
                            },
                            child: Text(SignupStr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline)))
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              googleLogin(context);
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.google),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text("Login with Google")
                                ],
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height *
              0.2, // Adjust the height of the logo container
          color: Colors.transparent,
        ),
      ],
    );
  }

  googleLogin(BuildContext context) async {
    String? token;

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

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
        // var token= await user.getIdToken();
        // print(token);
        //ya mathi ko 2 line ra tal ko same ho
        await user.getIdToken().then(
          (value) {
            //aaba value ma Idtoken basxa
            token = value;
            print(token);
          },
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
      // if(token!=null){//not equal
      //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Navbar()),
      //   (route) => false);
      // }
    }
  }
}
