import 'translation_keys.dart' as translation;

class En {
  Map<String, String> get messages => {
        translation.home: 'Home',
        translation.schedulePrayer: 'Prayer',
        translation.scheduleTime: 'Time',
        translation.schedulePassed: 'Is passed',

        translation.remaining: 'It remains @duration for',
        translation.fadjr: 'Fadjr',
        translation.dhuhr: 'Dhuhr',
        translation.asr: 'Asr',
        translation.maghreb: 'Maghreb',
        translation.isha: 'Isha',
        translation.settings: 'Settings',
        translation.language: 'Language:',

        translation.adanNotification: 'Call for prayer',
        translation.prayerNotification: 'Prayer (Iqama)',
        translation.mode: 'Times calculation method:',
        translation.standard: 'Standard Mode (Anywhere)',
        translation.custom: 'Custom Mode (More accurate / Restricted cities)',
        // translation.currentLocation: "Current location : @location",
        translation.currentLocation: "Current location :",

        translation.notificationOptions: "Notifications:",
        translation.adanNotificationTitle: 'Time for @prayer: call for prayer',
        translation.iqamaNotificationTitle: 'Time for @prayer prayer',
        translation.otherNotification: 'Other notification',
        translation.about: "About",
        translation.en: "English",
        translation.ar: "Arabic",
        translation.ru: "Russian",
        translation.loading: "Loading ...",
        translation.done: "done",
      };
}
