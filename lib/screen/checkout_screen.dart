import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/screen/payment_gateway.dart';
import 'package:firebase_2/constant.dart';
import 'package:ionicons/ionicons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutScreen extends StatefulWidget {
  final Product product;
  final DateTime selectedDate;

  const CheckoutScreen({
    Key? key,
    required this.product,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _currentLocation = 'Bhaktpur';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Extract location details from the Placemark
      Placemark placemark = placemarks[0];
      String city = placemark.locality ?? 'Unknown city';
      String area = placemark.subLocality ?? '';

      setState(() {
        _currentLocation = '$city, $area';
      });
    } catch (e) {
      print(e);
      setState(() {
        _currentLocation = 'Unable to fetch location';
      });
    }
  }

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
                    buildOrderDetail("From", getEmail()),
                    const SizedBox(height: 15),
                    // buildOrderDetail("Contact        ", getPhoneNumber(user)),
                    // const SizedBox(height: 15),
                    buildOrderDetail("Selected Date  ",
                        "${widget.selectedDate.toString().split(' ')[0]}"),
                    const SizedBox(height: 15),
                    buildOrderDetail("Car Model      ", widget.product.title),
                    const SizedBox(height: 15),
                    buildOrderDetail(
                        "Category       ", widget.product.category),
                    const SizedBox(height: 15),
                    buildOrderDetail(
                        "Amount         ", "Rs.${widget.product.price}"),
                    const SizedBox(height: 15),
                    buildOrderDetail(
                        "Vehicle Type   ", widget.product.vehicletype),
                    const SizedBox(height: 15),
                    buildOrderDetail(
                        "Driver's Name  ", widget.product.driverName),
                    const SizedBox(height: 15),
                    buildOrderDetail(
                        "Phone No.      ", widget.product.phoneNumber),
                    const SizedBox(height: 15),
                    buildOrderDetail(
                        "Vehicle Number ", "${widget.product.vehicleNumber}"),
                    const SizedBox(height: 15),
                    buildOrderDetail("Vehicle Location",
                        "${widget.product.location}, Nepal"),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;

                        QuerySnapshot querySnapshot = await firestore
                            .collection('booking')
                            .where('vehicleNumber',
                                isEqualTo: widget.product.vehicleNumber)
                            .where('selectedDate',
                                isEqualTo: widget.selectedDate)
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
                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;

                          String userEmail = getEmail();

                          await firestore.collection('booking').add({
                            'vehicleNumber': widget.product.vehicleNumber,
                            'vehicletype': widget.product.vehicletype,
                            'price': widget.product.price,
                            'selectedDate': widget.selectedDate,
                            'category': widget.product.category,
                            'driverName': widget.product.driverName,
                            'driverphoneNumber': widget.product.phoneNumber,
                            'title': widget.product.title,
                            'from': userEmail,
                            'userlocation': _currentLocation,
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentGatewayScreen(
                                product: widget.product,
                                productID: widget.product.vehicleNumber,
                                productName: widget.product.vehicletype,
                                productPrice: widget.product.price,
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
