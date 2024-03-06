import 'dart:convert';
import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/prayer_schedule.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/utils/time_util.dart';
import 'package:adan_russia/utils/utils_data.dart';
import 'package:get/get.dart';

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
    // now = DateTime.now();
    now = DateTime(now.year, now.month, now.day, 4, 50, 0);

    //Answers the question about the current and next prayer, at the current time
    int i = 0;

    outerLoop:
    for (i = 0; i < prayers.length; i++) {
      print('foor $i');
      hours = int.parse(prayers[i].time.split(":")[0]);
      minutes = int.parse(prayers[i].time.split(":")[1]);

      difference = getDifference(now.hour, now.minute, hours, minutes);
      print("${prayers[i].name}: $difference");
      switch (difference) {
        case 0:
          {
            print('case 0');
            currentPrayer = prayers[i];
            currentPrayer.status = "now";
            nextPrayer = currentPrayer;
            notifyAdhan();
          }
          break outerLoop;
        case <= IQAMA_TIME_OUT && > 0:
          {
            print('case <= IQAMA_TIME_OUT && > 0');

            currentPrayer = prayers[i];
            // currentPrayer.status = "passed";
            // nextPrayer = prayers[(i + 1) % prayers.length];
            nextPrayer = currentPrayer;
            notifyIqama();
          }
          break outerLoop;
        case < 0:
          {
            print('case <0');

            currentPrayer =
                i > 0 ? prayers[i - 1] : prayers[prayers.length - 1];
            nextPrayer = prayers[i];
          }
          break outerLoop;

        case > IQAMA_TIME_OUT:
          {
            print('case > IQAMA_TIME_OUT');

            prayers[i].status = "passed";
          }
      }
    }

    if (i == prayers.length) {
      print('casssssssssssssssssssss');
      currentPrayer = prayers[prayers.length - 1];
      nextPrayer = prayers[0];

      hours = int.parse(nextPrayer.time.split(":")[0]);
      minutes = int.parse(nextPrayer.time.split(":")[1]);
      DateTime tomorrowDateTime = now.add(NEXT_DAY_DURATION);
      nextPrayerDateTime = DateTime(tomorrowDateTime.year,
          tomorrowDateTime.month, tomorrowDateTime.day, hours, minutes, 0);
    } else {
      nextPrayerDateTime =
          DateTime(now.year, now.month, now.day, hours, minutes, 0);
    }
  }
}
