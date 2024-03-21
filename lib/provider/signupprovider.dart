import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_2/Model/credential.dart';
import 'package:firebase_2/api/apiresponse.dart';
import 'package:firebase_2/api/networkstatus.dart';
import 'package:firebase_2/api/apiservice.dart';
import 'package:firebase_2/api/apiserviceimpl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  String? name, address, phone, email;
  String? password, newPassword, retypePassword;
  String? errorMessage;
  bool isUserExist = false;
  List<Credential> credentialList = [];
  NetworkStatus credentialDataStatus = NetworkStatus.idle;

  ApiService apiservice = ApiServiceImpl();
  NetworkStatus signUpStatus = NetworkStatus.idle;
  NetworkStatus logInStatus = NetworkStatus.idle;
  bool showPassword = false;

  passwordVisibility(bool value) {
    showPassword = value;
    notifyListeners();
  }

  setsignUpStatus(NetworkStatus status) {
    signUpStatus = status;
    notifyListeners();
  }

  setlogInStatus(NetworkStatus status) {
    logInStatus = status;
    notifyListeners();
  }

  saveCredentials() async {
    if (signUpStatus != NetworkStatus.loading) {
      setsignUpStatus(NetworkStatus.loading);
    }

    if (newPassword != retypePassword) {
      errorMessage = "Passwords do not match.";
      setsignUpStatus(NetworkStatus.error);
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      // If user creation successful, proceed to save other data
      Credential credential = Credential(
        address: address,
        email: email,
        name: name,
        password: newPassword, // or use password if newPassword is null
        phone: phone,
      );
      ApiResponse response = await apiservice.saveCredential(credential);
      if (response.networkStatus == NetworkStatus.success) {
        setsignUpStatus(NetworkStatus.success);
      } else if (response.networkStatus == NetworkStatus.error) {
        setsignUpStatus(NetworkStatus.error);
      }
    } catch (e) {
      errorMessage = e.toString();
      setsignUpStatus(NetworkStatus.error);
    }
  }

  loginCredentials() async {
    if (logInStatus != NetworkStatus.loading) {
      setlogInStatus(NetworkStatus.loading);
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      // If sign-in successful, set isUserExist to true
      isUserExist = true;
      saveValueToSharedPreferences(isUserExist);
      setlogInStatus(NetworkStatus.success);
    } catch (e) {
      errorMessage = e.toString();
      setlogInStatus(NetworkStatus.error);
    }
  }

  saveValueToSharedPreferences(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserExist', value);
  }

  setCredentialDataStatus(NetworkStatus status) async {
    credentialDataStatus = status;
    notifyListeners();
  }

  Future<void> getCredentialDataFromFirebase() async {
    if (credentialDataStatus != NetworkStatus.loading) {
      setCredentialDataStatus(NetworkStatus.loading);
    }
    ApiResponse apiResponse = await apiservice.getCredentialDataFromFirebase();
    if (apiResponse.networkStatus == NetworkStatus.success) {
      credentialList = apiResponse.data;
      setCredentialDataStatus(NetworkStatus.success);
    } else if (apiResponse.networkStatus == NetworkStatus.error) {
      errorMessage = apiResponse.errorMessage;
      setCredentialDataStatus(NetworkStatus.error);
    }
  }
}