import 'package:adan_russia/preferences.dart';
import 'package:get/get.dart';
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

void setLocale() {
  print('####################setlocale');
  PreferencesController preferencesController =
      Get.find<PreferencesController>();
  String language = preferencesController.defaultLanguage.value;
  print('language : $language');
  switch (language) {
    case "":
      {
        print('nnnnnnnn');
      }
    case "english":
      Get.updateLocale(const Locale('en', 'US'));
      break;
    case "arabic":
      Get.updateLocale(const Locale('ar', 'AR'));
      break;
    case "russian":
      Get.updateLocale(const Locale('ru', 'RU'));
      break;
    default:
  }
}
