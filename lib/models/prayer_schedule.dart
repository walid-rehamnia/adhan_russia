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

  PrayerSchedule() {
    prayers = [];
  }

  Future<void> init(DateTime date) async {}

  void update() {}

  String getRemainingTime() {
    durationHours = int.parse(nextPrayer.time.split(":")[0]);
    durationMinutes = int.parse(nextPrayer.time.split(":")[1]);

    DateTime customDateTime = DateTime(
        now.year, now.month, now.day, durationHours, durationMinutes, 0);
    return now.difference(customDateTime).toString().split('.')[0];
  }
}
