import 'package:adan_russia/models/prayer.dart';
import 'package:adhan/adhan.dart';

class PrayerSchedule {
  late PrayerTimes prayerTimes;

  late final List<String> todayTimes;
  late List<MyPrayer> prayers;
  late MyPrayer currentPrayer;
  late MyPrayer nextPrayer;
  late int durationHours;
  late int durationMinutes;
  late DateTime calendarDate;
  late DateTime now; // I've declared it here to reduce for memory efficiency
  late int prayerIndex;
  late DateTime prayerDateTime;

  PrayerSchedule() {
    prayers = [];
  }

  Future<void> init(DateTime date) async {}

  void update() {}

  String getRemainingTime() {
    durationHours = int.parse(nextPrayer.time.split(":")[0]);
    durationMinutes = int.parse(nextPrayer.time.split(":")[1]);

    if (nextPrayer.index == 0) {
      DateTime tomorrowDateTime = now.add(Duration(days: 1));
      prayerDateTime = DateTime(tomorrowDateTime.year, tomorrowDateTime.month,
          tomorrowDateTime.day, durationHours, durationMinutes, 0);
    } else {
      prayerDateTime = DateTime(
          now.year, now.month, now.day, durationHours, durationMinutes, 0);
    }

    //if Subh

    return now.difference(prayerDateTime).toString().split('.')[0];
  }
}
