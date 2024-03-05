import 'package:adan_russia/controllers.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/custom_prayer_schedule.dart';
import 'package:adan_russia/screens/about_page.dart';
import 'package:adan_russia/screens/calendar_screen2.dart';
import 'package:adan_russia/screens/pdf_page.dart';
import 'package:adan_russia/screens/settings_page.dart';
import 'package:adan_russia/screens/count_down.dart';
import 'package:adan_russia/screens/choice_screen.dart';
import 'package:adan_russia/translations/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:adan_russia/screens/calender_screen.dart';
import 'package:adan_russia/time_util.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'old/data.dart';

import 'package:jhijri/_src/_jHijri.dart';
import 'package:jhijri/jHijri.dart';

Widget cardWidget(BuildContext context, double screenHeight, double screenWidth,
        PrayerSchedule) =>
    Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4,
      margin: const EdgeInsets.only(right: 15, left: 15),
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0xffE5E5E5),
            image: DecorationImage(
                image: AssetImage("assets/card_background.png"),
                fit: BoxFit.cover)),
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            Text(
                "${JHijri.now().dayName} ${JHijri.now().day} ${JHijri.now().monthName} ${JHijri.now().year}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Amiri",
                  fontSize: 20,
                ),
                textDirection: TextDirection.rtl),
            FittedBox(
                child: listOfTimes(
                    PrayerSchedule.prayers, screenHeight, screenWidth)),
            const SizedBox(height: 15),
            Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                child: Text(
                    " ${getNewHadith().title} \n ${getNewHadith().body}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: "Amiri", fontSize: 18),
                    textDirection: TextDirection.rtl),
              ),
            ))
          ],
        ),
      ),
    );

Widget loaderWidget(double screenHeight, CustomPrayerSchedule prayerSchedule) =>
    SizedBox(
      height: screenHeight / 3.5,
      child: FittedBox(
        child: CircularPercentIndicator(
          radius: 80.0,
          progressColor: Colors.white,
          lineWidth: 13.0,
          backgroundWidth: 10.0,
          percent: progress(prayerSchedule.currentPrayer.time,
              prayerSchedule.nextPrayer.time),
          center: insideLoader(prayerSchedule.remainingTime.toString(),
              prayerSchedule.nextPrayer.name),
          animation: !firstTime,
          animationDuration: 3000,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: const Color(0xffc6b7d2),
        ),
      ),
    );

Widget insideLoader(String reminderTime, String nextPrayerTitle) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          reminderTime,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ), //Reminding time
        Text(nextPrayerTitle,
            style: const TextStyle(
                color: Colors.white, fontSize: 18)) //Next prayer
      ],
    );

Widget timeWithTitle(MyPrayer prayer, double screenHeight) {
  return Container(
    margin: EdgeInsets.only(top: screenHeight / 55, bottom: screenHeight / 55),
    child: Column(
      children: [
        Row(
          children: [
            //Time widget
            Container(
              alignment: Alignment.centerLeft,
              width: 55,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: amPm(prayer.time),
              ),
            ),
            const SizedBox(width: 4),
            //Title widget
            Container(
                alignment: Alignment.centerRight,
                width: 55,
                child: FittedBox(
                    child: Text(prayer.name,
                        style: const TextStyle(
                            color: Color(0xFFE26B26), fontSize: 24)))),
          ],
        ),
        // if (prayer.selected)
        //   Container(width: 92, height: 2.3, color: const Color(0xFFE26B26))
      ],
    ),
  );
}

Widget listOfTimes(
    List<MyPrayer> prayers, double screenHeight, double screenWidth) {
  return Row(
    children: [
      Column(
          children: [prayers[1], prayers[3], prayers[5]]
              .map((e) => timeWithTitle(e, screenHeight))
              .toList()),
      SizedBox(width: screenWidth / 7.5),
      Column(
          children: [prayers[0], prayers[2], prayers[4]]
              .map((e) => timeWithTitle(e, screenHeight))
              .toList()),
    ],
  );
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  final BottomNavigationController _controller =
      Get.put(BottomNavigationController());
  // Initialize the controller
  final List<Widget> pages = [
    const CalendarScreen(),
    ChoiceScreen(),
    PrayerScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[_controller.selectedIndex.value]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_accessibility_rounded),
            label: "settings".tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_notifications_rounded),
            label: 'about'.tr,
          ),
        ],
        currentIndex: _controller.selectedIndex.value,
        onTap: (index) {
          setState(() {
            _controller.changePage(index);
          });
        },
      ),
    );
  }
}
