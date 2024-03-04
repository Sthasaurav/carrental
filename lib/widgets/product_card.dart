import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/models/product.dart';
import 'package:shop_example/screens/product_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // return Builder(builder: (BuilderContext context) {
    // final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(product: product),
          ),
        );
      },
      child: Stack(
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
                            Ionicons.car_sport,
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
                            Ionicons.star,
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
                            Ionicons.people_circle_outline,
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
                    ]),
                // Positioned.fill(
                //   child: Align(
                //     alignment: Alignment.topRight,
                //     child: Container(
                //       width: 30,
                //       height: 30,
                //       decoration: const BoxDecoration(
                //         color: kprimaryColor,
                //         borderRadius: BorderRadius.only(
                //           topRight: Radius.circular(20),
                //           bottomLeft: Radius.circular(10),
                //         ),
                //       ),
                //       child: const Icon(
                //         Ionicons.star_sharp,
                //         color: Colors.white,
                //         size: 18,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
