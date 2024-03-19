import 'package:firebase_2/constant.dart';
import 'package:firebase_2/screen/changepassword_screen.dart';
import 'package:firebase_2/screen/profile/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/view/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Urban Drive"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: kprimaryColor,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user?.photoURL ?? ""),
                  ),
                  SizedBox(height: 16),
                  FutureBuilder<String>(
                    future: _fetchUserName(user),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        print('Error: ${snapshot.error}');
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          snapshot.data ?? 'Name not found',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Manage Profile"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.lock),
                    title: Text("Change Password"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.circleInfo),
                    title: Text("About Us"),
                    onTap: () {
                      // Navigate to about us page
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Logout"),
                            content: Text("Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                },
                                child: Text("Yes"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _fetchUserName(User? user) async {
    if (user != null) {
      if (user.providerData.any((info) => info.providerId == 'firebase')) {
        // Fetch user name from Firestore collection 'credential'
        var querySnapshot = await FirebaseFirestore.instance
            .collection('credential')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first['name'];
        }
      } else if (user.providerData
          .any((info) => info.providerId == 'google.com')) {
        // For Google sign-in, return user's display name
        return user.displayName ?? 'Name not found';
      }
    }
    // Return 'Name not found' if user is not signed in or any other cases
    return 'Name not found';
  }

  Future<ImageProvider<Object>?> _getUserPhoto(User? user) async {
    if (user != null) {
      if (user.providerData.any((info) => info.providerId == 'firebase')) {
        // For Firebase sign-in, use the photoURL if available
        if (user.photoURL != null) {
          return NetworkImage(user.photoURL!);
        }
      } else if (user.providerData
          .any((info) => info.providerId == 'google.com')) {
        // For Google sign-in, fetch the user's photo from GoogleSignIn
        final googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signInSilently();
        if (googleUser != null && googleUser.photoUrl != null) {
          return NetworkImage(googleUser.photoUrl!);
        }
      }
    }
    // Return null if photo is not available or user is not signed in
    return null;
  }
}
