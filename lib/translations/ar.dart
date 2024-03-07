import 'translation_keys.dart' as translation;

class Ar {
  Map<String, String> get messages => {
        translation.home: 'الصفحة الرئيسية',
        translation.schedulePrayer: 'الصلاة',
        translation.scheduleTime: 'وقت الأذان',
        translation.schedulePassed: 'هل مرت ؟',

        translation.remaining: 'بقي @duration لصلاة',
        translation.fadjr: 'الفجر',
        translation.sunrise: 'الشروق',
        translation.dhuhr: 'الظهر',
        translation.asr: 'العصر',
        translation.maghreb: 'المغرب',
        translation.isha: 'العشاء',
        translation.settings: 'الإعدادات',
        translation.language: 'اللغة :',

        translation.adanNotification: 'تنبيه بالأذان',
        translation.prayerNotification: 'تنبيه بالإقامة',
        translation.mode: 'طريقة حساب الأوقات',
        translation.standard: 'عادي',
        translation.custom: 'مخصص',
        translation.notificationOptions: "الإشعارات:",
        // translation.currentLocation: "الموقع الحالي : @location",
        translation.currentLocation: "الموقع الحالي :",
        translation.adanNotificationTitle: 'الآن موعد أذان صلاة @prayer',
        translation.iqamaNotificationTitle: 'الآن موعد إقامة صلاة @prayer',
        translation.otherNotification: 'تنبيهات أخرى',
        translation.about: "حول",
        translation.en: "الإنجليزية",
        translation.ar: "العربية",
        translation.ru: "الروسية",
        translation.loading: "جاري التحميل ...",
        translation.done: "تم",
      };
}
