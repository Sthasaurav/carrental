import 'package:firebase_2/constant.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
// import 'package:shop_example/constants.dart';
// import 'package:shop_example/models/product.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Product> products;

  const CategoriesScreen({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kcontentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    product.image,
                    width: 150,
                    height: 120,
                  ),
                  SizedBox(height: 10),
                  Text(
                    product.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color.fromARGB(255, 129, 105, 105),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price}",
                        style: TextStyle(
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
                  SizedBox(height: 10),
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
                            style: TextStyle(
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
                            Ionicons.star,
                            size: 15,
                            color: Color.fromARGB(255, 233, 210, 7),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${product.rate}',
                            style: TextStyle(
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color.fromARGB(255, 129, 105, 105),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
