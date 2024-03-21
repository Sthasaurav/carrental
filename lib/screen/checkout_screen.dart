import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/screen/payment_gateway.dart';
import 'package:flutter/material.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/constant.dart';
import 'package:ionicons/ionicons.dart';

class CheckoutScreen extends StatelessWidget {
  final Product product;

  const CheckoutScreen({Key? key, required this.product}) : super(key: key);

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
                      "Order Confirmation",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Display order details such as product, rental dates, etc.
                    buildOrderDetail("From           ", ""),
                    const SizedBox(height: 15),
                    buildOrderDetail("Car Model     ", product.title),
                    const SizedBox(height: 15),
                    buildOrderDetail("Category       ", product.category),
                    const SizedBox(height: 15),
                    buildOrderDetail("Amount         ", "Rs.${product.price}"),
                    const SizedBox(height: 15),
                    buildOrderDetail("Vehicle Type ", product.vehicletype),
                    const SizedBox(height: 15),
                    buildOrderDetail("Driver's Name", product.driverName),
                    const SizedBox(height: 15),
                    buildOrderDetail("Phone No.     ", product.phoneNumber),
                    const SizedBox(height: 15),

                    buildOrderDetail(
                        "Vehicle Number         ", "${product.vehicleNumber}"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      // Implement the logic to complete the booking
                      // This could involve processing payment, updating database, etc.
                      // After completion, navigate to a confirmation screen
                      // Assuming you have initialized Firestore somewhere in your app
                      onPressed: () async {
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;

                        // Check if any document in the "booking" collection has the same "vehicle_no" value
                        QuerySnapshot querySnapshot = await firestore
                            .collection('booking')
                            .where('vehicle_no',
                                isEqualTo: product.vehicleNumber)
                            .get();

                        // If any matching document is found, show the message
                        if (!querySnapshot.docs.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Already Booked!!!'),
                              content: Text(
                                  'Sorry, this vehicle is already booked, try renting any other vehicle.'),
                              actions: [
                                TextButton(
                                  // onPressed: () => Navigator.pop(context),
                                  onPressed: () => Navigator.popUntil(
                                      context, (route) => route.isFirst),

                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          try {
                            // Proceed with the booking logic
                            // Add the booking data to Firestore
                            // await firestore.collection('booking').add({
                            //   'title': product.title,
                            //   'category': product.category,
                            //   'price': product.price,
                            //   'vehicletype': product.vehicletype,
                            //   'driverName': product.driverName,
                            //   'phoneNumber': product.phoneNumber,
                            //   'vehicle_no': product.vehicleNumber,
                            //   // Add more fields if needed
                            // });

                            // TODO: Add logic to initialize payment gateway
                            // store payment transaction details in Firestore

                            // redirect to payment gateway
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentGatewayScreen(
                                    product: product,
                                    productID: product.vehicleNumber,
                                    productName: product.vehicletype,
                                    productPrice: product.price),
                              ),
                            );

                            // // After successful booking, navigate to confirmation screen
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ConfirmationScreen(),
                            //   ),
                            // );
                          } catch (e) {
                            // Handle errors, such as Firestore write errors
                            print("Error adding booking data: $e");
                          }
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

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                "Booking Confirmed!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Thank you for choosing our service.",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
