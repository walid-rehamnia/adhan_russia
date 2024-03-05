import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/prayer_schedule.dart';
import 'package:adan_russia/prayer_notification.dart';
import 'package:adan_russia/time_util.dart';
import 'package:adan_russia/utils/utils_location.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class StandardPrayerSchedule extends PrayerSchedule {
  StandardPrayerSchedule() {
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
    now = DateTime.now();
    currentPrayer = prayers[prayerTimes.currentPrayer().index - 1];
    nextPrayer = prayers[prayerTimes.nextPrayer().index - 1];
    // print(nextPrayer.time + ':00');

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
    if (getRemainingTime() == '-0:00:00') {
      PrayerNotification.prayerNotification(
          title: "Hello the world", body: "Pray", payload: "p");
    }
  }
}
