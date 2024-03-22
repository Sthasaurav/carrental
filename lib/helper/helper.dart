import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  static backdropFilter(context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
      child: SafeArea(
          child: Stack(
        children: [
          const Center(
            child: SpinKitCircle(
              color: Colors.blue,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0),
          ),
        ],
      )),
    );
  }

  static snackBarMessage(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static CheckInternetConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }

  static launchMaps(String address) async {
    final query = Uri.encodeComponent(address);
    final url = "https://www.google.com/maps/search/?api=1&query=$query";
    try {
      await launch(url);
    } catch (e) {
      print(e);
    }
  }
}
