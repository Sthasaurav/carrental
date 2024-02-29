import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/models/product.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          product.category,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 129, 105, 105),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\Rs${product.price}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
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
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 20), // Add space between rows

        Row(
          children: [
            // Owner picture
            CircleAvatar(
              radius: 20,
              // Add owner picture here
            ),
            const SizedBox(width: 10),
            // Owner name
            Text(
              "Tarqul Isalm",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // Button to call the owner
            IconButton(
              icon: Icon(Icons.phone),
              onPressed: () {
                // Add functionality to call the owner
              },
            ),
            // Book now button
            ElevatedButton(
              onPressed: () {
                // Add functionality for booking now
              },
              child: Text("Book Now"),
            ),
          ],
        ),
      ],
    );
  }
}
