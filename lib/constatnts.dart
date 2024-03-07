import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'translations/translation_keys.dart' as translation;

const bool IS_CALENDARBASED = true;

const String COLUD_PATH = "calendars/nn_2024.pdf";

const String YEARLY_JSON_FILE_NAME = "2024.json";

const String YEARLY_PDF_FILE_NAME = "2024.pdf";

List<String> PRAYER_NAMES = [
  translation.fadjr,
  translation.sunrise,
  translation.dhuhr,
  translation.asr,
  translation.maghreb,
  translation.isha,
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

const int IQAMA_TIME_OUT = 15;

const Duration IQAMA_DURATION = Duration(minutes: -IQAMA_TIME_OUT);
const Duration NEXT_DAY_DURATION = Duration(days: 1);

const MaterialColor? MAIN_COLOR1 = Colors.blueGrey;

Color MAIN_COLOR = Color.fromRGBO(173, 193, 217, 1.0);
const TEXT_COLOR = Colors.black;

BoxDecoration BACKGROUND_SCREEN = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/back.jpg'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
      Colors.black.withOpacity(0.3), // Adjust the opacity here (0.0 to 1.0)
      BlendMode.dstATop,
    ),
  ),
);
