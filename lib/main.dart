import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/provider/signupprovider.dart';
import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/screen/home_screen.dart';
import 'package:firebase_2/screen/main_screen.dart';
import 'package:firebase_2/Model/userlocation.dart';
import 'package:firebase_2/view/credentialdetails.dart';
import 'package:firebase_2/view/login.dart';
import 'package:firebase_2/view/otp.dart';
import 'package:firebase_2/view/signup.dart';
import 'package:firebase_2/view/uploadimage.dart';
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
    // fetchPlumberLocations();
    _getCurrentLocation();
    // _fetchData();

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
            home: MainScreen(),
            //  signUpProvider.isUserExist ? MainScreen() : SignUp(),
            //home: Login(),
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
}
