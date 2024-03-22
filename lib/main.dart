import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/provider/signupprovider.dart';
import 'package:firebase_2/screen/admin/addcar.dart';
import 'package:firebase_2/screen/admin/edit.dart';
import 'package:firebase_2/screen/admin/order_screen.dart';
import 'package:firebase_2/screen/admin/admin_screen.dart';
import 'package:firebase_2/screen/admin/test.dart';
import 'package:firebase_2/screen/allproduct.dart';
// import 'package:firebase_2/Model/product.dart';
// import 'package:firebase_2/screen/home_screen.dart';
import 'package:firebase_2/screen/main_screen.dart';
import 'package:firebase_2/view/editprofile.dart';
import 'package:firebase_2/view/profile.dart';
import 'package:firebase_2/view/profile1.dart';
import 'package:firebase_2/widgets/Searchpage.dart';
import 'dart:math';
import 'package:firebase_2/widgets/product_card.dart';

import 'package:firebase_2/Model/userlocation.dart';
import 'package:firebase_2/view/login.dart';
import 'package:firebase_2/view/signup.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
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
  static List<double?> productLatitudeList = [];
  static List<double?> productLongitudeList = [];
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
    fetchproductLocations();
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
          return KhaltiScope(
              publicKey: "test_public_key_c2f1d4b63b5245f4992856f1252c3298",
              builder: (context, navKey) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  // home: signUpProvider.isUserExist ? MainScreen() : Login(),

                  // home: AddProductPage()
                  // home:
                  //     // ProductSearch()
                  //     Login()

                  //  signUpProvider.isUserExist ? MainScreen() : SignUp(),
                  // home: signUpProvider.isUserExist ? MainScreen() : Login(),
                  // home: MainScreen(),
                  home: AdminScreen(),
                  // AdminScreen(),
                  navigatorKey: navKey,
                  localizationsDelegates: const [
                    KhaltiLocalizations.delegate,
                  ],
                );
              });
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
    await _fetchproductLocations();
    await _fetchUserLocation();
    _calculateDistance();
  }

  Future<void> _fetchproductLocations() async {
    try {
      QuerySnapshot productSnapshot =
          await FirebaseFirestore.instance.collection('product').get();

      if (productSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot productDocument in productSnapshot.docs) {
          double? latitude = productDocument['latitude'];
          double? longitude = productDocument['longitude'];

          productLatitudeList.add(latitude);
          productLongitudeList.add(longitude);

          print('product Latitude: $latitude');
          print('product Longitude: $longitude');
        }
      } else {
        print('No documents found in the product collection.');
      }
    } catch (e) {
      print('Error fetching product locations: $e');
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
    if (productLatitudeList.isNotEmpty &&
        userLatitude != null &&
        userLongitude != null) {
      for (int i = 0; i < productLatitudeList.length; i++) {
        double? productLatitude = productLatitudeList[i];
        double? productLongitude = productLongitudeList[i];

        if (productLatitude != null && productLongitude != null) {
          double distance = _calculateHaversineDistance(
            productLatitude,
            productLongitude,
            userLatitude!,
            userLongitude!,
          );

          print('Distance from product $i to user: $distance km');

          // Update the Firestore document with the calculated distance
          _updateDistanceInFirestore(i, distance);
        }
      }
    } else {
      print('No product locations available or user location missing.');
    }
  }

  Future<void> _updateDistanceInFirestore(int index, double distance) async {
    try {
      QuerySnapshot productSnapshot =
          await FirebaseFirestore.instance.collection('product').get();

      if (productSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot productDocument = productSnapshot.docs[index];

        await FirebaseFirestore.instance
            .collection('product')
            .doc(productDocument.id)
            .update({'distance': distance});

        print('Distance updated in Firestore for product $index: $distance km');
      } else {
        print('No documents found in the product collection.');
      }
    } catch (e) {
      print('Error updating distance in Firestore: $e');
    }
  }

  Future<void> fetchproductLocations() async {
    try {
      // Fetch documents from the "product" collection
      QuerySnapshot productSnapshot =
          await FirebaseFirestore.instance.collection("product").get();

      // Iterate through each document
      for (QueryDocumentSnapshot productDocument in productSnapshot.docs) {
        // Get the location name from the document
        String locationName = productDocument['location'];

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
              .doc(productDocument.id)
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
      print('Error fetching product locations: $e');
    }
  }
}
