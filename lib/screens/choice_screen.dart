import 'package:adan_russia/components.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/utils/utils_location.dart';
import 'package:adan_russia/utils/utils_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  bool isLoading = false;
  PreferencesController preferencesController =
      Get.find<PreferencesController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChoiceButton(
              title: ' Standard Mode (Anywhere)',
              description:
                  "Calculate the prayer time based on different global used parameters (you will be able to customize them soon in app parameters)",
              onPressed: () async {
                // Start loading
                setState(() {
                  isLoading = true;
                });
                try {
                  await getCoordinates();

                  preferencesController.updatePreference(
                      "timingMode", "standard");
                  setState(() {
                    isLoading = false;
                  });

                  Get.to(() => MyBottomNavigationBar());
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16.0), // Add some spacing between buttons
            ChoiceButton(
              title: 'Custom Mode (more accurate / Limited cities)',
              description:
                  "Bsed on the calendars used in the russian mosques which has been issued from ....., for now it's limited to 'Nizhny Novgorod' city, help us with your city calendars so we'll covers more cities",
              onPressed: () async {
                // Start loading
                setState(() {
                  isLoading = true;
                });
                try {
                  await checkFirstInstallation();
                  preferencesController.updatePreference(
                      "timingMode", "custom");
                  setState(() {
                    isLoading = false;
                  });
                  Get.to(() => MyBottomNavigationBar());
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ],
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
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        // primary: Colors.blue, // Set button color
        // onPrimary: Colors.white, // Set text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Add rounded corners
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
