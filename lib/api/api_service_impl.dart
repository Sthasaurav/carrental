import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/api/api_response.dart';
import 'package:firebase_2/api/apiservice.dart';
import 'package:firebase_2/api/status_util.dart';
import 'package:firebase_2/model/credential.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiServiceImpl extends ApiService {
  bool isUserExist = false;

  @override
  Future<ApiResponse> saveStudent(Credential credential) async {
    //  print("name : ${credential.name}");
    // return ApiResponse(data:null);
    try {
      FirebaseFirestore.instance
          .collection("credential")
          .add(credential.toJson());
      return ApiResponse(networkStatus: NetworkStatus.sucess);
    } catch (e) {
      return ApiResponse(
          networkStatus: NetworkStatus.error, errormessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> getStudent() {
    // TODO: implement getStudent
    throw UnimplementedError();
  }
  
  @override
  Future<ApiResponse> loginData(Credential credential)async {
    try {
      await FirebaseFirestore.instance
          .collection("credential")
          .where("email", isEqualTo: credential.email)
          .where("password", isEqualTo: credential.password)
          .get() // value get garaxa 
          .then((value) { //value vanne variable ma email ra password store garxa
        if (value.docs.isNotEmpty) {
          isUserExist = true;
        } else {
          isUserExist = false;
        }
      });
    } catch (e) {
      return ApiResponse(
          networkStatus: NetworkStatus.error, errormessage: e.toString());
    }
    return ApiResponse(networkStatus: NetworkStatus.sucess, data: isUserExist);
  
  }

Future<void> saveUserProfileToFirebase(
    String userId, String displayName, String email, String photoURL) async {
  try {
    // Reference to the 'users' collection in Firestore
    final CollectionReference<Map<String, dynamic>> usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Add the user's details to the 'users' collection
    await usersCollection.doc(userId).set({
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      // Add other profile details as needed
    });
  } catch (error) {
    print('Error saving user profile to Firebase: $error');
  }
}
 @override
  Future<Map<String, dynamic>> getUserData(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      return userDoc.data()!;
    } else {
      // Handle the case where user data doesn't exist
      return {};
    }
  }
}



