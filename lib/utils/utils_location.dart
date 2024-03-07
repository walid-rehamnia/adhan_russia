import 'package:adan_russia/preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

Future<Coordinates> getCoordinates() async {
  try {
    //Function that ensure that coordinates are properly saved on local
    late final Position position;
    late final Coordinates myCoordinates;
    PreferencesController preferencesController =
        Get.find<PreferencesController>();
    final double latitude = preferencesController.positionLatitude.value;
    final double longitude = preferencesController.positionLongitude.value;

    if (latitude != 0.0 && longitude != 0.0) {
      myCoordinates = Coordinates(latitude, longitude);
    } else {
      position = await getGPSPosition();

      preferencesController.updatePreference(
          'positionLatitude', position.latitude);
      preferencesController.updatePreference(
          'positionLongitude', position.longitude);
      myCoordinates = Coordinates(position.latitude, position.longitude);
    }
    return myCoordinates;
  } catch (e) {
    throw Exception('Unable to get user coordinates');
  }
}

Future<Position> getGPSPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.openAppSettings();
    await Geolocator.openLocationSettings();
    // return Future.error('Location services are disabled.');
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
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<String> getCoordinatesAddress(double latitude, double longitude) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);

  // Extract city and country from the first placemark
  String city = placemarks.first.locality ?? "";
  String country = placemarks.first.country ?? "";

  return "$country/$city";
}
