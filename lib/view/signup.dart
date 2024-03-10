// import 'package:firebase_2/customui/custombutton.dart';
// import 'package:firebase_2/saurav/models/screens/main_screen.dart';
// import 'package:firebase_2/view/login.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../api/networkstatus.dart';
// import '../customui/customtextformfield.dart';
// import '../helper/helper.dart';
// import '../provider/signupprovider.dart';
// import '../util/string_const.dart';

// class SignUp extends StatefulWidget {
//   SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   List<String> itemList = ["Male", "Female"];

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("SignUp"),
//           backgroundColor: Colors.red,
//         ),
//         body: Consumer<SignUpProvider>(
//           builder: (context, SignupProvider, child) => Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: SingleChildScrollView(
//               child: Stack(
//                 children: [ui(SignupProvider, context), loader(SignupProvider)],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   loader(SignUpProvider signUpProvider) {
//     if (signUpProvider.signUpStatus == NetworkStatus.loading) {
//       return Helper.backdropFilter(context);
//     } else {
//       return SizedBox();
//     }
//   }

//   Widget ui(SignUpProvider signupProvider, BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           CustomForm(
//             onChanged: (value) {
//               signupProvider.name = value;
//             },
//             obscureText: false,
//             labelText: nameStr,
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return nameValidationStr;
//               } else {
//                 return null;
//               }
//             },
//             suffixIcon: const Icon(Icons.person),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           CustomForm(
//             onChanged: (value) {
//               signupProvider.email = value;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return emailValidationStr;
//               } else {
//                 return null;
//               }
//             },
//             obscureText: false,
//             labelText: emailStr,
//             suffixIcon: const Icon(Icons.email),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           CustomForm(
//             onChanged: (value) {
//               signupProvider.address = value;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return addressValidationStr;
//               } else {
//                 return null;
//               }
//             },
//             obscureText: false,
//             labelText: addressStr,
//             suffixIcon: const Icon(Icons.location_city),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           CustomForm(
//             onChanged: (value) {
//               signupProvider.phone = value;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return contactValidationStr;
//               } else {
//                 return null;
//               }
//             },
//             obscureText: false,
//             labelText: contactStr,
//             suffixIcon: const Icon(Icons.phone),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           CustomForm(
//               onChanged: (value) {
//                 signupProvider.password = value;
//               },
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return passwordValidationStr;
//                 } else {
//                   return null;
//                 }
//               },
//               labelText: passwordStr,
//               obscureText: signupProvider.showPassword ? false : true,
//               suffixIcon: signupProvider.showPassword
//                   ? IconButton(
//                       onPressed: () {
//                         signupProvider.passwordVisibility(false);
//                       },
//                       icon: const Icon(Icons.visibility))
//                   : IconButton(
//                       onPressed: () {
//                         signupProvider.passwordVisibility(true);
//                       },
//                       icon: const Icon(Icons.visibility_off))),
//           const SizedBox(
//             height: 10,
//           ),
//           // CustomDropDown(
//           //   validator: (value) {
//           //     if (value == null || value.isEmpty) {
//           //       return genderValidationStr;
//           //     } else {
//           //       return null;
//           //     }
//           //   },
//           //   icon: Icon(Icons.people),
//           //   decoration: InputDecoration(
//           //     labelText: genderStr,
//           //     border: OutlineInputBorder(),
//           //   ),
//           //   itemList: itemList,
//           //   value: signupProvider.gender,
//           //   onChanged: (value) {
//           //     signupProvider.gender = value;
//           //   },
//           // ),
//           SizedBox(
//             height: 20,
//           ),
//           Custombutton(
//             onPressed: () async {
//               if (_formKey.currentState!.validate()) {
//                 User? user = await _authService.registerWithEmailAndPassword(
//                   signupProvider.email!,
//                   signupProvider.password!,
//                   signupProvider.name!,
//                   passwordVisibility.address!,
//                   passwordVisibility.contact!,
//                 );

//                 if (user != null) {
//                   // Registration successful
//                   Helper.snackBarMessage("Successfully Registered", context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MainScreen()),
//                   );
//                 } else {
//                   // Registration failed
//                   Helper.snackBarMessage("Registration Failed", context);
//                 }
//               }
//             },
//             onPrimary: Colors.white,
//             primary: Colors.red,
//             child: Text("Submit"),
//           )
//         ],
//       ),
//     );
//   }
// }
