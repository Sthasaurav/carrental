import 'package:flutter/material.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/constant.dart';
import 'package:firebase_2/widgets/home_appbar.dart';
import 'package:firebase_2/widgets/product_card.dart';
import 'package:firebase_2/widgets/search_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllProductPage extends StatelessWidget {
  const AllProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),
                const SizedBox(height: 20),
                const SearchField(),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Explore All Vehicles",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("product")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child:
                              Text('No product details found in Firestore.'));
                    }

                    // Sort the products by distance from the user
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    documents.sort((a, b) {
                      // Access distance field from documents and compare
                      double distanceA = a.get('distance');
                      double distanceB = b.get('distance');
                      return distanceA.compareTo(distanceB);
                    });

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        try {
                          Map<String, dynamic> data =
                              documents[index].data() as Map<String, dynamic>;
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
