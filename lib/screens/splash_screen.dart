import 'package:adan_russia/components.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/screens/choice_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<String?> _defaultMode;

  @override
  void initState() {
    super.initState();
    _defaultMode = getDefaultMode();
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(snapshot.error.toString()),
                  duration: Duration(seconds: 3),
                ),
              );
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.hasData && snapshot.data.toString() != "") {
                print('YESSSSS');
                print(snapshot.data.toString());
                return MyBottomNavigationBar();
              } else {
                print('NOOOOOO');

                return ChoiceScreen();
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
  return preferencesController.timingMode.value;
}