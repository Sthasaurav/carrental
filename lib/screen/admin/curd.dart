// import 'package:firebase_2/screen/admin/productedit.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_2/constant.dart';

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
//               return ProductCard(productSnapshot: productSnapshot);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class ProductCard extends StatelessWidget {
//   final DocumentSnapshot productSnapshot;

//   const ProductCard({required this.productSnapshot});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 ProductEditForm(productSnapshot: productSnapshot),
//           ),
//         );
//       },
//       child: Card(
//         margin: EdgeInsets.all(8.0),
//         child: ListTile(
//           title: Text(productSnapshot['title']),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Category: ${productSnapshot['category']}'),
//               Text('Price: \Rs.${productSnapshot['price']}'),
//               // Add more fields as needed
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
