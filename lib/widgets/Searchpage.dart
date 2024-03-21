// import 'package:flutter/material.dart';
// import 'package:firebase_2/Model/product.dart';
// import 'package:firebase_2/constant.dart';
// import 'package:firebase_2/screen/product_screen.dart';

// class ProductSearch extends StatefulWidget {
//   @override
//   _ProductSearchState createState() => _ProductSearchState();
// }

// class _ProductSearchState extends State<ProductSearch> {
//   late List<Product> filteredProducts;
//   late String searchQuery;

//   @override
//   void initState() {
//     super.initState();
//     filteredProducts = [];
//     searchQuery = '';
//   }

//   // Method to set the products list
//   void setProductsList(List<Product> products) {
//     setState(() {
//       filteredProducts = products;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             onChanged: (value) {
//               setState(() {
//                 searchQuery = value;
//                 filteredProducts = filteredProducts
//                     .where((product) => product.title
//                         .toLowerCase()
//                         .startsWith(value.toLowerCase()))
//                     .toList();
//               });
//             },
//             decoration: InputDecoration(
//               labelText: 'Search by model',
//               prefixIcon: Icon(Icons.search),
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: filteredProducts.length,
//             itemBuilder: (context, index) {
//               final product = filteredProducts[index];
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => ProductScreen(product: product),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   child: Stack(
//                     children: [
//                       Container(
//                         height: MediaQuery.of(context).size.height * 0.22,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: kcontentColor,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Column(
//                           children: [
//                             ListTile(
//                               leading: Image.asset(
//                                 product.image,
//                                 width: 110,
//                                 height: 80,
//                               ),
//                               title: Text(product.title),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Category: ${product.category}'),
//                                   Text('Price: \Rs.${product.price}/Day'),
//                                   Row(
//                                     children: [
//                                       Icon(Icons.car_rental,
//                                           size: 15, color: Colors.blue),
//                                       SizedBox(width: 5),
//                                       Text('${product.vehicletype}',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 10,
//                                               color: Color.fromARGB(
//                                                   255, 129, 105, 105))),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       Icon(Icons.location_on,
//                                           size: 15, color: Colors.blue),
//                                       SizedBox(width: 5),
//                                       Text('${product.distance} km',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 10,
//                                               color: Color.fromARGB(
//                                                   255, 129, 105, 105))),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
  
// }
