import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reference to the Firestore collection
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during sign in: $e");
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String address,
    String contact,
  ) async {
    try {
      // Create a new user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user details to Firestore
      await saveUserDetailsToFirestore(
          userCredential.user!.uid, name, address, contact, email);

      return userCredential.user;
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }

  // Save user details to Firestore
  Future<void> saveUserDetailsToFirestore(
    String userId,
    String name,
    String address,
    String contact,
    String email,
  ) async {
    try {
      Map<String, dynamic> userData = {
        'name': name,
        'address': address,
        'contact': contact,
        'email': email,
      };

      await _usersCollection.doc(userId).set(userData);
    } catch (e) {
      print("Error saving user details to Firestore: $e");
    }
  }
}
