import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/prayer_notification.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:get/get.dart';

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

  late DateTime nextPrayerDateTime;

  late int prayerIndex;
  late DateTime prayerDateTime;

  late final PreferencesController _preferencesController;
  PrayerSchedule() {
    prayers = [];
    _preferencesController = Get.find<PreferencesController>();
  }

  Future<void> init(DateTime date) async {}

  void update() {}

  String getRemainingTime() {
    return now.difference(nextPrayerDateTime).toString().split('.')[0];
  }

  void notifyAdhan() {
    if (_preferencesController.isNotifyAdhan.value &&
        getRemainingTime() == '-0:00:00') {
      PrayerNotification.prayerNotification(
          title: "Hello the world", body: "Pray", payload: "p");
    }
  }

  void notifyIqama() {
    if (_preferencesController.isNotifyIqama.value) {
      PrayerNotification.prayerNotification(
          title: "Hello the world", body: "Pray", payload: "p");
    }
  }
}
