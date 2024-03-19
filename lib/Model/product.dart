import 'package:firebase_2/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String title;
  final String description;
  final String image;
  final dynamic price;
  final String category;
  final double rate;
  final String vehicletype;
  final int numberOfPeople;
  final String phoneNumber;
  final String driverName;
  final String driverImage;
  final String id;
  final int count;
  final double vehicleNumber;

  Product({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    required this.rate,
    required this.vehicletype,
    required this.numberOfPeople,
    required this.phoneNumber,
    required this.driverName,
    required this.driverImage,
    required this.id,
    required this.count,
    required this.vehicleNumber,
  });

  // Define the fromMap method to convert a Firestore document snapshot into a Product object
  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] != null ? (map['price'] as num).toDouble() : 0.0,
      category: map['category'] ?? '',
      rate: map['rate'] != null ? (map['rate'] as num).toDouble() : 0.0,
      vehicletype: map['vehicletype'] ?? '',
      numberOfPeople: map['numberOfPeople'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      driverName: map['driverName'] ?? '',
      driverImage: map['driverImage'] ?? '',
      id: map['id'] ?? '',
      count: map['count'] != null ? (map['count'] as num).toInt() : 0,
      vehicleNumber: map['vehicleNumber'] != null
          ? (map['vehicleNumber'] as num).toDouble()
          : 0.0,
    );
  }
}

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("product").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No product details found in Firestore.'));
          }

          // Add this line to see the document count
          print('Document Count: ${snapshot.data!.docs.length}');

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              try {
                Map<String, dynamic> data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                print("Data for index $index: $data");
                Product product = Product.fromMap(data);
                return ProductCard(product: product);
              } catch (e) {
                print("Error processing data for index $index: $e");
                return Container(); // Skip invalid data
              }
            },
          );
        },
      ),
    );
  }
}
