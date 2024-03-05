import 'dart:async';

import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/prayer_schedule.dart';
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
  late List<Prayer> prayers;
  late bool isTodayCalendar;
  CustomPrayerSchedule _prayerSchedule = CustomPrayerSchedule();
  @override
  void initState() {
    super.initState();
    _prayerSchedule = CustomPrayerSchedule();

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
                          0.35), // Adjust the opacity here (0.0 to 1.0)
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${_prayerSchedule.remainingTime}"),

                      // Left and right arrow buttons for navigation
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
                              for (String text
                                  in _getFormattedDate(currentIndex))
                                Text(
                                  text,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                      SizedBox(
                        height: 20,
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
                              icon: const Icon(
                                  Icons.settings_backup_restore_rounded),
                              onPressed: () {
                                currentIndex = 0;
                                _prayerSchedule.init(DateTime.now());
                              },
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      // Display the DataTable
                      DataTable(
                        columns: [
                          DataColumn(label: Text('Prayer Name')),
                          DataColumn(label: Text('Prayer Time')),
                          DataColumn(label: Text('Is done')),
                        ],
                        rows: prayers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final prayer = entry.value;
                          // final isSelected = index ==2; // Change this to the index of the current prayer
                          final isSelected = isTodayCalendar &&
                              (prayer.name == _prayerSchedule.nextPrayer.name);
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
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _update(CustomPrayerSchedule prayerSchedule) {
    try {
      setState(() {
        prayerSchedule.update();
        isTodayCalendar = DateTime.now().day == prayerSchedule.calendarDate.day;
        print(
            "Update now with next prayer${prayerSchedule.nextPrayer.name} current prayer ${prayerSchedule.currentPrayer.name} reminded time ${prayerSchedule.remainingTime}");
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
}
