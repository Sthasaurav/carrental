import 'package:firebase_2/constant.dart';
import 'package:firebase_2/view/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'edit_profile.dart';
import 'profile1.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('credential')
            .where('email', isEqualTo: user.email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          userData = snapshot.docs.first.data();
          userData!['photoUrl'] ??= '';
        } else {
          print('User document does not exist in Firestore');
        }

        setState(() {});
      } catch (error) {
        print('Error fetching user profile data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account Info",
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: CircleAvatar(
                      radius: 75,
                      backgroundImage: NetworkImage(
                        user?.photoURL ??
                            'data:image/png;base64,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',
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                    child: Text("Account Information",
                        style: TextStyle(fontSize: 24, color: Colors.black))),
              ),
              SizedBox(height: 20),
              buildProfileField("Name", userData?['name'] ?? 'N/A',
                  icon: Icons.person),
              buildProfileField("Email", userData?['email'] ?? 'N/A',
                  isEmail: true, icon: Icons.email),
              buildProfileField("Contact", userData?['phone'] ?? 'N/A',
                  icon: Icons.phone),
              buildProfileField("Address", userData?['address'] ?? 'N/A',
                  icon: Icons.location_on),
              SizedBox(height: 20), // Added SizedBox for spacing
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfilePage(user: user, userData: userData),
                      ),
                    ).then((_) {
                      fetchUserData();
                    });
                  },
                  child: Text('Edit Profile', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileField(String label, String value,
      {bool isEmail = false, IconData? icon}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 30,
              color: Color(0xFF090909), // Uber's brand color
            ),
            SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF090909), // Uber's brand color
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
