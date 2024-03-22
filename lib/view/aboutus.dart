import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Center(
              child: Text(
                'About Us',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Welcome to Urban Drive, your premier destination for hassle-free car rentals. At Urban Drive, we believe in providing our customers with convenient and reliable transportation solutions tailored to their needs.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'With years of experience in the automotive industry, we understand the importance of flexibility, affordability, and quality service. Whether you\'re traveling for business or pleasure, we\'re here to ensure your journey is smooth and enjoyable.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Our extensive fleet of vehicles includes a wide range of models, from compact cars perfect for urban adventures to spacious SUVs ideal for family road trips. Each vehicle in our fleet is meticulously maintained and undergoes rigorous inspection to guarantee your safety and comfort on the road.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'At Urban Drive, customer satisfaction is our top priority. Our dedicated team of professionals is committed to providing personalized assistance every step of the way, from helping you choose the right vehicle to offering 24/7 support throughout your rental experience.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Convenience is key, which is why we offer flexible booking options, including online reservations and in-app bookings. With transparent pricing and no hidden fees, you can trust us to provide transparent and affordable rental solutions.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Whether you\'re exploring a new city, embarking on a weekend getaway, or simply need a reliable vehicle for your daily commute, Urban Drive has you covered. Experience the freedom of the open road with confidence and ease.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Thank you for choosing Urban Drive. We look forward to being your trusted partner in all your transportation needs.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
