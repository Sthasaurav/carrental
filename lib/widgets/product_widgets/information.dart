import 'package:firebase_2/constant.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';


class ProductInfo extends StatelessWidget {
  final Product product;
  const ProductInfo({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product title
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Category and Rating section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Category centered below title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 129, 105, 105),
                    ),
                  ),
                ],
              ),
            ),
            // Rating section at the right of the category
            Row(
              children: [
                Container(
                  width: 50,
                  height: 20,
                  decoration: BoxDecoration(
                    color: kprimaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Ionicons.star,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        product.rate.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  "(320 Reviews)",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Row(
        //       children: [
        //         Icon(
        //           Ionicons.car_sport,
        //           size: 18,
        //           color: Colors.grey,
        //         ),
        //         SizedBox(width: 5),
        //         Text(
        //           '${product.vehicletype}',
        //           style: const TextStyle(
        //             fontWeight: FontWeight.bold,
        //             fontSize: 12,
        //             color: Color.fromARGB(255, 129, 105, 105),
        //           ),
        //         )
        //       ],
        //     ),
        //     // Row(
        //     //   children: [
        //     //     Icon(
        //     //       Ionicons.star,
        //     //       size: 15,
        //     //       color: Color.fromARGB(255, 233, 210, 7),
        //     //     ),
        //     //     SizedBox(width: 5),
        //     //     Text(
        //     //       '${product.rate}',
        //     //       style: const TextStyle(
        //     //         fontWeight: FontWeight.bold,
        //     //         fontSize: 12,
        //     //         color: Color.fromARGB(255, 129, 105, 105),
        //     //       ),
        //     //     ),
        //     //   ],
        //     // ),
        //     Row(
        //       children: [
        //         Icon(
        //           Ionicons.people_circle_outline,
        //           size: 18,
        //           color: Colors.grey,
        //         ),
        //         SizedBox(width: 5),
        //         Text(
        //           '${product.numberOfPeople}',
        //           style: const TextStyle(
        //             fontWeight: FontWeight.bold,
        //             fontSize: 12,
        //             color: Color.fromARGB(255, 129, 105, 105),
        //           ),
        //         )
        //       ],
        //     ),
        //   ],
        // ),

        const SizedBox(height: 5), // Add space between rows
        Text(
          "\Rs.${product.price}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
