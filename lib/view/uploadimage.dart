import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_2/screen/home_screen.dart';
// import 'package:firebase_2/view/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../helper/helper.dart';

class UploadImage extends StatefulWidget {
  UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? file;
  XFile? image;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [ui(), loader ? Helper.backdropFilter(context) : SizedBox()],
      )),
    );
  }

  ui() {
    return Column(
      children: [
        SizedBox(
          height: 75,
        ),
        Center(
          child: Container(
            child: GestureDetector(
              onTap: () {
                pickImagefromgallery();
              },
              child: Container(
                height: 300,
                width: 340,
                child: DottedBorder(
                    borderType: BorderType.RRect,
                    borderPadding: EdgeInsets.all(0.02),
                    radius: Radius.circular(12),
                    child: file == null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, top: 50),
                            child: Column(
                              children: [
                                Icon(Icons.file_upload_outlined, size: 100),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "upload profile picture",
                                  style: TextStyle(
                                      fontSize: 29,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          )
                        // : Image.file(
                        //     file!,
                        //     fit: BoxFit.cover,
                        //   )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              file!,
                              fit: BoxFit.cover,
                              width: 340,
                              height: 300,
                            ),
                          )),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 96, 141, 13),
                onPrimary: Colors.white),
            onPressed: () {
              UploadImageToFirebase();
            },
            child: Text(
              "submit",
              style: TextStyle(fontSize: 20),
            )),
        SizedBox(height: 100),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 70, 190, 34),
                onPrimary: Colors.white),
            onPressed: () {
              googleLogin();
            },
            child: SizedBox(
              height: 40,
              width: 220,
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.google),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Login with google",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ))
      ],
    );
  }

  pickImagefromgallery() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    image = await picker.pickImage(source: ImageSource.gallery);
    print(image);
    if (image == null) return;
    file = File(image!.path);
    setState(() {
      file;
      image;
    });
  }

  UploadImageToFirebase() async {
    setState(() {
      loader = true;
    });
    final storageReference = FirebaseStorage.instance.ref();
    var uploadValue = storageReference.child(image!.name);
    await uploadValue.putFile(file!);
    final downloadUrl =
        await storageReference.child(image!.name).getDownloadURL();

    //or
    //
    //
    print(downloadUrl);

    var data = {"image": downloadUrl};
    await FirebaseFirestore.instance
        .collection("imagetest")
        .add(data)
        .then((value) {
      setState(() {
        loader = false;
        file = null;
        image = null;
      });
    });
  }

  googleLogin() async {
    String? token;

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        print(user!.phoneNumber);
        // var token = await user.getIdToken();
        // print(token);
        await user.getIdToken().then((value) {
          token = value;
          print(token);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
      if (token != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      }
    }
  }
}
