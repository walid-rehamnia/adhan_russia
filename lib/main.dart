import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/prayer_notification.dart';
import 'package:adan_russia/preferences.dart';
import 'package:adan_russia/screens/splash_screen.dart';
import 'package:adan_russia/translations/my_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PrayerNotification.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  PreferencesController myController = PreferencesController();
  await myController.loadPreferences();

  Get.put(myController);

  setLocale();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: 'Adan Russia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MAIN_COLOR, // Set the primary color
        // primarySwatch: Colors.green,
      ),
      translations: MyTranslations(),
      locale: Get.locale,
      fallbackLocale: const Locale('en', 'US'),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
