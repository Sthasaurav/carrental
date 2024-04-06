import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore library
import 'package:firebase_2/constant.dart'; // Import your constants file
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
                return OrderItemCard(orderData: orderData);
              },
            );
          }
        },
      ),
    );
  }
}

class OrderItemCard extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const OrderItemCard({Key? key, required this.orderData}) : super(key: key);

  @override
  _OrderItemCardState createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  double _rating = 0.0; // Initial rating value
  String _review = ''; // Initial review value

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.orderData['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text('Category: ${widget.orderData['category']}'),
            Text('Vehicle Type: ${widget.orderData['vehicletype']}'),
            Text('Price: \$${widget.orderData['price']} per Day'),
            Text("Driver's Name: ${widget.orderData['driverName']}"),
            Row(
              children: [
                Text(
                  "Call Driver for more information ",
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
                    makePhoneCall(widget.orderData['phoneNumber']);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Rate this order:'),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _review = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                submitRatingAndReview();
              },
              child: Text('Submit'),
            ),
          ],
        ),
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

  // Function to submit rating and review
  void submitRatingAndReview() {
    // Save rating and review to Firestore
    FirebaseFirestore.instance.collection('ratings').add({
      'orderTitle': widget.orderData['title'],
      'rating': _rating,
      'review': _review,
    });
    // Show a confirmation message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rating and review submitted.'),
      ),
    );
    // Clear rating and review fields
    setState(() {
      _rating = 0.0;
      _review = '';
    });
  }
}
