// import 'package:firebase_2/saurav/constant.dart';
// import 'package:firebase_2/saurav/models/product.dart';
// import 'package:firebase_2/saurav/models/screens/product_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';

// class ProductCard extends StatelessWidget {
//   final Product product;
//   const ProductCard({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     // return Builder(builder: (BuilderContext context) {
//     // final Size size = MediaQuery.of(context).size;

//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => ProductScreen(product: product ),
//           ),
//         );
//       },
//       child: Stack(
//         children: [
//           Container(
//             height: 250,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: kcontentColor,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Column(
//               children: [
//                 Image.asset(
//                   product.image,
//                   width: 150,
//                   height: 120,
//                 ),
//                 Text(
//                   product.title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Text(
//                   product.category,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                     color: Color.fromARGB(255, 129, 105, 105),
//                   ),
//                 ),
//                 const SizedBox(height: 5),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Text(
//                       "\Rs.${product.price}",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                         color: Color.fromARGB(255, 129, 105, 105),
//                       ),
//                     ),
//                     Row(
//                       children: List.generate(
//                         product.colors.length,
//                         (cindex) => Container(
//                           height: 15,
//                           width: 15,
//                           margin: const EdgeInsets.only(right: 2),
//                           decoration: BoxDecoration(
//                             color: product.colors[cindex],
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Ionicons.car_sport,
//                             size: 18,
//                             color: Colors.blue,
//                           ),
//                           SizedBox(width: 5),
//                           Text(
//                             '${product.vehicletype}',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                               color: Color.fromARGB(255, 129, 105, 105),
//                             ),
//                           )
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(
//                             Ionicons.star,
//                             size: 15,
//                             color: Color.fromARGB(255, 233, 210, 7),
//                           ),
//                           SizedBox(width: 5),
//                           Text(
//                             '${product.rate}',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                               color: Color.fromARGB(255, 129, 105, 105),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(
//                             Ionicons.people_circle_outline,
//                             size: 18,
//                             color: Colors.blue,
//                           ),
//                           SizedBox(width: 5),
//                           Text(
//                             '${product.numberOfPeople}',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                               color: Color.fromARGB(255, 129, 105, 105),
//                             ),
//                           )
//                         ],
//                       ),
//                     ]),

//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_2/constant.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/screen/product_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('product').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // If there's no data or data list is empty, return a message
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No products found.'));
        }

        // If data is available, build the ListView of ProductCard widgets
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            Product product = Product.fromMap(
                data); // Convert document data to Product object
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(product: product),
                  ),
                );
              },
              child: ProductItem(product: product),
            );
          }).toList(),
        );
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kcontentColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Image.asset(
                product.image,
                width: 150,
                height: 120,
              ),
              Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                product.category,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color.fromARGB(255, 129, 105, 105),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "\Rs.${product.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color.fromARGB(255, 129, 105, 105),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      product.colors.length,
                      (cindex) => Container(
                        height: 15,
                        width: 15,
                        margin: const EdgeInsets.only(right: 2),
                        decoration: BoxDecoration(
                          color: product.colors[cindex],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.car_rental,
                        size: 18,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${product.vehicletype}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color.fromARGB(255, 129, 105, 105),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 15,
                        color: Color.fromARGB(255, 233, 210, 7),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${product.rate}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color.fromARGB(255, 129, 105, 105),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.people_alt_outlined,
                        size: 18,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${product.numberOfPeople}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color.fromARGB(255, 129, 105, 105),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
