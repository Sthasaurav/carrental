import 'package:firebase_2/constant.dart';
import 'package:firebase_2/view/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSaurav extends StatefulWidget {
  @override
  _ProfileSauravState createState() => _ProfileSauravState();
}

class _ProfileSauravState extends State<ProfileSaurav> {
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
          " ",
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null && userData != null) SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Text(
                    "Account Information",
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
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
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showLogoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    backgroundColor: kprimaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: 45, vertical: 20), // Adjust the padding
                  ),
                  child: Text('Logout'),
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

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
