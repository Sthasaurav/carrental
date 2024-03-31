import 'package:firebase_2/Model/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/screen/payment_gateway.dart';
import 'package:firebase_2/constant.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutScreen extends StatelessWidget {
  final Product product;

  const CheckoutScreen({Key? key, required this.product}) : super(key: key);

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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;

                        QuerySnapshot querySnapshot = await firestore
                            .collection('booking')
                            .where('vehicle_no',
                                isEqualTo: product.vehicleNumber)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Already Booked!!!'),
                              content: Text(
                                  'Sorry, this vehicle is already booked, try renting any other vehicle.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.popUntil(
                                      context, (route) => route.isFirst),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
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
    if (user != null && user.phoneNumber != null) {
      return user.phoneNumber!;
    } else {
      return 'Unknown';
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
