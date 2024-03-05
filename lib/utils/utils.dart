import 'package:adan_russia/components.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/utils/utils_location.dart';
import 'package:adan_russia/utils/utils_data.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String formatDuration(int minutes) {
  // Convert minutes to Duration
  Duration duration = Duration(minutes: minutes);
  print('#####');
  print(duration);
  // Extract hours, minutes, and seconds
  int hours = duration.inHours;
  int remainingMinutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  // Format the result as hh:mm:ss
  String formattedDuration =
      '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

  return formattedDuration;
}

Future<void> setTimeMode(String mode) async {
  final PreferencesController preferencesController =
      Get.find<PreferencesController>();

  if (mode == "standard") {
    final Coordinates coordinates = await getCoordinates();

    preferencesController.updatePreference("userLocation",
        getCoordinatesAddress(coordinates.latitude, coordinates.longitude));
    //get location address based by giving coordinates
    final String location = await getCoordinatesAddress(
        coordinates.latitude, coordinates.longitude);

    preferencesController.updatePreference("userLocation", location);
  }
  //else custom mode
  else {
    await checkFirstInstallation();
    preferencesController.updatePreference(
        "userLocation", "Nizhny Novgorod, Russia");
  }
  preferencesController.updatePreference("timingMode", mode);
}
