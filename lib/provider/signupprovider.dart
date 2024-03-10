import 'package:firebase_2/Model/credential.dart';
import 'package:firebase_2/api/apiresponse.dart';
import 'package:firebase_2/api/networkstatus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../api/apiserviceimpl.dart';

class SignUpProvider extends ChangeNotifier {
  String? name, address, phone, password, email;
  String? errorMessage;
  bool isUserExist = false;
  List<Credential> credentialList = [];
  NetworkStatus credentialDataStatus = NetworkStatus.idle;

  ApiService apiservice = ApiServiceImpl();
  NetworkStatus signUpStatus = NetworkStatus.idle;
  setsignUpStatus(NetworkStatus) {
    signUpStatus = NetworkStatus;
    notifyListeners();
  }

  NetworkStatus logInStatus = NetworkStatus.idle;
  setlogInStatus(NetworkStatus) {
    logInStatus = NetworkStatus;
    notifyListeners();
  }

  bool showPassword = false;

  passwordVisibility(bool value) {
    showPassword = value;
    notifyListeners();
  }

  saveCredentials() async {
    if (signUpStatus != NetworkStatus.loading) {
      setsignUpStatus(NetworkStatus.loading);
    }
    Credential credential = Credential(
        address: address,
        email: email,
        name: name,
        password: password,
        phone: phone);
    ApiResponse response = await apiservice.saveCredential(credential);
    if (response.networkStatus == NetworkStatus.success) {
      setsignUpStatus(NetworkStatus.success);
    } else if (response.networkStatus == NetworkStatus.error) {
      setsignUpStatus(NetworkStatus.error);
    }
  }

  loginCredentials() async {
    if (logInStatus != NetworkStatus.loading) {
      setlogInStatus(NetworkStatus.loading);
    }
    Credential credential = Credential(email: email, password: password);
    ApiResponse response = await apiservice.loginCredential(credential);
    if (response.networkStatus == NetworkStatus.success) {
      isUserExist = response.data;
      saveValueToSharedPreferences(isUserExist);
      setlogInStatus(NetworkStatus.success);
    } else if (response.networkStatus == NetworkStatus.error) {
      errorMessage = response.errorMessage;
      setlogInStatus(NetworkStatus.error);
    }
  }

  saveValueToSharedPreferences(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserExist', value);
  }

  setCredentialDataStatus(NetworkStatus) async {
    credentialDataStatus = NetworkStatus;
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

  // readValueFromSharedPreferences() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   isUserExist = prefs.getBool('isUserExist') ?? false;
  //   notifyListeners();
  // }
}
