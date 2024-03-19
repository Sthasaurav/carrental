import 'package:firebase_2/constant.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/widgets/product_card.dart';
import 'package:firebase_2/Model/product.dart';

class Search_Page extends StatefulWidget {
  @override
  _Search_PageState createState() => _Search_PageState();
}

class _Search_PageState extends State<Search_Page> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kscaffoldColor,
          title: Text(
            'Car Rental',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  // Call search function when text changes
                  searchProducts(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search for cars',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: kcontentColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
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
                      child: Text(
                        'No products found in Firestore.',
                        style: TextStyle(
                          color: Color.fromARGB(255, 129, 105, 105)
                              .withOpacity(0.6),
                        ),
                      ),
                    );
                  }

                  List<Product> productsList = [];

                  // Iterate through the documents and add product details to the list
                  snapshot.data!.docs.forEach((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    Product product = Product.fromMap(data);

                    // Check if the product title contains the search text
                    if (searchController.text.length >= 2 &&
                        product.title.toLowerCase().startsWith(searchController
                            .text
                            .toLowerCase()
                            .substring(0, 2))) {
                      productsList.add(product);
                    }
                  });

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
