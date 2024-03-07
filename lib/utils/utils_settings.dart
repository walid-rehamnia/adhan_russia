import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/utils/utils_location.dart';
import 'package:adan_russia/utils/utils_data.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

void updateDefaultLanguage(String? newLanguage) {
  final PreferencesController preferencesController =
      Get.find<PreferencesController>();
  if (newLanguage == "en".tr) {
    Get.updateLocale(const Locale('en', 'US'));

    preferencesController.updatePreference("defaultLanguage", "en");
  } else if (newLanguage == 'ar'.tr) {
    Get.updateLocale(const Locale('ar', 'AR'));
    preferencesController.updatePreference("defaultLanguage", "ar");
  } else {
    Get.updateLocale(const Locale('ru', 'RU'));
    preferencesController.updatePreference("defaultLanguage", "ru");
  }
}

Future<String> updateUserLocation() async {
  Position position = await getGPSPosition();

  PreferencesController preferencesController =
      Get.find<PreferencesController>();

  preferencesController.updatePreference('positionLatitude', position.latitude);
  preferencesController.updatePreference(
      'positionLongitude', position.longitude);

  String address =
      await getCoordinatesAddress(position.latitude, position.longitude);

  return address;
}

void setCalculationMethod(String calculationMethod) {
  print('updating$calculationMethod');
  PreferencesController preferencesController =
      Get.find<PreferencesController>();
  preferencesController.updatePreference(
      "calculationMethod", calculationMethod);
}

CalculationParameters getCalculationParameters() {
  String calculationMethod =
      Get.find<PreferencesController>().calculationMethod.value;

  switch (calculationMethod) {
    case "dubai":
      return CalculationMethod.dubai.getParameters();
    case "egyptian":
      return CalculationMethod.egyptian.getParameters();
    case "karachi":
      return CalculationMethod.karachi.getParameters();
    case "kuwait":
      return CalculationMethod.kuwait.getParameters();
    case "moon_sighting_committee":
      return CalculationMethod.moon_sighting_committee.getParameters();
    case "muslim_world_league":
      return CalculationMethod.muslim_world_league.getParameters();
    case "qatar":
      return CalculationMethod.qatar.getParameters();
    case "tehran":
      return CalculationMethod.tehran.getParameters();
    case "turkey":
      return CalculationMethod.turkey.getParameters();
    case "umm_al_qura":
      return CalculationMethod.umm_al_qura.getParameters();
    case "other":
      return CalculationMethod.other.getParameters();
    default: //include northamerica choice and any unexpected other choice
      return CalculationMethod.north_america.getParameters();
  }
}
