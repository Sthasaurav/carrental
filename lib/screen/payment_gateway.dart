import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/constant.dart';
import 'package:ionicons/ionicons.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/screen/checkout_screen.dart';

class PaymentGatewayScreen extends StatelessWidget {
  const PaymentGatewayScreen({
    Key? key,
    required this.productID,
    required this.productName,
    required this.productPrice,
    required this.product,
  }) : super(key: key);

  final productName;
  final productPrice;

  final productID;
  final Product product;

  String getEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      return user.email!;
    } else {
      return 'Unknown';
    }
  }

  String getPhoneNumber() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.phoneNumber != null) {
      return user.phoneNumber!;
    } else {
      return 'Unknown';
    }
  }

  // Function to pay with Khalti
  payWithKhaltiInApp(BuildContext context) {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: (10000).toInt(), // in paisa
        productIdentity: productID.toString(),
        productName: productName,
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: (PaymentSuccessModel data) {
        // Handle payment success
        // You can add logic here if needed
      },
      onFailure: (PaymentFailureModel data) {
        // Handle payment failure
        // You can add logic here if needed
      },
      onCancel: () {
        // Handle payment cancellation
        // You can add logic here if needed
      },
    );
  }

  // Function to handle placing the order
  void placeOrder(BuildContext context, DateTime selectedDate) async {
    try {
      // Call the function to initiate payment
      payWithKhaltiInApp(context);
    } catch (e) {
      // Handle errors, such as Firestore write errors
      print("Error adding booking data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Gateway",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Display order details such as product, rental dates, etc.
                    Image.asset(
                      "assets/khalti-logo.png",
                      width: 200,
                      height: 150,
                    ),
                    ElevatedButton(
                      // Implement the logic to complete the booking
                      onPressed: () {
                        // Call the function to place the order
                        placeOrder(
                            context, DateTime.now()); // Pass selectedDate
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Place Order",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
