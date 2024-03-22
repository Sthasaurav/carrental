import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // Call search function when text changes
                searchProducts(value);
              },
              decoration: InputDecoration(
                hintText: 'Search for cars',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('product').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No products found in Firestore.'),
                  );
                }

                List<Product> productsList = [];

                // Iterate through the documents and add product details to the list
                snapshot.data!.docs.forEach((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  Product product = Product.fromMap(data);

                  // Check if the product title or category contains the search text
                  if (_searchController.text.isNotEmpty &&
                      (product.title
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()) ||
                          product.category.toLowerCase().contains(
                              _searchController.text.toLowerCase()))) {
                    productsList.add(product);
                  }
                });
                productsList.sort((a, b) => a.distance.compareTo(b.distance));

                return ListView.builder(
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: productsList[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to search based on the product title
  void searchProducts(String searchTerm) {
    setState(() {
      // Trigger a rebuild with the updated search term
    });
  }
}
