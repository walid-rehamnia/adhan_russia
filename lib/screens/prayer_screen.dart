import 'dart:async';

import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/models/standard_prayer_schedule.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/custom_prayer_schedule.dart';
import 'package:adan_russia/models/prayer_schedule.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/screens/pdf_page.dart';
import 'package:adan_russia/screens/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jhijri/_src/_jHijri.dart';
import 'dart:ui' as ui;

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

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

  @override
  void initState() {
    try {
      super.initState();
      _preferencesController = Get.find<PreferencesController>();
      if (_preferencesController.timingMode.value == 'custom') {
        _prayerSchedule = CustomPrayerSchedule();
      } else {
        _prayerSchedule = StandardPrayerSchedule();
      }

      _prayerSchedule.init(DateTime.now()).then((value) {
        _prayerSchedule.update();
        prayers = _prayerSchedule.prayers;

        isTodayCalendar =
            DateTime.now().day == _prayerSchedule.calendarDate.day;
        setState(() {
          isLoading = false;
        });

        // Update state every min
        timer = Timer.periodic(
            const Duration(seconds: 1), (Timer t) => _update(_prayerSchedule));
      });
    } catch (e) {
      EasyLoading.showError("Error, check your internet connection please");
    }
  }

  // Index to keep track of the current day
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.9;
    double containerHeight = MediaQuery.of(context).size.height * 0.6;
    return Center(
      child: isLoading == true
          ? const MyProgressLoader()
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/${_prayerSchedule.currentPrayer.index}.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black
                        .withOpacity(1), // Adjust the opacity here (0.0 to 1.0)
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 30.0,
                            ),
                          ),
                          Text(
                            _preferencesController.userLocation.value,
                            style: const TextStyle(
                                fontFamily: 'Amiri',
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: containerWidth / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/back4.jpg'), // Replace with your image asset
                          fit: BoxFit.cover,

                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(
                                0.5), // Adjust the opacity here (0.0 to 1.0)
                            BlendMode.dstATop,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              _prayerSchedule.getRemainingTime(),
                              textDirection: ui.TextDirection.ltr,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              _prayerSchedule.nextPrayer.name.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Left and right arrow buttons for navigation

                    const SizedBox(
                      height: 40,
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
                                  0.6), // Adjust the opacity here (0.0 to 1.0)
                              BlendMode.dstATop,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            _preferencesController.timingMode.value == 'custom'
                                ? customCalendarHeader()
                                : defaultCalendarHeader(),
                            SizedBox(height: 10),
                            DataTable(
                              dataRowColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  // Set color based on the button state
                                  return MAIN_COLOR; // Default color
                                },
                              ),
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'schedulePrayer'.tr,
                                    style: const TextStyle(
                                        fontFamily: 'Amiri',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17),
                                  ),
                                  numeric: true,
                                ),
                                DataColumn(
                                  label: Container(
                                    child: Text(
                                      'scheduleTime'.tr,
                                      style: const TextStyle(
                                          fontFamily: 'Amiri',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17),
                                    ),
                                  ),
                                  numeric: true,
                                ),
                                DataColumn(
                                  label: Text(
                                    'schedulePassed'.tr,
                                    style: const TextStyle(
                                        fontFamily: 'Amiri',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17),
                                  ),
                                  numeric: true,
                                ),
                              ],
                              dividerThickness: 1.5,
                              dataTextStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              rows: prayers.asMap().entries.map((entry) {
                                final index = entry.key;
                                final prayer = entry.value;
                                // final isSelected = index ==2; // Change this to the index of the current prayer
                                final isSelected = isTodayCalendar &&
                                    (prayer.name ==
                                        _prayerSchedule.nextPrayer.name);
                                return DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      // Check if the row is selected
                                      if (_prayerSchedule.nextPrayer.index ==
                                              index &&
                                          _prayerSchedule.nextPrayer.status !=
                                              "passed") {
                                        return MAIN_COLOR;
                                      }
                                      return null; // Default color for other rows
                                    },
                                  ),
                                  selected: isSelected,
                                  cells: [
                                    DataCell(Center(
                                      child: Text(
                                        prayer.name.tr,
                                        style: const TextStyle(
                                            fontFamily: 'Amiri',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17),
                                      ),
                                    )),
                                    DataCell(Text(
                                      prayer.time,
                                    )),
                                    DataCell(Checkbox(
                                        hoverColor: Colors.black,
                                        checkColor: Colors.black,
                                        activeColor: MAIN_COLOR,
                                        value: isTodayCalendar &&
                                            (prayer.status == 'passed'),
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
    );
  }

  void _update(PrayerSchedule prayerSchedule) {
    try {
      setState(() {
        prayerSchedule.update();
        isTodayCalendar = DateTime.now().day == prayerSchedule.calendarDate.day;
        // print(
        //     "Update now with next prayer${prayerSchedule.nextPrayer.name} current prayer ${prayerSchedule.currentPrayer.name} reminded time ${prayerSchedule.getRemainingTime()}");
      });
    } catch (e) {
      // Handle errors here
      print("Error updating timer: $e");
      EasyLoading.showError("Error, check your internet connection please");

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
    String hijriMonth = "h${hijri.month}".tr;
    return [
      dayName.tr,
      "${hijri.day} $hijriMonth ${hijri.year}",
      "$day ${month.tr} $year"
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
              icon: const Icon(Icons.arrow_left),
              onPressed: () {
                _navigateToDay(-1);
              },
            ),
            Column(
              children: [
                for (String text in _getFormattedDate(currentIndex))
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 18.5, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right),
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
                style: const TextStyle(
                    fontSize: 18.5, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ],
    );
  }
}
