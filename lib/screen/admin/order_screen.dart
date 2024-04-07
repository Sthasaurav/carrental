import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/constant.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Map<String, bool> _acceptedMap;

  @override
  void initState() {
    super.initState();
    _acceptedMap = {}; // Initialize the accepted map
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscaffoldColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Admin , ',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Booking Notifications",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(child: _buildBookingList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingList() {
    return StreamBuilder<QuerySnapshot>(
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

            bool isAccepted = _acceptedMap[documentId] ?? false;

            // Convert selectedDate timestamp to DateTime object
            DateTime selectedDate = (bookingData['selectedDate'] as Timestamp)
                .toDate(); // Assuming 'selectedDate' field exists

            return Card(
              margin: EdgeInsets.all(8.0),
              color: kcontentColor,
              child: ListTile(
                title: Text('Model: ${bookingData['title']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From: ${bookingData['from']}'),

                    Text('Category: ${bookingData['category']}'),
                    Text('Price: \Rs.${bookingData['price']}'),
                    Text(
                        'Vehicle No.: ${bookingData['vehicleNumber'].toString().replaceAll(".0", "")}'), // Remove .0
                    Text("Client's Location: ${bookingData['userlocation']}"),

                    Text(
                        'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'), // Display only date
                  ],
                ),
                // trailing: ElevatedButton(
                //   onPressed:
                //       isAccepted ? null : () => _acceptBooking(documentId),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: isAccepted ? Colors.grey : kprimaryColor,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //   ),
                //   child: Text(
                //     isAccepted ? "Accepted" : "Accept",
                //     style: TextStyle(
                //       fontSize: 14,
                //       color: isAccepted ? Colors.black : Colors.white,
                //     ),
                //   ),
                // ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _acceptBooking(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('booking')
          .doc(documentId)
          .update({'Status': 'accept'});

      setState(() {
        _acceptedMap[documentId] = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking accepted successfully')),
      );
    } catch (e) {
      print('Error accepting booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept booking')),
      );
    }
  }
}
