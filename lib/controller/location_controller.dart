// import 'dart:ffi';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:hf_customer_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationController {

  //!! The handle location permission works good  tested it on android/ios/web for now i use just fetch all the restaurants to complete faster the MVP.
  // TODO Optimize this later.
  Future<bool> handleLocationPermission() async {
    var accuracy = await Geolocator.getLocationAccuracy();
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // Position position = await Geolocator.getCurrentPosition(locationSettings: accuracy. );

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and  request users of the
      // App to enable the location services.
         return false;

      // return Future.error('Location services are disabled.');
      //* Mabye use instead a snackbar errors
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

         return false;
        //* Mabye here also a snackbar insteadss
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
     
     
         return false;
      // return Future.error(
      //   'Location permissions are permanently denied, we cannot request permissions.',
      // );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();
    return true;
  }


// Future<void> getLocation() async {
//   final hasPermission = await handleLocationPermission();
//   if (!hasPermission) return;
//   await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high)
//       .then((Position position) {
//     setState(() => _currentPosition = position);
//   }).catchError((e) {
//     debugPrint(e);
//   });
// }



  // Future<List<double>> getLocation() async {


  // final hasPermission = await handleLocationPermission(); 

  //     if(!hasPermission) return; 
  //   final LocationSettings locationSettings = const LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 100,
  //   );
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       locationSettings: locationSettings,
  //     );

  //   // final userLocation = position.latitude, P
  //   final latitude = position.latitude;
  //   final longitude = position.longitude;

 
  //    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  
  //   // return latitude, longitude;

  //   return [latitude, longitude];
  //   } catch (e) {
  //     print(e);
  //     // return "Er ging iets mis probeer het opnieuw";
  //     return [];
  //   }
  // }




void convertAddress()  async {

//  final test = supabase.from('restaurant').stream(primaryKey: ['id']).gte('', value)
  


}

  Future<LocationPermission> requestLocationPermission() async {
    // LocationPermission permission = await Geolocator.requestPermission();
    return await Geolocator.requestPermission();
  }

  Future<bool> isLocationServiceEnabled() async {
    // bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();

    return await Geolocator.isLocationServiceEnabled();
  }



}
