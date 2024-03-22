import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile.dart'; // Assuming you have a ProfilePage with similar UI
import 'login.dart'; // Assuming you have a LoginPage

class EditProfilePage extends StatefulWidget {
  final User? user;
  final Map<String, dynamic>? userData;

  EditProfilePage({required this.user, this.userData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _phone;
  String? _address;

  @override
  void initState() {
    super.initState();
    final User? user = widget.user;

    _name = widget.userData?['name'] ?? user?.displayName ?? '';
    _email = user?.email;
    _phone = widget.userData?['phone'] ?? user?.phoneNumber ?? '';
    _address = widget.userData?['address'] ?? '';
  }

  Future<void> _updateProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateProfile(displayName: _name);

        final querySnapshot = await FirebaseFirestore.instance
            .collection('credential')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.update({
            'name': _name,
            'phone': _phone,
            'address': _address,
          });
        } else {
          print('User document not found');
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        Navigator.pop(context); // Go back to previous screen
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
        // Delete user's data from the Firestore collection named "credential"
        await FirebaseFirestore.instance
            .collection('credential')
            .where('email', isEqualTo: user.email)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        // Delete user's account from Firebase Authentication
        await user.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile deleted successfully')),
        );

        // Navigate to the login page and prevent going back
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
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
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.white, // Uber's brand color
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage(
                    user?.photoURL ??
                        'https://www.example.com/default-image.jpg',
                  ),
                ),
                SizedBox(height: 20),
                buildProfileField(
                    Icons.person, "Name", _name, (value) => _name = value),
                buildProfileField(Icons.email, "Email", _email, (value) {}),
                buildProfileField(
                    Icons.phone, "Contact", _phone, (value) => _phone = value),
                buildProfileField(Icons.location_on, "Address", _address,
                    (value) => _address = value),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateProfile();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // Uber's brand color
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Update Profile',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _deleteProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 238, 21, 5),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Delete Profile',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileField(IconData icon, String label, String? value,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon),
        title: TextFormField(
          initialValue: value,
          onChanged: onChanged,
          enabled: label != "Email", // Disable email field
          readOnly: label == "Email", // Make email field read-only
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 18, color: Colors.black),
            hintText: 'Enter $label',
            hintStyle: TextStyle(fontSize: 16, color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
