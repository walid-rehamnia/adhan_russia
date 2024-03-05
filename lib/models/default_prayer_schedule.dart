import 'dart:convert';

import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/prayer_schedule.dart';
import 'package:adan_russia/prayer_notification.dart';
import 'package:adan_russia/time_util.dart';
import 'package:adan_russia/utils/utils_location.dart';
import 'package:adan_russia/utils_data.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class DefaultPrayerSchedule extends PrayerSchedule {
  late PrayerTimes prayerTimes;

  late final List<String> todayTimes;
  late List<MyPrayer> prayers;
  late MyPrayer currentPrayer;
  late MyPrayer nextPrayer;
  late String remainingTime;

  late DateTime calendarDate;

  DefaultPrayerSchedule() {
    prayers = [];
  }
  @override
  Future<void> init(DateTime date) async {
    print('My Prayer Times');
    calendarDate = date;
    final Coordinates myCoordinates = await getCoordinates();
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;
    prayerTimes = PrayerTimes.today(myCoordinates, params);

    // final nyUtcOffset = Duration(hours: 3);
    // final nyDate = DateComponents(2024, 3, 5);
    // final nyParams = CalculationMethod.north_america.getParameters();
    // nyParams.madhab = Madhab.hanafi;
    // prayerTimes =
    //     PrayerTimes(myCoordinates, nyDate, nyParams, utcOffset: nyUtcOffset);

    print(
        "---Today's Prayer Times in Your Local Timezone:(${prayerTimes.fajr.timeZoneName})---");
    print(prayerTimes);
    todayTimes = [
      DateFormat.Hm().format(prayerTimes.fajr),
      DateFormat.Hm().format(prayerTimes.sunrise),
      DateFormat.Hm().format(prayerTimes.dhuhr),
      DateFormat.Hm().format(prayerTimes.asr),
      DateFormat.Hm().format(prayerTimes.maghrib),
      DateFormat.Hm().format(prayerTimes.isha),
    ];
    prayers.clear();
    for (int i = 0; i < todayTimes.length; i++) {
      prayers.add(MyPrayer(todayTimes[i], PRAYER_NAMES[i], i));
    }
  }

  @override
  void update() {
    DateTime now = DateTime.now();
    currentPrayer = prayers[prayerTimes.currentPrayer().index - 1];
    nextPrayer = prayers[prayerTimes.nextPrayer().index - 1];
    remainingTime = (intFromTime(DateFormat("HH:mm").parse(nextPrayer.time)) -
            intFromTime(now))
        .toString();

    int i = 0;
    for (i = 0; i < prayers.length; i++) {
      if (intFromTime(now) ==
          intFromTime(DateFormat("HH:mm").parse(prayers[i].time))) {
        prayers[i].status = "now";
      } else if (intFromTime(now) >
          intFromTime(DateFormat("HH:mm").parse(prayers[i].time))) {
        prayers[i].status = "passed";
      }
    }

    //always update the current status
    currentPrayer.status = "now";
    if (int.parse(remainingTime) == 0) {
      PrayerNotification.prayerNotification(
          title: "Hello the world", body: "Pray", payload: "p");
    }
  }
}
