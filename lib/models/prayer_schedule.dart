import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/prayer_notification.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:get/get.dart';

class PrayerSchedule {
  // I've declared some variables hereto reduce for memory efficiency (rather than declaring them on update)
  late PrayerTimes prayerTimes;

  late final List<String> todayTimes;
  late List<MyPrayer> prayers;
  late MyPrayer currentPrayer;
  late MyPrayer nextPrayer;
  late int hours;
  late int minutes;
  late DateTime calendarDate;
  late DateTime now;
  late int prayerIndex;
  late DateTime nextPrayerDateTime;
  late bool isAdanNotified;
  late bool isIqamaNotified;
  int difference = 0;
  late DateTime prayerDateTime;

  late final PreferencesController _preferencesController;
  PrayerSchedule() {
    prayers = [];
    _preferencesController = Get.find<PreferencesController>();
    now = DateTime.now();
    nextPrayerDateTime = now;
    isAdanNotified = false;
    isIqamaNotified = false;
  }

  Future<void> init(DateTime date) async {}

  void update() {}

  String getRemainingTime() {
    return now.difference(nextPrayerDateTime).toString().split('.')[0];
  }

  void notifyAdhan() {
    if (_preferencesController.isNotifyAdhan.value && !isAdanNotified) {
      isAdanNotified = true;
      isIqamaNotified = false;

      PrayerNotification.prayerNotification(
          title: "adanNotificationTitle"
              .trParams({"prayer": currentPrayer.name.tr}),
          // "${currentPrayer.name.tr} = ${currentPrayer.time} ${'about'.tr}",
          body: "",
          payload: "adhan");
    }
  }

  void notifyIqama() {
    if (_preferencesController.isNotifyIqama.value && !isIqamaNotified) {
      isIqamaNotified = true;
      isAdanNotified = false;

      PrayerNotification.prayerNotification(
          title: "iqamaNotificationTitle"
              .trParams({"prayer": currentPrayer.name.tr}),
          body: "",
          payload: "iqama");
    }
  }
}
