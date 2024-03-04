// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shop_example/constants.dart';

// class ProductDescription extends StatelessWidget {
//   final String text;
//   const ProductDescription({super.key, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 110,
//           height: 38,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: kprimaryColor,
//           ),
//           alignment: Alignment.center,
//           child: const Text(
//             "Description",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Text(
//           text,
//           style: const TextStyle(
//             color: Colors.grey,
//           ),
//         ),
//         const SizedBox(height: 15), // Add space between rows

//         Row(
//           children: [
//             // Owner picture
//             CircleAvatar(
//               radius: 20,
//               // Add owner picture here
//             ),
//             const SizedBox(width: 10),
//             // Owner name
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Above Owner name
//                   Text(
//                     "Driver",
//                     style: TextStyle(
//                       fontSize: 12,

//                       color: Colors.grey, // Set color to grey
//                     ),
//                   ),
//                   // Owner name
//                   Text(
//                     "Tarqul Isalm",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   // You can add more owner information here
//                 ],
//               ),
//             ),
//             const Spacer(),
//             // Button to call the owner
//             IconButton(
//               icon: Icon(
//                 Icons.phone,
//                 color: Colors.green,
//               ),
//               onPressed: () {
//                 // Add functionality to call the owner
//               },
//             ),
//             // Book now button
//           ],
//         ),
//         const SizedBox(height: 20), // Add space between rows

//         ElevatedButton(
//           onPressed: () {
//             // Add functionality for booking now
//           },
//           style: ElevatedButton.styleFrom(
//             primary: kprimaryColor, // Change button color to orange
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10), // Set slight curve
//             ),
//             minimumSize: Size(double.infinity, 50), // Set button size
//           ),
//           child: Text(
//             "Rent Now",
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.white,
//             ),
//             // Increase font size
//           ),
//         ),
//       ],
//     );
//   }
// }
