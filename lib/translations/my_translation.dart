import 'package:adan_russia/preferences.dart';
import 'package:get/get.dart';
// import 'dart:ui' as ui;
import 'dart:io';

import 'ar.dart';
import 'en.dart';
import 'ru.dart';
import 'package:flutter/material.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': En().messages,
        'ar': Ar().messages,
        'ru': Ar().messages,
      };
}

List<Locale> getSupportedLocales() {
  return MyTranslations().keys.keys.map((localeKey) {
    final parts = localeKey.split('_');
    return Locale(parts[0], parts[1]);
  }).toList();
}

List<String> getSupportedLanguages() {
  return MyTranslations().keys.keys.map((localeKey) {
    return localeKey.tr;
  }).toList();
}

// void setLocale() {
//   PreferencesController preferencesController =
//       Get.find<PreferencesController>();
//   String language = preferencesController.defaultLanguage.value;
//   // language=language:
//   switch (language) {
//     case "english":
//       Get.updateLocale(const Locale('en', 'US'));
//       break;
//     case "arabic":
//       Get.updateLocale(const Locale('ar', 'AR'));
//       break;
//     case "russian":
//       Get.updateLocale(const Locale('ru', 'RU'));
//       break;
//     default:
//       Get.updateLocale(const Locale('en', 'US'));
//   }
// }

void initDefaultLanguage() {
  PreferencesController preferencesController =
      Get.find<PreferencesController>();
  String language = preferencesController.defaultLanguage.value;
  //If saved language is null, get the one of the device
  language = language != "" ? language : Platform.localeName.split("_")[0];

  language = getSupportedLanguages().contains(language.tr) ? language : "en";

  Get.updateLocale(Locale(language, language.toUpperCase()));

  if (preferencesController.defaultLanguage.value != language) {
    preferencesController.updatePreference("defaultLanguage", language);
  }
}
