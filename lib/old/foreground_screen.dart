import 'package:adan_russia/components.dart';
import 'package:adan_russia/models/prayer.dart';
import 'package:adan_russia/models/custom_prayer_schedule.dart';
import 'package:flutter/material.dart';
import 'package:adan_russia/screens/calender_screen.dart';
import 'package:adan_russia/models.dart';
import 'package:adan_russia/pref.dart';

class ForeGroundWidget extends StatelessWidget {
  ForeGroundWidget(this.prayerSchedule, {super.key});

  final CustomPrayerSchedule prayerSchedule;

  double cardWidth = 0.0;
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    cardWidth = MediaQuery.of(context).size.width / 1.2;
    print("First time $firstTime");
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight / 45),
          loaderWidget(screenHeight, prayerSchedule),
          Container(
            margin: const EdgeInsets.all(8),
            child: Text(
              "${Prefs.getString('country') ?? ""}-${Prefs.getString('city') ?? ""}",
              style: const TextStyle(color: Colors.white60),
            ),
          ),
          SizedBox(
              height: screenHeight / 2,
              child: cardWidget(
                  context, screenHeight, screenWidth, prayerSchedule))
        ],
      ),
    );
  }
}
