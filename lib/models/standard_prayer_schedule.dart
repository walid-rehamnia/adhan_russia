import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/prayer_schedule.dart';
import 'package:adan_russia/prayer_notification.dart';
import 'package:adan_russia/utils/time_util.dart';
import 'package:adan_russia/utils/utils_location.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class StandardPrayerSchedule extends PrayerSchedule {
  StandardPrayerSchedule() {
    prayers = [];
  }

  @override
  Future<void> init(DateTime date) async {
    print('Standard Prayer Times');
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

    for (String time in todayTimes) {
      print(time);
    }

    prayers.clear();
    for (int i = 0; i < todayTimes.length; i++) {
      prayers.add(MyPrayer(todayTimes[i], PRAYER_NAMES[i], i));
    }
  }

  @override
  void update() {
    now = DateTime.now();
    prayerIndex = prayerTimes.currentPrayer().index;
    //return Ischa (cyclic table in my logic =>Subh comes after ischa in index), If index is 0 return Isha
    currentPrayer = prayerIndex != 0 ? prayers[prayerIndex - 1] : prayers[5];
    //mapping from package indexes to my indexes, if index is 0 return Fadjr
    prayerIndex = prayerTimes.nextPrayer().index;
    nextPrayer = prayerIndex != 0 ? prayers[prayerIndex - 1] : prayers[0];

    // print(nextPrayer.time + ':00');

    for (int i = 0; i < prayers.length; i++) {
      int intPrayerTime =
          intFromTime(DateFormat("HH:mm").parse(prayers[i].time));

      if (intFromTime(now.subtract(IQAMA_DURATION)) <= intPrayerTime) {
        prayers[i].status = "now";
        if (intFromTime(now.subtract(IQAMA_DURATION)) == intPrayerTime) {
          notifyIqama();
        }
        break;
      }
      if (intFromTime(now) > intPrayerTime) {
        prayers[i].status = "passed";
      }
    }

    //always update the current status
    notifyAdhan();
  }
}
