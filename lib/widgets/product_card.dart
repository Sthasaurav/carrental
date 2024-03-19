import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/constant.dart';
import 'package:firebase_2/screen/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(product: product),
          ),
        );
      },
      child: Card(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.22,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kcontentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(children: [
                Image.asset(
                  product.image,
                  width: 110,
                  height: 80,
                ),
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  product.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Color.fromARGB(255, 129, 105, 105),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "\Rs.${product.price}/Day",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color.fromARGB(255, 129, 105, 105),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Ionicons.car_sport,
                          size: 15,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${product.vehicletype}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Color.fromARGB(255, 129, 105, 105),
                          ),
                        )
                      ],
                    ),
                    Row(children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 15,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${product.distance} km',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Color.fromARGB(255, 129, 105, 105),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5),

                      // Row(
                      //   children: [
                      //     Icon(
                      //       Ionicons.star,
                      //       size: 15,
                      //       color: Color.fromARGB(255, 233, 210, 7),
                      //     ),
                      //     SizedBox(width: 5),
                      //     Text(
                      //       '${product.rate}',
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 10,
                      //         color: Color.fromARGB(255, 129, 105, 105),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Icon(
                            Ionicons.people_circle_outline,
                            size: 18,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${product.numberOfPeople} \Seat',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Color.fromARGB(255, 129, 105, 105),
                            ),
                          )
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.location_on,
                      //       size: 15,
                      //       color: Colors.blue,
                      //     ),
                      //     SizedBox(width: 5),
                      //     Text(
                      //       '${product.distance} km',
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 10,
                      //         color: Color.fromARGB(255, 129, 105, 105),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ]),
                  ],
                ),
              ]),
              // Positioned(
              //   top: 10,
              //   right: 10,
              //   child: Container(
              //     padding: EdgeInsets.all(5),
              //     decoration: BoxDecoration(
              //       color: Colors.blue.withOpacity(0.8),
              //       borderRadius: BorderRadius.circular(10),
              //     ),

              //   ),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
