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
    print(_preferencesController.defaultLanguage.value);
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
                  try {
                    await setTimeMode("custom").timeout(ASYNC_TIME_OUT);
                  } catch (e) {
                    EasyLoading.showError(
                        'Error, check internet connection and try again');
                  }
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
                  try {
                    await setTimeMode("standard").timeout(ASYNC_TIME_OUT);
                  } catch (e) {
                    EasyLoading.showError(
                        'Error, check internet connection and try again');
                  }
                  EasyLoading.showSuccess('done'.tr);
                  setState(() {
                    selectedRadio = value!;
                  });
                },
              ),
              const SizedBox(
                height: 5,
              ),
              if (selectedRadio == "standard")
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CardChoices();
                        },
                      );
                    },
                    icon: const Icon(
                        color: Colors.black,
                        Icons.edit), // Replace with your desired icon
                    label: Text(
                      "methodButton".trParams({
                        "method":
                            _preferencesController.calculationMethod.value.tr
                      }),
                      style: const TextStyle(
                          fontFamily: 'Amiri',
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: MAIN_COLOR, // Set the background color
                    ),
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
                activeColor: MAIN_COLOR,
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
                activeColor: MAIN_COLOR,
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
              if (selectedRadio == "standard")
                Text(
                  'currentLocation'.tr,
                  style: TITLE_STYLE,
                ),
              if (selectedRadio == "standard")
                Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      EasyLoading.show(status: 'loading'.tr);
                      try {
                        await updateUserLocation().timeout(ASYNC_TIME_OUT);
                      } catch (e) {
                        EasyLoading.showError(
                            "Error, Check internet connection and try again");
                      }
                      EasyLoading.showSuccess('done'.tr);
                      EasyLoading.dismiss();
                    },
                    icon: const Icon(
                        color: Colors.black,
                        Icons
                            .edit_location_alt_sharp), // Replace with your desired icon
                    label: Text(
                      _preferencesController.userLocation.value,
                      style: const TextStyle(
                          fontFamily: 'Amiri',
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: MAIN_COLOR, // Set the background color
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ));
  }
}
