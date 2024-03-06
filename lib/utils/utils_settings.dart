import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/utils/utils_location.dart';
import 'package:adan_russia/utils/utils_data.dart';
import 'package:adhan/adhan.dart';
import 'package:get/get.dart';

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
