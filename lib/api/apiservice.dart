import 'package:firebase_2/api/apiresponse.dart';

import '../Model/credential.dart';

abstract class ApiService {
  Future<ApiResponse> saveCredential(Credential credential);
  Future<ApiResponse> loginCredential(Credential credential);
  Future<ApiResponse> getCredentialDataFromFirebase();
  Future<ApiResponse> deleteCredentialDataFromFirebase(String id);
  Future<ApiResponse> updateCredentialDataFromFirebase(Credential credential);
}
