// import 'dart:io';

// import 'package:firebase_2/saurav/models/product.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:ionicons/ionicons.dart';
// // import 'package:shop_example/constants.dart';
// // import 'package:shop_example/models/cart_item.dart';
// // import 'package:shop_example/models/product.dart';
// // import 'package:shop_example/widgets/cart_tile.dart';
// import 'package:image_picker/image_picker.dart';
// // import 'package:shop_example/widgets/check_out_box.dart';

// class AddScreen extends StatefulWidget {
//   const AddScreen({super.key});

//   @override
//   State<AddScreen> createState() => _AddScreenState();
// }

// class _AddScreenState extends State<AddScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   File? _image;
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();
//   final TextEditingController _vehicletypeController = TextEditingController();
//   final TextEditingController _numberOfPeopleController =
//       TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _driverNameController = TextEditingController();
//   final TextEditingController _driverImageController = TextEditingController();

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedImage = await ImagePicker().pickImage(source: source);
//     if (pickedImage != null) {
//       setState(() {
//         _image = File(pickedImage.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Product'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: <Widget>[
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               _image != null
//                   ? Image.file(
//                       _image!,
//                       height: 200,
//                       width: 200,
//                       fit: BoxFit.cover,
//                     )
//                   : const SizedBox(height: 200),
//               ElevatedButton(
//                 onPressed: () => _pickImage(ImageSource.gallery),
//                 child: const Text('Pick Image'),
//               ),

//               TextFormField(
//                 controller: _priceController,
//                 decoration: InputDecoration(labelText: ' Price'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter price';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _categoryController,
//                 decoration: InputDecoration(labelText: ' Category'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Category';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _vehicletypeController,
//                 decoration: InputDecoration(labelText: ' vehicletype'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter vehicletypeController';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _numberOfPeopleController,
//                 decoration: InputDecoration(labelText: ' number of people'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter number of peaople';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _phoneNumberController,
//                 decoration: InputDecoration(labelText: ' number of people'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter number of peaople';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _driverNameController,
//                 decoration: InputDecoration(labelText: ' number of people'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter number of peaople';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _driverImageController,
//                 decoration: InputDecoration(labelText: ' number of people'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter number of peaople';
//                   }
//                   return null;
//                 },
//               ),
//               // Add more TextFormField widgets for other fields
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     Product product = Product(
//                       title: _titleController.text,
//                       description: _descriptionController.text,
//                       image: _image?.path ??
//                           '', // Use image path if available, otherwise use empty string
//                       price: _priceController.text,
//                       colors: [],
//                       category: _categoryController.text,
//                       vehicletype: _vehicletypeController.text,
//                       // numberOfPeople: _numberOfPeopleController.,
//                       phoneNumber: _phoneNumberController.text,
//                       driverName: _driverNameController.text,
//                       driverImage: _driverImageController.text,
//                       rate:
//                           0, // Set the rate to 0 for now, as it's not part of the form
//                     );

//                     // Pass the created Product object to the onSubmit function
//                     // onSubmit(product);
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
