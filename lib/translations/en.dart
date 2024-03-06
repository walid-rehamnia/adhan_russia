import 'translation_keys.dart' as translation;

class En {
  Map<String, String> get messages => {
        translation.home: 'Home',
        translation.remaining: 'It remains @duration for',
        translation.fadjr: 'Fadjr',
        translation.dhuhr: 'Dhuhr',
        translation.asr: 'Asr',
        translation.maghreb: 'Maghreb',
        translation.isha: 'Isha',
        translation.settings: 'Settings',
        translation.adanNotification: 'adanNotification',
        translation.prayerNotification: 'prayerNotification',
        translation.mode: 'Times calculation method',
        translation.standard: 'Standard',
        translation.custom: 'Custom',
        translation.adanNotificationTitle: 'Time for @prayer: call for prayer',
        translation.iqamaNotificationTitle: 'Time for @prayer prayer',
        translation.otherNotification: 'Other notification',
        translation.about: "About",
        translation.english: "English",
        translation.arabic: "Arabic",
        translation.russian: "Russian",
        translation.loading: "Loading ...",
        translation.done: "done",
      };
}
