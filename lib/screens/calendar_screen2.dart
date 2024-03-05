import 'dart:async';

import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/models/standard_prayer_schedule.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/custom_prayer_schedule.dart';
import 'package:adan_russia/models/prayer_schedule.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/screens/pdf_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jhijri/_src/_jHijri.dart';

class PrayerScreen extends StatefulWidget {
  @override
  _PrayerScreenState createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  late Timer timer;
  bool isLoading = true;
  late List<MyPrayer> prayers;
  late bool isTodayCalendar;
  late PrayerSchedule _prayerSchedule;
  late PreferencesController _preferencesController;
  late final String timingMode;

  @override
  void initState() {
    super.initState();
    _preferencesController = Get.find<PreferencesController>();
    timingMode = _preferencesController.timingMode.value;
    if (timingMode == 'custom') {
      _prayerSchedule = CustomPrayerSchedule();
    } else {
      _prayerSchedule = StandardPrayerSchedule();
    }

    _prayerSchedule.init(DateTime.now()).then((value) {
      _prayerSchedule.update();
      prayers = _prayerSchedule.prayers;

      isTodayCalendar = DateTime.now().day == _prayerSchedule.calendarDate.day;
      setState(() {
        isLoading = false;
      });

      // Update state every min
      timer = Timer.periodic(
          const Duration(seconds: 1), (Timer t) => _update(_prayerSchedule));
    });
  }

  // Index to keep track of the current day
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.9;
    double containerHeight = MediaQuery.of(context).size.height * 0.6;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const CircularProgressIndicator(color: Color(0xFFE26B26))
            : Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/${_prayerSchedule.currentPrayer.index}.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(
                          1), // Adjust the opacity here (0.0 to 1.0)
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.location_on,
                                color: MAIN_COLOR,
                                size: 30.0,
                              ),
                            ),
                            Text(_preferencesController.userLocation.value),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "${_prayerSchedule.getRemainingTime()}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MAIN_COLOR,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      // Left and right arrow buttons for navigation

                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      // Display the DataTable
                      Container(
                          width: containerWidth,
                          height: containerHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/back3.jpg'), // Replace with your image asset
                              fit: BoxFit.cover,

                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(
                                    0.5), // Adjust the opacity here (0.0 to 1.0)
                                BlendMode.dstATop,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              this.timingMode == 'custom'
                                  ? customCalendarHeader()
                                  : defaultCalendarHeader(),
                              SizedBox(height: 10),
                              DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text('Prayer'),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Container(
                                      child: Text('Adhan time'),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text('Is passed'),
                                    numeric: true,
                                  ),
                                ],
                                dividerThickness: 1.5,
                                dataTextStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                rows: prayers.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final prayer = entry.value;
                                  // final isSelected = index ==2; // Change this to the index of the current prayer
                                  final isSelected = isTodayCalendar &&
                                      (prayer.name ==
                                          _prayerSchedule.nextPrayer.name);
                                  return DataRow(
                                    selected: isSelected,
                                    cells: [
                                      DataCell(Text(prayer.name)),
                                      DataCell(Text(prayer.time)),
                                      DataCell(Checkbox(
                                          value: isTodayCalendar &&
                                              (prayer.status == 'now' ||
                                                  prayer.status == 'passed'),
                                          onChanged: (bool? value) {})),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _update(PrayerSchedule prayerSchedule) {
    try {
      setState(() {
        prayerSchedule.update();
        isTodayCalendar = DateTime.now().day == prayerSchedule.calendarDate.day;
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

  // Helper method to get the formatted day
  String _getFormattedDay(int index) {
    DateTime dateTime = DateTime.now().add(Duration(days: index));
    return DateFormat('EEEE').format(dateTime);
  }

  // Helper method to get the formatted date
  List<String> _getFormattedDate(int index) {
    // Get the current date
    DateTime selectedDateTime = DateTime.now().add(Duration(days: index));
    // Get the current locale
    String currentLocale = Intl.systemLocale;

    DateFormat dayNameFormat = DateFormat('EEEE', currentLocale);
    DateFormat dayFormat = DateFormat('d', currentLocale);
    DateFormat monthFormat = DateFormat('MMMM', currentLocale);
    DateFormat yearFormat = DateFormat('y', currentLocale);

    // Get the day, month, and year based on the current locale
    String dayName = dayNameFormat.format(selectedDateTime);
    String day = dayFormat.format(selectedDateTime);
    String month = monthFormat.format(selectedDateTime);
    String year = yearFormat.format(selectedDateTime);

    final hijri = JHijri(fDate: selectedDateTime);

    return [
      dayName,
      "${hijri.year} ${hijri.monthName} ${hijri.day}",
      "$day $month $year"
    ];
  }

  // Helper method to navigate to the previous/next day
  void _navigateToDay(int step) {
    DateTime navigatedDate = DateTime.now();
    setState(() {
      currentIndex += step;
      if (currentIndex >= 0) {
        navigatedDate = navigatedDate.add(Duration(days: currentIndex));
      } else {
        navigatedDate = navigatedDate.subtract(Duration(days: -currentIndex));
      }
      print(navigatedDate);
      _prayerSchedule.init(navigatedDate);
    });
  }

  Widget customCalendarHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                _navigateToDay(-1);
              },
            ),
            Column(
              children: [
                for (String text in _getFormattedDate(currentIndex))
                  Text(
                    text,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                _navigateToDay(1);
              },
            ),
          ],
        ),
        isTodayCalendar
            ? IconButton(
                iconSize: 30,
                icon: const Icon(Icons.calendar_month_rounded),
                onPressed: () {
                  Get.to(PDFViewerPage());
                },
              )
            : IconButton(
                iconSize: 30,
                icon: const Icon(Icons.settings_backup_restore_rounded),
                onPressed: () {
                  currentIndex = 0;
                  _prayerSchedule.init(DateTime.now());
                },
              ),
      ],
    );
  }

  Widget defaultCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            for (String text in _getFormattedDate(currentIndex))
              Text(
                text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ],
    );
  }
}
