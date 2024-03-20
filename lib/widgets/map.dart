import 'package:flutter/material.dart';
import 'package:firebase_2/constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng initialLocation =
      LatLng(37.7749, -122.4194); // San Francisco's coordinates
  final BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  // @override
  // void initState() {
  //   super.initState();
  //   setMarkerIcon();
  // }

  // void setMarkerIcon() async {
  //   markerIcon = await BitmapDescriptor.fromAssetImage(
  //     ImageConfiguration(size: Size(48, 48)),
  //     'assets/v-1.png',
  //   );
  //   if (mounted) setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 12,
        ),
        markers: {
          Marker(
            markerId: MarkerId('YourMarkerId'),
            position: initialLocation,
            icon: markerIcon,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }

  Widget buildOrderDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
        const SizedBox(width: 10),
        Spacer(),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
