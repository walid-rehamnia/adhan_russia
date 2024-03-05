import 'package:adan_russia/components.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/screens/test.dart';
import 'package:adan_russia/utils_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<void> _downloadFiles;
  late Future<String?> _defaultMode;

  @override
  void initState() {
    super.initState();
    _defaultMode = getDefaultMode();
    // _downloadFiles = checkFirstInstallation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _defaultMode,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while downloading
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Show an error message if file download fails
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.hasData) {
                return MyBottomNavigationBar();
              } else {
                return ModeChoiceScreen();
              }
            }
          },
        ),
      ),
    );
  }
}

Future<String?> getDefaultMode() async {
  PreferencesController preferencesController =
      Get.find<PreferencesController>();
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString(preferencesController.timingMode.value);
}
