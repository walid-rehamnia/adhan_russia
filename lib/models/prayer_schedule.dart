import 'package:adan_russia/models/prayer.dart';
import 'package:adhan/adhan.dart';

abstract class PrayerSchedule {
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

  Future<void> init(DateTime date) async {}

  void update() {}
}
