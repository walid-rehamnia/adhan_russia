import 'dart:async';
import 'dart:ui';

// import 'package:adan_russia/models/custom_prayer_schedule.dart';
// import 'package:adan_russia/models/prayer.dart';
// import 'package:adan_russia/models/prayer_schedule.dart';
// import 'package:adan_russia/models/standard_prayer_schedule.dart';
// import 'package:adan_russia/preferences.dart';
// import 'package:adhan/adhan.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:adan_russia/main.dart';
import 'package:adan_russia/models/prayer_schedule.dart';
import 'package:adan_russia/preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';

// Future<void> initializeMyService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//       iosConfiguration: IosConfiguration(),
//       androidConfiguration: AndroidConfiguration(
//           onStart: myonStart,
//           isForegroundMode: true,
//           autoStart: true,
//           autoStartOnBoot: true));
// }

// @pragma("vm:entry-point")
// void myonStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();

//   late PreferencesController _preferencesController =
//       Get.find<PreferencesController>();

//   late PrayerSchedule _prayerSchedule;
//   _preferencesController = Get.find<PreferencesController>();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//     service.on('stopService').listen((event) {
//       service.stopSelf();
//     });
//   }
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     // if (service is AndroidServiceInstance) {
//     //   if (await service.isForegroundService()) {
//     //     service.setForegroundNotificationInfo(
//     //         title: "Adan Russia", content: "Follow us");
//     //   }
//     // }

//     //perform back opts
//     print('background service running ...');
//     // service.invoke("update");
//   });
// }

// updatePrayers(PreferencesController preferencesController,
//     PrayerSchedule prayerSchedule) async {
//   try {
//     if (preferencesController.timingMode.value == 'custom') {
//       prayerSchedule = CustomPrayerSchedule();
//     } else {
//       prayerSchedule = StandardPrayerSchedule();
//     }

//     prayerSchedule.init(DateTime.now()).then((value) {
//       prayerSchedule.update();
//       late List<MyPrayer> prayers = prayerSchedule.prayers;

//       isTodayCalendar = DateTime.now().day == prayerSchedule.calendarDate.day;
//       setState(() {
//         isLoading = false;
//       });

//       // Update state every min
//       timer = Timer.periodic(
//           const Duration(seconds: 1), (Timer t) => _update(prayerSchedule));
//     });
//   } catch (e) {
//     EasyLoading.showError("Error, $e");
//   }
// }

// // Future<void> startBackgroundTask() async {
// //   await FlutterBackground.enableBackgroundExecution();
// //   await FlutterBackground.initialize();
// //   await FlutterBackground.executeTas((taskId) async {
// //     // Calculate prayer times
// //     var prayerTimes = PrayerTimes('Egypt');
// //     var now = DateTime.now();
// //     var times = prayerTimes.getTimes(now, [
// //       'fajr',
// //       'sunrise',
// //       'dhuhr',
// //       'asr',
// //       'maghrib',
// //       'isha',
// //     ]);

// //     // Example: Notify user for Fajr prayer time
// //     if (now.isBefore(times['fajr'])) {
// //       await showNotification('Fajr Prayer', 'Time for Fajr prayer!');
// //     }

// //     // Implement similar checks for other prayer times

// //     // Return true to keep the background task running
// //     return true;
// //   });
// // }

// Future<void> initBackgroundService() async {
//   try {
//     if (!(await FlutterBackgroundService().isRunning())) {
//       await FlutterBackgroundService(onStart);
//       print('Background service started');
//     } else {
//       print('Background service is already running');
//     }
//   } on PlatformException catch (e) {
//     print('Error: ${e.message}');
//   }
// }

// Future<void> onStart() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final prayerTimes = PrayerTimes('Egypt');

//   await FlutterBackgroundService().sendData({"status": "starting"});
//   Timer.periodic(Duration(minutes: 1), (timer) {
//     final now = DateTime.now();
//     final times = prayerTimes.getTimes(now, [
//       'fajr',
//       'sunrise',
//       'dhuhr',
//       'asr',
//       'maghrib',
//       'isha',
//     ]);

//     if (now.isBefore(times['fajr'])) {
//       // showNotification('Fajr Prayer', 'Time for Fajr prayer!');
//     }

//     // Implement similar checks for other prayer times
//   });
// }

// this will be used as notification channel id
const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> initializeService() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      // autoStartOnBoot: true,
      isForegroundMode: true,

      notificationChannelId:
          notificationChannelId, // this must match with notification channel you created above.
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(),
  );

  PreferencesController myController = PreferencesController();
  await myController
      .loadPreferences(); //to ensure that my preference has been loaded before proceding

  Get.put(myController);
}

// @pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  print('#############################################Now');
  PreferencesController myController = Get.find<PreferencesController>();
  print('#####');
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    print('***');
    // myController.prayerSchedule.update();
    updateTimes(myController.prayerSchedule);
    if (service is AndroidServiceInstance) {
      flutterLocalNotificationsPlugin.show(
        notificationId,
        'Current Prayer',
        'Next prayer : ${myController.timingMode.value}', //
        const NotificationDetails(
          android: AndroidNotificationDetails(
            notificationChannelId,
            'MY FOREGROUND SERVICE',
            icon: 'ic_bg_service_small',
            ongoing: true,
            subText: "Asr",
          ),
        ),
      );
    }
  });
}

void updateTimes(PrayerSchedule prayerSchedule) {
  try {
    prayerSchedule.update();
    // isTodayCalendar = DateTime.now().day == prayerSchedule.calendarDate.day;
  } catch (e) {
    // Handle errors here
    print("Error updating timer: $e");
  }
}
