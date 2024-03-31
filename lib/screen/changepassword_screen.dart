import 'package:firebase_2/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_2/customui/customtextformfield.dart';
import 'package:firebase_2/provider/signupprovider.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Consumer<SignUpProvider>(
          builder: (context, signUpProvider, child) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomForm(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Current Password",
                    onChanged: (value) {
                      signUpProvider.password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your current password.";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  CustomForm(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "New Password",
                    onChanged: (value) {
                      signUpProvider.newPassword = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a new password.";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  CustomForm(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Re-type Password",
                    onChanged: (value) {
                      signUpProvider.retypePassword = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please re-type your new password.";
                      } else if (value != signUpProvider.newPassword) {
                        return "Passwords do not match.";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          User? user = _auth.currentUser;
                          if (user != null) {
                            AuthCredential credential =
                                EmailAuthProvider.credential(
                              email: user.email!,
                              password: signUpProvider.password!,
                            );
                            await user.reauthenticateWithCredential(credential);
                            await user
                                .updatePassword(signUpProvider.newPassword!);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Password changed successfully.")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("User not found.")),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'requires-recent-login') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Please re-login to change password.")),
                            );
                          } else if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "The new password is too weak. Please choose a stronger one.")),
                            );
                          } else if (e.code == 'invalid-credential') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Invalid credentials. Please verify your current password.")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Failed to change password. Please try again later.")),
                            );
                          }
                        } catch (error) {
                          print("Error changing password: $error");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "An unexpected error occurred. Please try again later.")),
                          );
                        }
                      }
                    },
                    child: Text('Change Password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
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
}
