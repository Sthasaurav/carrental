// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AdminProductEditScreen extends StatefulWidget {
//   @override
//   _AdminProductEditScreenState createState() => _AdminProductEditScreenState();
// }

// class _AdminProductEditScreenState extends State<AdminProductEditScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Products'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('product').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No products found.'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               DocumentSnapshot productSnapshot = snapshot.data!.docs[index];
//               return ProductEditForm(productSnapshot: productSnapshot);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class ProductEditForm extends StatefulWidget {
//   final DocumentSnapshot productSnapshot;

//   const ProductEditForm({required this.productSnapshot});

//   @override
//   _ProductEditFormState createState() => _ProductEditFormState();
// }

// class _ProductEditFormState extends State<ProductEditForm> {
//   late Map<String, TextEditingController> _controllers;

//   @override
//   void initState() {
//     super.initState();
//     _controllers = {};
//     final Map<String, dynamic>? data =
//         widget.productSnapshot.data() as Map<String, dynamic>?;
//     if (data != null) {
//       data.keys.forEach((key) {
//         _controllers[key] = TextEditingController(text: data[key].toString());
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controllers.values.forEach((controller) => controller.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             children: _controllers.keys.map((key) {
//               return TextFormField(
//                 controller: _controllers[key],
//                 decoration: InputDecoration(labelText: key),
//               );
//             }).toList(),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Implement logic to update Firestore document with edited details
//               // You can access edited values using _controllers.values
//             },
//             child: Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
// }
