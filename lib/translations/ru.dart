import 'translation_keys.dart' as translation;

class Ru {
  Map<String, String> get messages => {
        translation.home: 'Главная',
        translation.schedulePrayer: 'Молитва',
        translation.scheduleTime: 'Время',
        translation.schedulePassed: 'Прошло',

        translation.remaining: 'Осталось @duration для',
        translation.fadjr: 'Фаджр',
        translation.dhuhr: 'Дхухр',
        translation.asr: 'Аср',
        translation.maghreb: 'Магриб',
        translation.isha: 'Иша',
        translation.settings: 'Настройки',
        translation.language: 'Язык:',

        translation.adanNotification: 'Позыв к молитве',
        translation.prayerNotification: 'Молитва (Икама)',
        translation.mode: 'Метод расчета времени:',
        translation.standard: 'Стандартный режим (Везде)',
        translation.custom:
            'Пользовательский режим (Точнее / Ограниченные города)',
        translation.standardDesc:
            "Рассчитывает время молитвы в любой точке мира; методы расчета можно изменить в настройках.",
        translation.customDesc:
            'Рассчитывает время молитвы на основе календаря, используемого в мечетях России; на данный момент доступны данные только для города "Нижний Новгород". Не стесняйтесь помочь нам охватить все города.',
        translation.methodButton: "Изменить метод расчета",
        translation.dubai: "Дубай",
        translation.egyptian: "Египетский",
        translation.kuwait: "Кувейт",
        translation.karachi: "Карачи",
        translation.moon_sighting_committee: "Комитет по видимости луны",
        translation.muslim_world_league: "Лига мусульманского мира",
        translation.north_america: "Северная Америка",
        translation.qatar: "Катар",
        translation.tehran: "Тегеран",
        translation.turkey: "Турция",
        translation.umm_al_qura: "Умм аль-Кура",
        translation.other: "Другое",

        // translation.currentLocation: "Текущее местоположение: @location",
        translation.currentLocation: "Текущее местоположение:",

        translation.notificationOptions: "Уведомления:",
        translation.adanNotificationTitle: 'Время для @prayer: позыв к молитве',
        translation.iqamaNotificationTitle: 'Время для @prayer молитвы',
        translation.otherNotification: 'Другое уведомление',
        translation.about: "О программе",
        translation.en: "Английский",
        translation.ar: "Арабский",
        translation.ru: "Русский",
        translation.loading: "Загрузка...",
        translation.done: "готово",
      };
}
