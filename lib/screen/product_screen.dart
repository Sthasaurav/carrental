import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/constant.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/screen/checkout_screen.dart';
import 'package:firebase_2/widgets/product_widgets/information.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/helper.dart';

class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late DateTime _selectedDate;
  late List<Map<String, dynamic>> _ratings = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    fetchRatings();
  }

  void fetchRatings() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('orderTitle', isEqualTo: widget.product.title)
        .get();
    setState(() {
      _ratings = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

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
              // Header section...
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
                  ],
                ),
              ),
              // Product image section...
              SizedBox(
                height: 200,
                child: Image.asset(
                  widget.product.image,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              // Product details section...
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product information...
                      ProductInfo(product: widget.product, ratings: _ratings),
                      const SizedBox(height: 20),
                      // Product description...
                      ProductDescription(
                        text: widget.product.description,
                        product: widget.product,
                        onSelectDate: () => _selectDate(context),
                        selectedDate: _selectedDate,
                        onRentNowPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                product: widget.product,
                                selectedDate: _selectedDate,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Reviews section...
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200], // Adjust color as needed
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Display reviews...
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: _ratings.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Review rating...
                                    Row(
                                      children: List.generate(
                                        (_ratings[index]['rating'] as double)
                                            .round(),
                                        (index) => Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                    // Review text...
                                    Text(_ratings[index]['review']),
                                    // Reviewer email...
                                    Text(
                                      'Reviewed by: ${_ratings[index]['userEmail']}',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ProductInfo and ProductDescription widgets...

class ProductInfo extends StatelessWidget {
  final Product product;
  final List<Map<String, dynamic>> ratings;

  const ProductInfo({
    Key? key,
    required this.product,
    required this.ratings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                      Icon(
                        Icons.star,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        ratings.isEmpty
                            ? '0.0'
                            : '${calculateAverageRating().toStringAsFixed(1)}',
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
                IconButton(
                  onPressed: () {
                    Helper.launchMaps("${product.location}");
                  },
                  icon: Icon(
                    Icons.location_on,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          "\Rs.${product.price}/Day",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  double calculateAverageRating() {
    double totalRating = 0.0;
    for (var ratingData in ratings) {
      totalRating += ratingData['rating'];
    }
    return totalRating / ratings.length;
  }
}

class ProductDescription extends StatelessWidget {
  final Product product;
  final String text;
  final DateTime selectedDate;
  final VoidCallback onSelectDate;
  final VoidCallback onRentNowPressed;

  const ProductDescription({
    Key? key,
    required this.product,
    required this.text,
    required this.onSelectDate,
    required this.selectedDate,
    required this.onRentNowPressed,
  }) : super(key: key);

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
        Row(
          children: [
            ElevatedButton(
              onPressed: onSelectDate,
              style: ElevatedButton.styleFrom(
                backgroundColor: kcontentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(150, 50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Pick up Date: ${selectedDate.toString().split(' ')[0]}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20), // Add space below Select Date button

        ElevatedButton(
          onPressed: onRentNowPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: kprimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text(
            "Rent Now",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  String url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
