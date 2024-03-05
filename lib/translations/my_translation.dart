import 'package:adan_russia/preferences.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

import 'ar.dart';
import 'en.dart';
import 'ru.dart';
import 'package:flutter/material.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': En().messages,
        'ar_AR': Ar().messages,
        'ru_RU': Ar().messages,
      };
}

List<String> supportedLocales = [
  'ar',
  'en',
  'ru'
]; // Add more languages as needed

List<Locale> getSupportedLocales() {
  return MyTranslations().keys.keys.map((localeKey) {
    final parts = localeKey.split('_');
    return Locale(parts[0], parts[1]);
  }).toList();
}

Future<void> setLocale() async {
  print('setLocale');
  var prefs = await SharedPreferences.getInstance();

  PreferencesController preferencesController =
      Get.find<PreferencesController>();
  if (preferencesController.locale.value != "") {
    Get.updateLocale(Locale(preferencesController.locale.value!));
  } else {
    Get.updateLocale(Locale('en', 'US'));
  }
}
