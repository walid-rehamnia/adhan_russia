import 'translation_keys.dart' as translation;

class En {
  Map<String, String> get messages => {
        translation.home: 'Home',
        translation.schedulePrayer: 'Prayer',
        translation.scheduleTime: 'Time',
        translation.schedulePassed: 'Is passed',

        translation.remaining: 'It remains @duration for',
        translation.fadjr: 'Fadjr',
        translation.sunrise: 'Sunrise',

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
        translation.standardDesc:
            "Calculate prayer times anywhere in the world; the calculation methods can be changed in the settings.",
        translation.customDesc:
            'Calculate prayer times based on the calendar used in Russian mosques; for now, only data for "Nizhny Novgorod" city are obtained. Feel free to help us cover all the cities.',
        translation.methodButton: "Used method : @method",
        translation.dubai: "Dubai",
        translation.egyptian: "egyptian",
        translation.kuwait: "kuwait",
        translation.karachi: "Karachi",
        translation.moon_sighting_committee: "Moon sighting committee",
        translation.muslim_world_league: "Muslim world league",
        translation.north_america: "North America",
        translation.qatar: "Qatar",
        translation.tehran: "Tehran",
        translation.turkey: "Turkey",
        translation.umm_al_qura: "Umm Al Qura",
        translation.other: "Other",

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

//eng months
        translation.january: "January",
        translation.february: "February",
        translation.march: "March",
        translation.april: "April",
        translation.may: "May",
        translation.june: "June",
        translation.july: "July",
        translation.august: "August",
        translation.september: "September",
        translation.october: "October",
        translation.november: "November",
        translation.december: "December",
//Week days

        translation.sunday: "Sunday",
        translation.monday: "Monday",
        translation.tuesday: "Tuesday",
        translation.wednesday: "Wednesday",
        translation.thursday: "Thursday",
        translation.friday: "Friday",
        translation.saturday: "Saturday",
        //Hijri months
        translation.h1: "Muharram",
        translation.h2: "Safar",
        translation.h3: "Rabi' al-Awwal",
        translation.h4: "Rabi' al-Thani",
        translation.h5: "Jumada al-Awwal",
        translation.h6: "Jumada al-Thani",
        translation.h7: "Rajab",
        translation.h8: "Sha'ban",
        translation.h9: "Ramadan",
        translation.h10: "Shawwal",
        translation.h11: "Dhu al-Qi'dah",
        translation.h12: "Dhu al-Hijjah",
      };
}
