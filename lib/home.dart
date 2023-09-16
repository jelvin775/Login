import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class HomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final Map<String, Marker> _markers = {}; // Add this line

  void _getUserLocation() async {
    // Request permission to access the device's location
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle the case when the user denies location access
      // You can show a SnackBar or a dialog to inform the user
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng userLatLng = LatLng(position.latitude, position.longitude);

    // Move the camera to the user's current location
    _goToUserLocation(userLatLng);
  }

  void _goToUserLocation(LatLng latLng) {
    _markers['user_location'] = Marker(
      markerId: MarkerId('user_location'),
      position: latLng,
      infoWindow: InfoWindow(title: 'Your Location'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map App'),
        actions: [
          IconButton(
            icon: Icon(Icons.location_searching),
            onPressed: () => _getUserLocation(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.7749, -122.4194), // Initial map position
                  zoom: 10.0, // Initial zoom level
                ),
                markers: _markers.values.toSet(), // Add this line
                // Add more configurations and markers as needed
              ),
            ),
            ElevatedButton(
              onPressed: () {
                auth.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
