import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/main.dart';
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
  bool enableFeature1 = false;
  bool enableFeature2 = true;

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
    EasyLoading.show(status: 'loading...'.tr);
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
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: Obx(() => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      'Adhan Time Mode',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                      title: Text('Standard Mode (Anywhere)'),
                      value: 'standard'.tr,
                      groupValue: selectedRadio,
                      onChanged: (value) async {
                        await setTimeMode("standard");
                        setState(() {
                          selectedRadio = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(
                          'Custom Mode (More accurate / Restricted cities)'),
                      value: 'custom',
                      groupValue: selectedRadio,
                      onChanged: (value) {
                        setState(() {
                          selectedRadio = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Checkbox Options:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    CheckboxListTile(
                      title: Text('Enable Feature 1'),
                      value: enableFeature1,
                      onChanged: (value) {
                        setState(() {
                          enableFeature1 = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Enable Feature 2'),
                      value: enableFeature2,
                      onChanged: (value) {
                        setState(() {
                          enableFeature2 = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await getCoordinates();
                      },
                      child: isLoading
                          ? CircularProgressIndicator(color: MAIN_COLOR1)
                          : Text('Location'),
                    ),
                    SizedBox(height: 8),
                    Text('Current Location: $currentLocation'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        saveSettings();
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            )));
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
