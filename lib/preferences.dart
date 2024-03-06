import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesController extends GetxController {
  RxString timingMode = ''.obs;

//PrayerSchedule
  RxString calendarYear = ''.obs;
  RxString calendarMonthlyData = ''.obs;

  RxString defaultLanguage = ''.obs;
  RxString userLocation = ''.obs;

  RxDouble positionLatitude = 0.0.obs;
  RxDouble positionLongitude = 0.0.obs;

  RxBool isNotifyAdhan = true.obs;
  RxBool isNotifyIqama = true.obs;

  @override
  void onInit() async {
    // Load preferences when the controller is initialized
    // loadPreferences();
    super.onInit();
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    timingMode.value = prefs.getString('timingMode') ?? '';
    calendarYear.value = prefs.getString('calendarYear') ?? '';

    calendarMonthlyData.value = prefs.getString('calendarMonthlyData') ?? '';

    defaultLanguage.value = prefs.getString('defaultLanguage') ?? '';
    userLocation.value = prefs.getString('userLocation') ?? '';
    positionLatitude.value = prefs.getDouble('positionLatitude') ?? 0.0;
    positionLongitude.value = prefs.getDouble('positionLongitude') ?? 0.0;

    isNotifyAdhan.value = prefs.getBool('isNotifyAdhan') ?? true;
    isNotifyIqama.value = prefs.getBool('isNotifyIqama') ?? true;
    print('loading**********************************$defaultLanguage');
  }

  Future<void> updatePreference(String prefName, var value) async {
    print('updatePreference$prefName=$value');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case bool:
        await prefs.setBool(prefName, value);
        break;
      case int:
        await prefs.setInt(prefName, value);
        break;
      case double:
        await prefs.setDouble(prefName, value);
        break;
      case String:
        await prefs.setString(prefName, value);
        break;
    }

    switch (prefName) {
      case "timingMode":
        timingMode.value = value;
        break;
      case "calendarYear":
        calendarYear.value = value;
        break;
      case "calendarMonthlyData":
        calendarMonthlyData.value = value;
        break;
      case "defaultLanguage":
        defaultLanguage.value = value;
        break;
      case "positionLatitude":
        positionLatitude.value = value;
        break;
      case "positionLongitude":
        positionLongitude.value = value;
        break;
      case "userLocation":
        userLocation.value = value;
        break;
      case "isNotifyAdhan":
        isNotifyAdhan.value = value;
        break;
      case "isNotifyIqama":
        isNotifyIqama.value = value;
        break;
    }
  }
}
