import 'dart:convert';
import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/prayer_schedule.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/utils/time_util.dart';
import 'package:adan_russia/utils/utils_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

//Notes:

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
    print(jsonData.runtimeType);
    if (jsonData == "") {
      //delete the old data if exists (meory best practice and avoid confusion with other year same month)
      //load the yearly data from json file
      List<List<List<String>>> yearlyData = await loadYearlyData();
      //select the current month data and save it to presistent storage
      List<List<String>> monthlyData = yearlyData[currentMonthIndex];
      jsonData = jsonEncode(monthlyData);
      print(jsonData.runtimeType);

      _preferencesController.updatePreference("calendarMonthlyData", jsonData);
    }
    //get daily times from monthly saved data
    List<dynamic> decodedData = jsonDecode(jsonData);
    print(jsonData.runtimeType);

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

  @override
  void update() {
    //Answers the question about the current and next prayer, at the current time
    now = DateTime.now();

    //refrech our calendarer times if they expired
    // if (now.day != calendarDate.day) init(now);

    //1- updating current/next prayer

    int i = 0;

    //"Elses" staements has not been used in the next for loop tests, because each of them contains break statement
    for (i = 0; i < prayers.length; i++) {
      int intPrayerTime =
          intFromTime(DateFormat("HH:mm").parse(prayers[i].time));

      //1- On prayer time, timerange: [current_prayer_time, prayertime+iqamatimeout]
      if (intFromTime(now.subtract(IQAMA_DURATION)) <= intPrayerTime) {
        prayers[i].status = "now";
        currentPrayer = prayers[i];
        //Next prayer is represents current prayer untill the iqama timeout passes
        // (will be used mainly in checkboxes and remaining time later in code)
        nextPrayer = currentPrayer;
        if (intFromTime(now.subtract(IQAMA_DURATION)) == intPrayerTime) {
          notifyIqama();
        }
        break;
      }

      //2- Before Prayer time, timerange: ]previous_prayer_time+iqamatimeout, current_prayer_time[
      if (intFromTime(now) < intPrayerTime) {
        currentPrayer = i > 0 ? prayers[i - 1] : prayers[prayers.length - 1];
        nextPrayer = prayers[i];
        break;
      }

      //3- After prayer time, timerange: ]current_prayer_time+iqamatimeout, next_prayer_time[
      //We can only says that the current prayer has passed
      prayers[i].status = "passed";
    }
    //In user didn't got answer yet, means he came in the range ]isha+iqamatimeout, 00:00[
    //ie,(where isha time greater than subh time)

    durationHours = int.parse(nextPrayer.time.split(":")[0]);
    durationMinutes = int.parse(nextPrayer.time.split(":")[1]);

    if (i == prayers.length) {
      currentPrayer = prayers[prayers.length];
      nextPrayer = prayers[0];

      DateTime tomorrowDateTime = now.add(NEXT_DAY_DURATION);
      nextPrayerDateTime = DateTime(
          tomorrowDateTime.year,
          tomorrowDateTime.month,
          tomorrowDateTime.day,
          durationHours,
          durationMinutes,
          0);
    } else {
      nextPrayerDateTime = DateTime(
          now.year, now.month, now.day, durationHours, durationMinutes, 0);
    }

    notifyAdhan();
  }
}
