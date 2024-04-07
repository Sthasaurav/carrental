import 'package:firebase_2/constant.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/screen/checkout_screen.dart';
import 'package:firebase_2/widgets/product_widgets/information.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize selected date with the current date
    _selectedDate = DateTime.now();
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
            ElevatedButton(
              onPressed: onSelectDate,
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(150, 50),
              ),
              child: Text(
                "Select Date: ${selectedDate.toString().split(' ')[0]}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
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
