import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/utils/utils_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:adan_russia/utils/utils_settings.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(MaterialApp(
    home: SettingsScreen(),
    theme: ThemeData(primaryColor: MAIN_COLOR),
  ));
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final PreferencesController _preferencesController;
  // Radio choices
  late String selectedRadio;

  // Checkbox options

  // Other options
  double sliderValue = 50.0;

  // Current location
  late String currentLocation;

  // Loading indicator
  bool isLoading = false;
  // Application language

  @override
  void initState() {
    print('********');
    _preferencesController = Get.find<PreferencesController>();

    selectedRadio = _preferencesController.timingMode.value;
    // currentLanguage = "english".tr;

    _preferencesController.updatePreference("defaultLanguage", "english");
    currentLocation = _preferencesController.userLocation.value;
    // TODO: implement initState
    super.initState();
  }

  // Function to save the settings
  void saveSettings() async {
    print('async');
    // Implement your logic to save the settings here
    EasyLoading.show(status: 'loading'.tr);
    await fakeAsyncOperation(3);
    EasyLoading.dismiss();
    EasyLoading.showSuccess('Great Success!');
    await fakeAsyncOperation(1);

    EasyLoading.showError('Failed with Error');
    await fakeAsyncOperation(1);

    EasyLoading.showInfo('Useful Information.');
    EasyLoading.dismiss();
  }

  // Function to get the current location
  Future<void> updateLocation() async {
    try {
      setState(() {
        isLoading = true;
      });

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation =
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
        isLoading = false;
      });
    } catch (e) {
      print('Error obtaining location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'language'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _preferencesController.defaultLanguage.value.tr,
              onChanged: (String? newValue) {
                print(newValue);
                setDefaultLanguage(newValue!);
                EasyLoading.showSuccess('done'.tr);
              },
              items: <String>['arabic'.tr, 'english'.tr, 'russian'.tr]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Text(
              'mode'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              title: Text('standard'.tr),
              value: 'standard',
              groupValue: selectedRadio,
              onChanged: (value) async {
                EasyLoading.show(status: 'loading'.tr);
                await setTimeMode("standard");
                EasyLoading.showSuccess('done'.tr);
                setState(() {
                  selectedRadio = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('custom'.tr),
              value: 'custom',
              groupValue: selectedRadio,
              onChanged: (value) async {
                EasyLoading.show(status: 'loading'.tr);
                await setTimeMode("custom");
                EasyLoading.showSuccess('done'.tr);
                EasyLoading.dismiss();
                setState(() {
                  selectedRadio = value!;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'notificationOptions'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: Text('adanNotification'.tr),
              value: _preferencesController.isNotifyAdhan.value == true,
              onChanged: (value) {
                EasyLoading.show(status: 'loading'.tr);
                _preferencesController.updatePreference(
                    "isNotifyAdhan", value!);
                EasyLoading.showSuccess('done'.tr);
                EasyLoading.dismiss();
              },
            ),
            CheckboxListTile(
              title: Text('prayerNotification'.tr),
              value: _preferencesController.isNotifyIqama.value == true,
              onChanged: (value) {
                EasyLoading.show(status: 'loading'.tr);
                _preferencesController.updatePreference(
                    "isNotifyIqama", value!);
                EasyLoading.showSuccess('done'.tr);
                EasyLoading.dismiss();
              },
            ),
            SizedBox(height: 16),
            Text(
              'currentLocation'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    EasyLoading.show(status: 'loading'.tr);
                    await updateUserLocation();
                    EasyLoading.showSuccess('done'.tr);
                    EasyLoading.dismiss();
                  },
                  icon: const Icon(
                    Icons.edit_location_alt_sharp,
                    color: MAIN_COLOR1,
                    size: 30.0,
                  ),
                ),
                Text(_preferencesController.userLocation.value),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

Future<String> fakeAsyncOperation(int seconds) async {
  print('fakeAsyncOperation started');
  // Simulating some asynchronous operation, such as fetching data from a server
  await Future.delayed(Duration(seconds: seconds));
  print('fakeAsyncOperation finished');
  // Returning a result once the operation is complete
  return 'Fake data from async operation';
}
