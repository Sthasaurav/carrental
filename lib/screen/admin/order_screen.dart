import 'package:firebase_2/constant.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Map<String, bool> _acceptedMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('booking').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No booking data found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var bookingData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var documentId = snapshot.data!.docs[index].id;

              // Check if booking has been accepted
              bool isAccepted = _acceptedMap[documentId] ?? false;

              // Customize the display according to your needs
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Model: ${bookingData['title']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${bookingData['category']}'),
                      Text('Price: \Rs.${bookingData['price']}'),
                      Text('Vehicle No.: ${bookingData['vehicle_no']}'),
                    ],
                  ),
                  // Add accept button
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle accept action
                      _acceptBooking(documentId);
                      // Update state to mark booking as accepted
                      setState(() {
                        _acceptedMap[documentId] = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAccepted ? Colors.grey : kprimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      isAccepted ? "Accepted" : "Accept",
                      style: TextStyle(
                        fontSize: 14,
                        color: isAccepted ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to accept a booking
  Future<void> _acceptBooking(String documentId) async {
    try {
      // Update the Firestore document with the 'Status' field set to 'accept'
      await FirebaseFirestore.instance
          .collection('booking')
          .doc(documentId)
          .update({'Status': 'accept'});

      print('Booking accepted successfully');
    } catch (e) {
      print('Error accepting booking: $e');
      // Handle error if needed
    }
  }
}
