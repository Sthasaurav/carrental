import 'package:firebase_2/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/view/login.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _phoneNumber;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _name = widget.user.displayName;
    _email = widget.user.email;
    _phoneNumber = widget.user.phoneNumber;
  }

  Future<void> _updateProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateProfile(
          displayName: _name,
        );

        // Check if email is not null before updating
        if (_email != null) {
          await user.updateEmail(_email!);
        }

        // Handle phone number updates
        if (_phoneNumber != null) {
          // await user.updatePhoneNumber(_phoneNumber!);

          // Update the phone number in Firestore
          await _usersCollection
              .doc(user.uid)
              .update({'phoneNumber': _phoneNumber});
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        // Pass back the updated phone number to the previous screen
        Navigator.pop(context, _phoneNumber);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  Future<void> _deleteProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Delete user document in Firestore
        await _usersCollection.doc(user.uid).delete();

        // Delete the user account
        await user.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile deleted successfully')),
        );

        // Navigate to login page after successful deletion
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Login()), // Replace with your login page
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.photoURL ?? ""),
                  radius: 75,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => _name = value,
              ),
              SizedBox(height: 10),
              // TextFormField(
              //   initialValue: _email,
              //   decoration: InputDecoration(labelText: 'Email'),
              //   onChanged: (value) => _email = value,
              // ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) => _phoneNumber = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfile();
                  }
                },
                child: Text('Update Profile'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _deleteProfile();
                },
                style: ElevatedButton.styleFrom(
                  primary: kprimaryColor,
                ),
                child: Text('Delete Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
