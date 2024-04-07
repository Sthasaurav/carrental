import 'package:firebase_2/Model/category.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:flutter/material.dart';
import 'package:firebase_2/constant.dart';
import 'package:firebase_2/widgets/home_appbar.dart';
import 'package:firebase_2/widgets/product_card.dart';
import 'package:firebase_2/widgets/search_field.dart';
import 'package:firebase_2/widgets/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MostRated extends StatelessWidget {
  const MostRated({Key? key}) : super(key: key);

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
                Categories(
                    categories: categories), // Pass an empty list initially
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Special For You",
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
                      .orderBy("distance") // Order products by distance
                      .limit(6) // Limit to only 6 products
                      .snapshots(),
                  builder: (context, snapshot) {
                    print("Snapshot: $snapshot");
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

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Product product = Product.fromMap(
                            document.data() as Map<String, dynamic>);
                        return ProductCard(product: product);
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
