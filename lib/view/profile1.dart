import 'package:firebase_2/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/view/login.dart';
import 'package:firebase_2/view/profile.dart';
import 'package:firebase_2/view/aboutus.dart';
import 'package:firebase_2/view/changePassword.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileUd extends StatefulWidget {
  const ProfileUd({Key? key}) : super(key: key);

  @override
  _ProfileUdState createState() => _ProfileUdState();
}

class _ProfileUdState extends State<ProfileUd> {
  late User? user;
  late String userName;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userName = "Loading...";
    if (user != null) {
      _fetchUserName(user!).then((name) {
        setState(() {
          userName = name;
        });
      }).catchError((error) {
        print("Error fetching user name: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kscaffoldColor,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (user != null &&
                user!.photoURL != null &&
                user!.photoURL!.isNotEmpty)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user!.photoURL!),
              ),
            SizedBox(height: 16),
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person, color: kprimaryColor),
              title: Text(
                "Manage Profile",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                _fetchUserName(user!).then((name) {
                  setState(() {
                    userName = name;
                  });
                }).catchError((error) {
                  print("Error fetching user name: $error");
                });
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(FontAwesomeIcons.lock, color: kprimaryColor),
              title: Text(
                "Change Password",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(FontAwesomeIcons.circleInfo, color: kprimaryColor),
              title: Text(
                "About Us",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: kprimaryColor),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 18),
              ),
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
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                              (route) =>
                                  false, // Remove all routes from the stack
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
    );
  }

  Future<String> _fetchUserName(User user) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('credential')
        .where('email', isEqualTo: user.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['name'];
    }
    return 'Name not found';
  }
}
