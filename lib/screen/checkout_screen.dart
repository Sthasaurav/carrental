import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/screen/payment_gateway.dart';
import 'package:firebase_2/constant.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutScreen extends StatelessWidget {
  final Product product;
  final DateTime selectedDate;

  const CheckoutScreen({
    Key? key,
    required this.product,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

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
                      "Order Confirmation",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Display order details such as product, rental dates, etc.
                    buildOrderDetail("From           ", getEmail()),
                    const SizedBox(height: 15),
                    buildOrderDetail("Contact        ", getPhoneNumber(user)),
                    const SizedBox(height: 15),
                    buildOrderDetail("Selected Date  ",
                        "${selectedDate.toString().split(' ')[0]}"),
                    const SizedBox(height: 15),
                    buildOrderDetail("Car Model      ", product.title),
                    const SizedBox(height: 15),
                    buildOrderDetail("Category       ", product.category),
                    const SizedBox(height: 15),
                    buildOrderDetail("Amount         ", "Rs.${product.price}"),
                    const SizedBox(height: 15),
                    buildOrderDetail("Vehicle Type   ", product.vehicletype),
                    const SizedBox(height: 15),
                    buildOrderDetail("Driver's Name  ", product.driverName),
                    const SizedBox(height: 15),
                    buildOrderDetail("Phone No.      ", product.phoneNumber),
                    const SizedBox(height: 15),
                    buildOrderDetail(
                        "Vehicle Number ", "${product.vehicleNumber}"),
                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: () async {
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;

                        // Check if the vehicle is already booked for the selected date
                        QuerySnapshot querySnapshot = await firestore
                            .collection('booking')
                            .where('vehicleNumber',
                                isEqualTo: product.vehicleNumber)
                            .where('selectedDate', isEqualTo: selectedDate)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Already Booked!!!'),
                              content: Text(
                                  'Sorry, this vehicle is already booked for the selected date. Please try renting another vehicle or choose a different date.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen()),
                                  ),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // If the vehicle is not already booked, navigate to the payment gateway screen
                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;

                          // Add the booking data to Firestore
                          // Get user email and phone number
                          String userEmail = getEmail();
                          // String userPhoneNumber = getPhoneNumber();

                          // Add booking details to Firestore
                          await firestore.collection('booking').add({
                            'vehicleNumber': product.vehicleNumber,
                            'vehicletype': product.vehicletype,
                            'price': product.price,
                            'selectedDate':
                                selectedDate, // Convert DateTime to string
                            'category': product.category,
                            'driverName': product.driverName,
                            'driverphoneNumber': product.phoneNumber,
                            // 'phoneNumber': userPhoneNumber,
                            'title': product.title,
                            'from': userEmail,
                            // Add other fields as needed
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentGatewayScreen(
                                product: product,
                                productID: product.vehicleNumber,
                                productName: product.vehicletype,
                                productPrice: product.price,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Complete Booking",
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

  String getEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      return user.email!;
    } else {
      return 'Unknown';
    }
  }

  String getPhoneNumber(User? user) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.phoneNumber != null) {
      return user.phoneNumber!;
    } else {
      return 'unknown';
    }
  }

  Widget buildOrderDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
        const SizedBox(width: 10),
        Spacer(),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
