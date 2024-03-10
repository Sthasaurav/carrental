import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/api/networkstatus.dart';

import '../Model/credential.dart';
import 'apiresponse.dart';
import 'apiservice.dart';

class ApiServiceImpl extends ApiService {
  bool isUserExist = false;
  @override
  Future<ApiResponse> saveCredential(Credential credential) async {
    //if(await Helper.CheckInternetConnection())
    // Print the data instead of making the API call
    // print('Data received in saveCredential:');
    // print('Name: ${credential.name}');
    // print('Address: ${credential.address}');
    // print('Phone: ${credential.phone}');
    // print('Password: ${credential.password}');
    // print('Email: ${credential.email}');

    // You can return a dummy ApiResponse or any response you want for testing

    try {
      await FirebaseFirestore.instance
          .collection("credential")
          .add(credential.toJson());

      return ApiResponse(networkStatus: NetworkStatus.success);
    } catch (e) {
      return ApiResponse(
          networkStatus: NetworkStatus.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> loginCredential(Credential credential) async {
    try {
      await FirebaseFirestore.instance
          .collection("credential")
          .where("email", isEqualTo: credential.email)
          .where("password", isEqualTo: credential.password)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          isUserExist = true;
        } else {
          isUserExist = false;
        }
      });
    } catch (e) {
      return ApiResponse(networkStatus: NetworkStatus.error, data: isUserExist);
    }
    return ApiResponse(networkStatus: NetworkStatus.success, data: isUserExist);
  }

  @override
  Future<ApiResponse> getCredentialDataFromFirebase() async {
    List<Credential> credentialList = [];
    try {
      var response =
          await FirebaseFirestore.instance.collection("credential").get();
      final credential = response.docs;
      if (credential.isNotEmpty) {
        for (var user in credential) {
          Credential credential = Credential.fromJson(user.data());
          credential.id = user.id;
          credentialList.add(credential);
        }
        return ApiResponse(
            networkStatus: NetworkStatus.success, data: credentialList);
      } else {
        return ApiResponse(
            networkStatus: NetworkStatus.success, data: credentialList);
      }
    } catch (e) {
      return ApiResponse(
          networkStatus: NetworkStatus.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> deleteCredentialDataFromFirebase(String id) async {
    //String userId = await findUserByPhoneNumber(phone);
    try {
      await FirebaseFirestore.instance
          .collection("credential")
          .doc(id)
          .delete();
      return ApiResponse(networkStatus: NetworkStatus.success, data: true);
    } catch (e) {
      return ApiResponse(networkStatus: NetworkStatus.error, data: false);
    }
  }

  Future<String> findUserByPhoneNumber(String phone) async {
    var response = await FirebaseFirestore.instance
        .collection("credential")
        .where("phone", isEqualTo: phone)
        .get();
    if (response.docs.isNotEmpty) {
      var user = response.docs.first;
      return user.id;
    }
    return "";
  }

  @override
  Future<ApiResponse> updateCredentialDataFromFirebase(
      Credential credential) async {
    // String userId = await findUserByPhoneNumber(credential.id);
    try {
      await FirebaseFirestore.instance
          .collection("credential")
          .doc(credential.id)
          .update(credential.toJson());
      return ApiResponse(networkStatus: NetworkStatus.success, data: true);
    } catch (e) {
      return ApiResponse(networkStatus: NetworkStatus.error, data: false);
    }
  }
}
