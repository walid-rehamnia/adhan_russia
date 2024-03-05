import 'dart:async';
import 'dart:io';
import 'package:adan_russia/models/custom_prayer_schedule.dart';
import 'package:adan_russia/prayer_notification.dart';
import 'package:adan_russia/translations/my_translation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:restart_app/restart_app.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../old/background_screen.dart';
import '../old/foreground_screen.dart';

var firstTime = true;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Timer timer;
  late CustomPrayerSchedule prayerSchedule;
  bool visiblityLoader = true;
  var handlerError = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    prayerSchedule = CustomPrayerSchedule();
    prayerSchedule.init(DateTime.now()).then((value) {
      prayerSchedule.update();
      setState(() {
        isLoading = false;
        visiblityLoader = false;
      });
      //Update state every min
      timer = Timer.periodic(
          const Duration(seconds: 1), (Timer t) => _update(prayerSchedule));
    });
  }

  var firstUpdate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: isLoading == true
            ? const CircularProgressIndicator()
            : Stack(
                children: [
                  BackGroundWidget(prayerSchedule.currentPrayer),
                  ForeGroundWidget(prayerSchedule),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: 35,
                        decoration: const BoxDecoration(
                            color: Color(0xcd195251),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      onTap: () {
                        if (Get.locale == const Locale('en', 'EN')) {
                          Get.updateLocale(const Locale('ar', 'AR'));
                        } else {
                          Get.updateLocale(const Locale('en', 'EN'));
                        }
                        // Get.to(() => PDFViewerPage());
                      },
                    ),
                  ),
                  Visibility(
                      visible: visiblityLoader,
                      child: Container(
                          color: Colors.white54,
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                              color: Color(0xFFE26B26)))),
                ],
              ),
      ),
    );
  }

  void _update(CustomPrayerSchedule prayerSchedule) {
    try {
      setState(() {
        prayerSchedule.update();
        print(
            "Update now with next prayer${prayerSchedule.nextPrayer.name} current prayer ${prayerSchedule.currentPrayer.name} reminded time ${prayerSchedule.getRemainingTime()}");
      });
    } catch (e) {
      // Handle errors here
      print("Error updating timer: $e");

      // Show an AlertDialog with the error message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(fontSize: 18),
          ),
          content: Text(e.toString(), style: const TextStyle(fontSize: 12)),
          elevation: 22,
        ),
        barrierDismissible: false,
      );

      // Cancel the timer to prevent further updates
      timer.cancel();
    }
  }
}

const secondTextStyle = TextStyle(color: Color(0xffE26B26));
