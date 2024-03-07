import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/screens/card_choices_screen.dart';
import 'package:adan_russia/translations/my_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:adan_russia/utils/utils_settings.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
    _preferencesController = Get.find<PreferencesController>();

    selectedRadio = _preferencesController.timingMode.value;
    // currentLanguage = "english".tr;
    currentLocation = _preferencesController.userLocation.value;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => Container(
        decoration: BACKGROUND_SCREEN,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                'language'.tr,
                style: TITLE_STYLE,
              ),
              DropdownButton<String>(
                dropdownColor: Colors.grey,
                value: _preferencesController.defaultLanguage.value.tr,
                onChanged: (String? newValue) {
                  updateDefaultLanguage(newValue!);
                  EasyLoading.showSuccess('done'.tr);
                },
                items: getSupportedLanguages()
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const Divider(
                color: Colors.black,
                thickness: 0.4,
              ),
              Text(
                'mode'.tr,
                style: TITLE_STYLE,
              ),
              RadioListTile(
                title: Text('custom'.tr),
                value: 'custom',
                groupValue: selectedRadio,
                tileColor: selectedRadio == "custom" ? MAIN_COLOR : null,
                hoverColor: Colors.black,
                activeColor: Colors.black,
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
              RadioListTile(
                title: Text('standard'.tr),
                value: 'standard',
                groupValue: selectedRadio,
                tileColor: selectedRadio == "standard" ? MAIN_COLOR : null,
                hoverColor: Colors.black,
                activeColor: Colors.black,
                onChanged: (value) async {
                  EasyLoading.show(status: 'loading'.tr);
                  await setTimeMode("standard");
                  EasyLoading.showSuccess('done'.tr);
                  setState(() {
                    selectedRadio = value!;
                  });
                },
              ),
              if (selectedRadio == "standard")
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MAIN_COLOR,
                    ),
                    child: Text(
                      "methodButton".tr,
                      style: const TextStyle(
                          fontFamily: 'Amiri',
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CardChoices();
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.black,
                thickness: 0.5,
              ),
              const SizedBox(height: 10),
              Text(
                'notificationOptions'.tr,
                style: TITLE_STYLE,
              ),
              CheckboxListTile(
                title: Text('adanNotification'.tr),
                hoverColor: Colors.black,
                checkColor: Colors.black,
                activeColor: MAIN_COLOR1,
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
                hoverColor: Colors.black,
                checkColor: Colors.black,
                activeColor: MAIN_COLOR1,
                value: _preferencesController.isNotifyIqama.value == true,
                onChanged: (value) {
                  EasyLoading.show(status: 'loading'.tr);
                  _preferencesController.updatePreference(
                      "isNotifyIqama", value!);
                  EasyLoading.showSuccess('done'.tr);
                  EasyLoading.dismiss();
                },
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.black,
                thickness: 0.5,
              ),
              const SizedBox(height: 10),
              Text(
                'currentLocation'.tr,
                style: TITLE_STYLE,
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
