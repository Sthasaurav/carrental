import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/provider/signupprovider.dart';
import 'package:firebase_2/screen/admin/addcar.dart';
import 'package:firebase_2/screen/admin/order_screen.dart';
import 'package:firebase_2/screen/admin/admin_screen.dart';
// import 'package:firebase_2/Model/product.dart';
// import 'package:firebase_2/screen/home_screen.dart';
import 'package:firebase_2/screen/main_screen.dart';
import 'dart:math';

import 'package:firebase_2/Model/userlocation.dart';
import 'package:firebase_2/view/login.dart';
import 'package:firebase_2/view/signup.dart';
// import 'package:firebase_2/view/credentialdetails.dart';
// import 'package:firebase_2/view/login.dart';
// import 'package:firebase_2/view/otp.dart';
// import 'package:firebase_2/view/signup.dart';
// import 'package:firebase_2/view/uploadimage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static double? _latitude;
  static double? _longitude;
  String? _locationName;
  static List<double?> plumberLatitudeList = [];
  static List<double?> plumberLongitudeList = [];
  static double? userLatitude;
  static double? userLongitude;
  late bool isUserExist;

  @override
  void initState() {
    NotificationSetting();
    listenNotification();

    super.initState();
    readValueFromSharedPreferences();

    requestLocationPermission();
    super.initState();
    // notificationSetting();
    listenNotification();
    fetchPlumberLocations();
    _getCurrentLocation();
    _fetchData();

    //  readValueFromSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignUpProvider>(
          create: (_) => SignUpProvider(),
        ),
      ],
      child: Consumer<SignUpProvider>(
        builder: (context, signUpProvider, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              // home: signUpProvider.isUserExist ? MainScreen() : Login(),

              home: AddProductPage()
              // home: MainScreen()

              //  signUpProvider.isUserExist ? MainScreen() : SignUp(),
              // home: signUpProvider.isUserExist ? SignUp() : Login(),
              );
        },
      ),
    );
  }

  Future<void> readValueFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isUserExist = prefs.getBool('isUserExist') ?? false;
    });
  }

  NotificationSetting() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  listenNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message);
    });
  }

  getToken() async {
    String? token = await messaging.getToken();
  }

  void requestLocationPermission() async {
    // Check if location permission is granted
    var status = await Permission.location.status;
    if (status.isDenied) {
      // If location permission is not granted, request it
      await Permission.location.request();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print("Location permission denied by user.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      print("Current Position: $position");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationName = placemarks.isNotEmpty
            ? placemarks[0].name
            : "Location Name Not Available";
      });

      // Push latitude and longitude to Firestore
      _pushLocationToFirestore();
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> _pushLocationToFirestore() async {
    try {
      Userlocation userLocation = Userlocation(
          latitude: _latitude.toString(), longitude: _longitude.toString());

      // Check if document already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("userLocations")
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the existing document
        await querySnapshot.docs.first.reference.update(userLocation.toJson());
      } else {
        // Document doesn't exist, add a new one
        await FirebaseFirestore.instance.collection("userLocations").add(
              userLocation.toJson(),
            );
      }

      print(
          'Location pushed to Firestore: Latitude $_latitude, Longitude $_longitude');
    } catch (e) {
      print('Error pushing location to Firestore: $e');
    }
  }

  Future<void> _fetchData() async {
    await _fetchPlumberLocations();
    await _fetchUserLocation();
    _calculateDistance();
  }

  Future<void> _fetchPlumberLocations() async {
    try {
      QuerySnapshot plumberSnapshot =
          await FirebaseFirestore.instance.collection('product').get();

      if (plumberSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot plumberDocument in plumberSnapshot.docs) {
          double? latitude = plumberDocument['latitude'];
          double? longitude = plumberDocument['longitude'];

          plumberLatitudeList.add(latitude);
          plumberLongitudeList.add(longitude);

          print('Plumber Latitude: $latitude');
          print('Plumber Longitude: $longitude');
        }
      } else {
        print('No documents found in the plumber collection.');
      }
    } catch (e) {
      print('Error fetching plumber locations: $e');
    }
  }

  Future<void> _fetchUserLocation() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('userLocations')
          .doc('7gnZ0ehsueKGu2VZuXER')
          .get();

      if (userSnapshot.exists) {
        userLatitude = double.tryParse(userSnapshot['latitude'].toString());
        userLongitude = double.tryParse(userSnapshot['longitude'].toString());

        print('User Latitude: $userLatitude');
        print('User Longitude: $userLongitude');
      } else {
        print('No document found in the userLocations collection.');
      }
    } catch (e) {
      print('Error fetching user location: $e');
    }
  }

  double _calculateHaversineDistance(double startLatitude,
      double startLongitude, double endLatitude, double endLongitude) {
    const double radius = 6371.0; // Earth's radius in kilometers
    double dLat = _toRadians(endLatitude - startLatitude);
    double dLon = _toRadians(endLongitude - startLongitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radius * c;

    // Format the distance to two decimal points
    return double.parse(distance.toStringAsFixed(2));
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  void _calculateDistance() {
    if (plumberLatitudeList.isNotEmpty &&
        userLatitude != null &&
        userLongitude != null) {
      for (int i = 0; i < plumberLatitudeList.length; i++) {
        double? plumberLatitude = plumberLatitudeList[i];
        double? plumberLongitude = plumberLongitudeList[i];

        if (plumberLatitude != null && plumberLongitude != null) {
          double distance = _calculateHaversineDistance(
            plumberLatitude,
            plumberLongitude,
            userLatitude!,
            userLongitude!,
          );

          print('Distance from plumber $i to user: $distance km');

          // Update the Firestore document with the calculated distance
          _updateDistanceInFirestore(i, distance);
        }
      }
    } else {
      print('No plumber locations available or user location missing.');
    }
  }

  Future<void> _updateDistanceInFirestore(int index, double distance) async {
    try {
      QuerySnapshot plumberSnapshot =
          await FirebaseFirestore.instance.collection('product').get();

      if (plumberSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot plumberDocument = plumberSnapshot.docs[index];

        await FirebaseFirestore.instance
            .collection('product')
            .doc(plumberDocument.id)
            .update({'distance': distance});

        print('Distance updated in Firestore for plumber $index: $distance km');
      } else {
        print('No documents found in the plumber collection.');
      }
    } catch (e) {
      print('Error updating distance in Firestore: $e');
    }
  }

  Future<void> fetchPlumberLocations() async {
    try {
      // Fetch documents from the "plumber" collection
      QuerySnapshot plumberSnapshot =
          await FirebaseFirestore.instance.collection("product").get();

      // Iterate through each document
      for (QueryDocumentSnapshot plumberDocument in plumberSnapshot.docs) {
        // Get the location name from the document
        String locationName = plumberDocument['location'];

        // Append ", Nepal" to the location name
        String locationNameNepal = '$locationName, Nepal';

        // Add "Cooma, Nepal" to the location name
        String locationNameCoomaNepal = '$locationNameNepal';

        // Find the longitude and latitude for the modified location name
        List<Location> locations =
            await locationFromAddress(locationNameCoomaNepal);

        if (locations.isNotEmpty) {
          double latitude = locations.first.latitude;
          double longitude = locations.first.longitude;

          // Update the Firestore document with latitude and longitude
          await FirebaseFirestore.instance
              .collection("product")
              .doc(plumberDocument.id)
              .update({
            'latitude': latitude,
            'longitude': longitude,
          });

          print('Location: $locationNameCoomaNepal');
          print('Latitude: $latitude');
          print('Longitude: $longitude');
        } else {
          print('Location not found: $locationNameCoomaNepal');
        }
      }
    } catch (e) {
      print('Error fetching plumber locations: $e');
    }
  }
}
