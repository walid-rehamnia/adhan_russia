import 'dart:convert';

import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/prayer_schedule.dart';
import 'package:adan_russia/prayer_notification.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/time_util.dart';
import 'package:adan_russia/utils_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CustomPrayerSchedule extends PrayerSchedule {
  CustomPrayerSchedule() {
    prayers = [];
  }

  Future<void> init(DateTime date) async {
    final PreferencesController _preferencesController =
        Get.find<PreferencesController>();

    calendarDate = date;
    //Next 2 indexes used to retrieve data from 0 based index data  structures
    int currentMonthIndex = calendarDate.month - 1;
    int currentDayIndex = calendarDate.day - 1;

    //Download calendar if doesn't exist/expired
    String year = _preferencesController.calendarYear.value;
    if (year != calendarDate.year.toString()) {
      await downloadCalendarData("Nizhny_Novgorod");
      _preferencesController.updatePreference(
          "userLocation", "Nizhny Novgorod, Russia");
    }

    //Load current month data if it doesn't exist
    String jsonData = _preferencesController.calendarMonthlyData.value;

    if (jsonData == "") {
      //delete the old data if exists (meory best practice and avoid confusion with other year same month)
      //load the yearly data from json file
      List<List<List<String>>> yearlyData = await loadYearlyData();
      //select the current month data and save it to presistent storage
      List<List<String>> monthlyData = yearlyData[currentMonthIndex];
      jsonData = jsonEncode(monthlyData);
      _preferencesController.updatePreference("calendarMonthlyData", jsonData);
    }

    //get daily times from monthly saved data
    List<dynamic> decodedData = jsonDecode(jsonData);

    decodedData = decodedData
        .map((innerList) => (innerList as List<dynamic>)
            .map((element) => element.toString())
            .toList())
        .toList();
    List<String> todayTimes = decodedData[currentDayIndex];

    //ensure the avoidness of prayers before adding to it
    prayers.clear();
    for (int i = 0; i < todayTimes.length; i++) {
      prayers.add(MyPrayer(todayTimes[i], PRAYER_NAMES[i], i));
    }
  }

  void update() {
    now = DateTime.now();
    //refrech our calendarer times if they expired
    // if (now.day != calendarDate.day) init(now);

    int i = 0;
    for (i = 0; i < prayers.length; i++) {
      if (intFromTime(now) <=
          intFromTime(DateFormat("HH:mm").parse(prayers[i].time))) {
        nextPrayer = prayers[i];
        currentPrayer = i > 0 ? prayers[i - 1] : prayers[prayers.length - 1];
        break;
      } else {
        prayers[i].status = "passed";
      }
    }
    //In case I didn't found current/next prayer yet
    if (i == prayers.length) {
      currentPrayer = prayers[5];
      nextPrayer = prayers[0];
    }

    //always update the current status
    currentPrayer.status = "now";
    if (int.parse(this.getRemainingTime()) == 0) {
      PrayerNotification.prayerNotification(
          title: "Hello the world", body: "Pray", payload: "p");
    }
  }
}
