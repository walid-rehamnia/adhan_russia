import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/screens/calender_screen.dart';
import 'package:adan_russia/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class ModeChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Awesome Popup Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show the awesome popup when the button is pressed
            showAwesomePopup(context);
          },
          child: Text('Show Awesome Popup'),
        ),
      ),
    );
  }

  void showAwesomePopup(BuildContext context) {
    Get.defaultDialog(
      title: 'Choose an Option',
      content: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final Coordinates myCoordinates;

              PreferencesController preferencesController =
                  Get.find<PreferencesController>();
              if (preferencesController.positionLatitude.value != 0.0) {
                myCoordinates = Coordinates(
                    preferencesController.positionLatitude.value,
                    preferencesController.positionLongitude.value);
              } else {
                Position position = await determinePosition();

                preferencesController.updatePreference(
                    'positionLatitude', position.latitude);
                preferencesController.updatePreference(
                    'positionLongitude', position.longitude);
                myCoordinates =
                    Coordinates(position.latitude, position.longitude);
                print(position);
                print(position.accuracy);
              }

              // Perform reverse geocoding
              List<Placemark> placemarks = await placemarkFromCoordinates(
                  position.latitude, position.longitude);

              // Extract city and country from the first placemark
              String city = placemarks.first.locality ?? "";
              String country = placemarks.first.country ?? "";

              print("City: $city");
              print("Country: $country");

              print('My Prayer Times');
              final myCoordinates = Coordinates(
                  position.latitude,
                  position
                      .longitude); // Replace with your own location lat, lng.
              final params = CalculationMethod.karachi.getParameters();
              params.madhab = Madhab.hanafi;
              final prayerTimes = PrayerTimes.today(myCoordinates, params);

              print(
                  "---Today's Prayer Times in Your Local Timezone(${prayerTimes.fajr.timeZoneName})---");
              print(prayerTimes);
              List<String> times = [];
              times.addAll([
                DateFormat.Hm().format(prayerTimes.fajr),
                DateFormat.Hm().format(prayerTimes.dhuhr),
                DateFormat.Hm().format(prayerTimes.asr),
                DateFormat.Hm().format(prayerTimes.maghrib),
                DateFormat.Hm().format(prayerTimes.isha),
              ]);
              for (var prayer in times) {
                print(prayer);
              }
              print('---');

              Get.to(() => CalendarScreen());
            },
            child: Text('Default'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using Get
              Get.to(() => CalendarScreen());
            },
            child: Text('Custom'),
          ),
        ],
      ),
    );
  }
}
