import 'dart:convert';

import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/notifications.dart';
import 'package:adan_russia/time_util.dart';
import 'package:adan_russia/utils_data.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultPrayerSchedule {
  late List<Prayer> prayers;
  late Prayer currentPrayer;
  late Prayer nextPrayer;
  late String remainingTime;

  late DateTime calendarDate;

  DefaultPrayerSchedule() {
    prayers = [];
  }

  Future<void> init(DateTime date) async {
    var prefs = await SharedPreferences.getInstance();
    calendarDate = date;
    //Next 2 indexes used to retrieve data from 0 based index data  structures
    int currentMonthIndex = calendarDate.month - 1;
    int currentDayIndex = calendarDate.day - 1;

    //get daily times from monthly saved data
    String jsonData = prefs.getString('$currentMonthIndex') ?? '[]';
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
      prayers.add(Prayer(todayTimes[i], PRAYER_NAMES[i], i));
    }
  }

  void update() {
    DateTime now = DateTime.now();
    //refrech our calendarer times if they expired
    // if (now.day != calendarDate.day) init(now);

    int i = 0;
    for (i = 0; i < prayers.length; i++) {
      if (intFromTime(now) <=
          intFromTime(DateFormat("HH:mm").parse(prayers[i].time))) {
        nextPrayer = prayers[i];
        remainingTime =
            (intFromTime(DateFormat("HH:mm").parse(prayers[i].time)) -
                    intFromTime(now))
                .toString();
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
    if (int.parse(this.remainingTime) == 0) {
      PrayerNotification.prayerNotification(
          title: "Hello the world", body: "Pray", payload: "p");
    }
  }
}
