import 'dart:io';

import 'package:firebase_2/api/api_response.dart';
import 'package:firebase_2/api/api_service_impl.dart';
import 'package:firebase_2/api/apiservice.dart';
import 'package:firebase_2/api/status_util.dart';
import 'package:firebase_2/model/credential.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Passwordvisibility extends ChangeNotifier {
  bool showPassword = false;

  String? name, address, email, contact, password;
  ApiService apiservice = ApiServiceImpl();

  String? errormessage;
  bool isUserExist = false;
  NetworkStatus loginStatus = NetworkStatus.idel;

  Visibility(bool value) {
    showPassword == value;
    notifyListeners();
  }

  double? _latitude;
  double? _longitude;

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  setCoordinates(double? latitude, double? longitude) {
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
  }

  NetworkStatus saveStudentStatus = NetworkStatus.idel;
//NetworkStatus getStudentDetailsStatus=NetworkStatus.idel;

  setSaveStudentNetworkStatus(NetworkStatus status) {
    saveStudentStatus = status;
    notifyListeners();
  }

  setLoginStatus(NetworkStatus networkStatus) {
    loginStatus = networkStatus;
    notifyListeners();
  }

//setStudentDetailsNetworkStatus(NetworkStatus status){
//  getStudentDetailsStatus=status;
  // notifyListeners();
//}
  Future<void> saveStudentData() async {
    if (saveStudentStatus != NetworkStatus.loading) {
      saveStudentStatus = NetworkStatus.loading;
    }
    Credential credential = Credential(
        name: name, address: address, email: email, password: password);
    ApiResponse response = await apiservice.saveStudent(credential);
    if (response.networkStatus == NetworkStatus.sucess) {
      setSaveStudentNetworkStatus(NetworkStatus.sucess);
    } else if (response.networkStatus == NetworkStatus.error) {
      errormessage = response.errormessage;
      setSaveStudentNetworkStatus(NetworkStatus.error);
    }
  }

  Future<void> loginDataInFirebase() async {
    if (loginStatus != NetworkStatus.loading) {
      setLoginStatus(NetworkStatus.loading);
    }
    Credential credential = Credential(email: email, password: password);
    ApiResponse response = await apiservice.loginData(credential);
    if (response.networkStatus == NetworkStatus.sucess) {
      isUserExist = response.data;
      setLoginStatus(NetworkStatus.sucess);
      saveValueToSharedPreferences(
          isUserExist); //isUserExit ko value yo case ma true aauxa
    } else if (response.networkStatus == NetworkStatus.error) {
      errormessage = response.errormessage;
      setLoginStatus(NetworkStatus.error);
    }
  } // Writing data

  saveValueToSharedPreferences(bool value) async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance(); //prefs just variable matra ho
    await prefs.setBool('isUserExist',
        value); //repeat vaneko key ya sidhei value ko thauma isUserExist pathauda ni hunxa
  }

  bool loader = false;
  XFile? image;
  File? file;
  selectedimage(value) {
    image = value;
    notifyListeners();
  }

  selectedfile(value) {
    file = value;
    notifyListeners();
  }

  imagepickloader(bool value) {
    loader == value;
    notifyListeners();
  }
}
