import 'package:adan_russia/components.dart';
import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/utils/utils.dart';
import 'package:adan_russia/utils/utils_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  PreferencesController preferencesController =
      Get.find<PreferencesController>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BACKGROUND_SCREEN,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ChoiceButton(
                title: 'standard'.tr,
                description:
                    "Calculate the prayer time based on different global used parameters (you will be able to customize them soon in app parameters)",
                onPressed: () async {
                  EasyLoading.show(status: 'loading'.tr);

                  try {
                    await setTimeMode('standard');
                    EasyLoading.showSuccess('done'.tr);
                    EasyLoading.dismiss();
                    Get.to(() => MyBottomNavigationBar());
                  } catch (e) {
                    EasyLoading.showError('$e');
                    EasyLoading.dismiss();
                  }
                },
              ),
              const SizedBox(height: 16.0), // Add some spacing between buttons
              ChoiceButton(
                title: 'custom'.tr,
                description:
                    "Bsed on the calendars used in the russian mosques which has been issued from ....., for now it's limited to 'Nizhny Novgorod' city, help us with your city calendars so we'll covers more cities",
                onPressed: () async {
                  EasyLoading.show(status: 'loading'.tr);

                  try {
                    await setTimeMode('custom');
                    EasyLoading.showSuccess('done'.tr);
                    EasyLoading.dismiss();
                    Get.to(() => MyBottomNavigationBar());
                  } catch (e) {
                    EasyLoading.showError('$e');
                    EasyLoading.dismiss();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const ChoiceButton({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: MAIN_COLOR,
        foregroundColor: TEXT_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Add rounded corners
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            description,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
