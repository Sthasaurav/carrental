import 'package:flutter/material.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/constant.dart';
import 'package:ionicons/ionicons.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class PaymentGatewayScreen extends StatelessWidget {
  const PaymentGatewayScreen(
      {Key? key,
      required this.productID,
      required this.productName,
      required this.productPrice})
      : super(key: key);

  final productName;
  final productPrice;
  final productID;

  // create function to pay with khalti
  payWithKhaltiInApp(BuildContext context) {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: (productPrice * 100).toInt(), //in paisa
        productIdentity: productID.toString(),
        productName: productName,
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: (PaymentSuccessModel data) {
        // Handle payment success
        // You can navigate to the confirmation screen here
        // TODO: store transaction details in database
        print("Payment Success");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmationScreen()),
        );
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
                      // After completion, navigate to a confirmation screen
                      // Assuming you have initialized Firestore somewhere in your app
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
