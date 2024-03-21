import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_2/constant.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  String _currentLocation = 'Fetching location...';

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
      // String thoroughfare = placemark.thoroughfare ?? '';
      // String subThoroughfare = placemark.subThoroughfare ?? '';

      setState(() {
        // Concatenate city, area, and thoroughfare to get the exact location
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            RichText(
              text: TextSpan(
                text: ' Welcome , ',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kprimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20,
                color: kprimaryColor,
              ),
              SizedBox(width: 8),
              Text(
                _currentLocation,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color.fromARGB(255, 129, 105, 105),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
