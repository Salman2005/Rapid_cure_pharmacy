// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/constants.dart';

class AuthController {
  Geolocator geolocator = Geolocator();

  final _auth = FirebaseAuth.instance;

  Future<void> checkUserExistence(BuildContext context) async {
    LocationPermission permission;

    // Test if location services are enabled.
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (_auth.currentUser == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, loginScreenRoute, (route) => false);

      return;
    }
    if (kDebugMode) {
      print(_auth.currentUser!.email.toString());
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("currentUserEmail", _auth.currentUser!.email.toString());

    Navigator.pushNamedAndRemoveUntil(
        context, homeScreenRoute, (route) => false,
        arguments: LatLng(currentPosition.latitude, currentPosition.longitude));
  }
}
