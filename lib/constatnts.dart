import 'package:adan_russia/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'translations/translation_keys.dart' as translation;

const bool IS_CALENDARBASED = true;

const String COLUD_PATH = "calendars/nn_2024.pdf";

const String YEARLY_JSON_FILE_NAME = "2024.json";

const String YEARLY_PDF_FILE_NAME = "2024.pdf";

List<String> PRAYER_NAMES = [
  translation.fadjr.tr,
  translation.sunrise.tr,
  translation.dhuhr.tr,
  translation.asr.tr,
  translation.maghrib.tr,
  translation.isha.tr,
];

const List<String> GREGORIAN_MONTHS = [
  "",
  "January",
  "February",
  "Mars",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

Color MAIN_COLOR = Colors.blue;
