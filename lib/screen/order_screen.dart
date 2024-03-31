import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore library
import 'package:firebase_2/constant.dart'; // Import your constants file
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher for making phone calls

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; // Get current user

    return Scaffold(
      backgroundColor: kscaffoldColor,
      appBar: AppBar(
        backgroundColor: kscaffoldColor,
        centerTitle: true,
        title: Text(
          "My Orders",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('booking')
            .where('from', isEqualTo: user!.email)
            .snapshots(), // Filter orders by userEmail
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No orders found.'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var orderData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                // Customize your order item widget based on orderData
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderData['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Category: ${orderData['category']}'),
                        Text('Vehicle Type: ${orderData['vehicletype']}'),
                        Text('Price: \$${orderData['price']} per Day'),
                        Text("Driver's Name: ${orderData['driverName']}"),
                        Row(
                          children: [
                            Text(
                              "Call Driver for more informations ",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.phone,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                makePhoneCall(orderData['phoneNumber']);
                              },
                            ),
                          ],
                        ),
                        // You can display more information here as per your Firestore schema
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to make a phone call
  void makePhoneCall(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}
