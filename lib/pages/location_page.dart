import 'package:flutter/material.dart';
import 'package:hf_customer_app/controller/location_controller.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
    // String? _currentAddress;
  // Position? _currentPosition;

  final locationController = LocationController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('LAT: '),
              const Text('LNG: '),
              const Text('ADDRESS: '),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // locationController. requestLocationPermission();
                  // locationController.getCurrentLocation();
                  // locationController.getCurrentLocation();
                  // locationController.calculateDinstace();
                  // locationController.requestLocationPermission();
                },
                child: const Text("Get Current Location"),
              ),
            ],
          ),
        ),
      ),
    );
  }


// Future<void> _getCurrentPosition() async {
//   final hasPermission = await locationController.getCurrentLocation();
//   if (!hasPermission) return;
//   await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high)
//       .then((Position position) {
//     setState(() => _currentPosition = position);
//   }).catchError((e) {
//     debugPrint(e);
//   });
// }


}
