import 'package:firebase_2/screen/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/constant.dart';
import 'package:ionicons/ionicons.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Function to pay with Khalti
  payWithKhaltiInApp(BuildContext context) {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: (productPrice * 100).toInt(), // in paisa
        productIdentity: productID.toString(),
        productName: productName,
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: (PaymentSuccessModel data) async {
        // Handle payment success
        // Store transaction details in database
        print("Payment Success");

        try {
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          // Add the booking data to Firestore
          await firestore.collection('booking').add({
            'title': product.title,
            'category': product.category,
            'price': product.price,
            'vehicletype': product.vehicletype,
            'driverName': product.driverName,
            'phoneNumber': product.phoneNumber,
            'vehicle_no': product.vehicleNumber,
            // Add more fields if needed
          });

          // Navigate to the confirmation screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ConfirmationScreen()),
          );
        } catch (e) {
          // Handle errors, such as Firestore write errors
          print("Error adding booking data: $e");
        }
      },
      onFailure: (PaymentFailureModel data) {
        // Handle payment failure
        // You can show an error message or retry option here
        // print data
        print(data.toString());
      },
      onCancel: () {
        // Handle cancellation logic here
        print("Payment Cancelled");
      },
    );
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
                      // This could involve processing payment, updating database, etc.
                      onPressed: () async {
                        // Call the payment function
                        payWithKhaltiInApp(context);
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

// class ConfirmationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kcontentColor,
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.check_circle,
//                 color: Colors.green,
//                 size: 100,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Booking Confirmed!",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Thank you for choosing our service.",
//                 style: TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.popUntil(context, (route) => route.isFirst);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: kprimaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   minimumSize: const Size(200, 50),
//                 ),
//                 child: const Text(
//                   "Back to Home",
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }