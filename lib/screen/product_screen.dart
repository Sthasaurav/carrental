import 'package:firebase_2/constant.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:shop_example/constants.dart';
// import 'package:shop_example/models/product.dart';
// import 'package:shop_example/widgets/product_widgets/product_desc.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                      ),
                      icon: const Icon(Ionicons.chevron_back),
                    ),
                    // Add other icons/buttons here if needed
                  ],
                ),
              ),
              SizedBox(
                height: 200, // Adjust the height as needed
                child: Image.asset(
                  widget.product.image,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                  right: 20,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductInfo(product: widget.product),
                    const SizedBox(height: 20),
                    ProductDescription(
                        text: widget.product.description,
                        product: widget.product),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
            fontSize: 26,
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
                  "(11 Reviews)",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ],
        ),
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

class ProductDescription extends StatelessWidget {
  final Product product;
  final String text;

  const ProductDescription({
    Key? key,
    required this.product,
    required this.text,
  }) : super(key: key);

  Future<void> makePhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 110,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kprimaryColor,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Description",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 15), // Add space between rows

        Row(
          children: [
            // Owner picture
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(product.driverImage),
            ),
            const SizedBox(width: 10),
            // Owner name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Above Owner name
                  Text(
                    "Driver",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey, // Set color to grey
                    ),
                  ),
                  // Owner name
                  Text(
                    product.driverName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // You can add more owner information here
                ],
              ),
            ),
            const Spacer(),
            // Button to call the owner
            IconButton(
              icon: Icon(
                Icons.phone,
                color: Colors.green,
              ),
              onPressed: () {
                makePhoneCall(product.phoneNumber);
              },
            ),
            // Book now button
          ],
        ),
        const SizedBox(height: 20), // Add space between rows

        ElevatedButton(
          onPressed: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Booking"),
                  content: Text("Are you sure you want to book this product?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add functionality for booking now
                        // This could involve navigating to the checkout screen
                        // or performing any necessary backend operations.
                        // Once done, you can close the dialog.
                        Navigator.pop(context); // Close the dialog
                        // Navigate to the checkout screen or perform booking operations
                      },
                      child: Text("Confirm"),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            primary: kprimaryColor, // Change button color to orange
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Set slight curve
            ),
            minimumSize: Size(double.infinity, 50), // Set button size
          ),
          child: Text(
            "Rent Now",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            // Increase font size
          ),
        ),
      ],
    );
  }
}
