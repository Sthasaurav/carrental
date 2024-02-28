import 'package:car_rental/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:car_rental/widget/category_card.dart';
import 'package:car_rental/widget/drawer.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Rental'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryCard(
                      categoryName: 'SUV', iconData: Icons.directions_car),
                  CategoryCard(
                      categoryName: 'Sedan', iconData: Icons.directions_car),
                  // Add more categories here
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Featured Cars',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            ProductCard(
              productName: 'Toyota Corolla',
              imageUrl: 'https://via.placeholder.com/150',
              price: '50/day',
              onTap: () {
                // Handle product tap
              },
            ),
            ProductCard(
              productName: 'Honda Civic',
              imageUrl: 'https://via.placeholder.com/150',
              price: '60/day',
              onTap: () {
                // Handle product tap
              },
            ),
            // Add more product cards here
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
