import 'translation_keys.dart' as translation;

class Ru {
  Map<String, String> get messages => {
        translation.home: 'Главная',
        translation.schedulePrayer: 'Молитва',
        translation.scheduleTime: 'Время',
        translation.schedulePassed: 'Прошло',

        translation.remaining: 'Осталось @duration для',
        translation.fadjr: 'Фаджр',
        translation.sunrise: 'Восход',

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
        translation.methodButton: "Используемый метод: @method",
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

        // eng months
        translation.january: "Январь",
        translation.february: "Февраль",
        translation.march: "Март",
        translation.april: "Апрель",
        translation.may: "Май",
        translation.june: "Июнь",
        translation.july: "Июль",
        translation.august: "Август",
        translation.september: "Сентябрь",
        translation.october: "Октябрь",
        translation.november: "Ноябрь",
        translation.december: "Декабрь",

        // Week days
        translation.sunday: "Воскресенье",
        translation.monday: "Понедельник",
        translation.tuesday: "Вторник",
        translation.wednesday: "Среда",
        translation.thursday: "Четверг",
        translation.friday: "Пятница",
        translation.saturday: "Суббота",

        // Hijri months
        translation.h1: "Мухаррам",
        translation.h2: "Сафар",
        translation.h3: "Раби аль-Авваль",
        translation.h4: "Раби аль-Тани",
        translation.h5: "Джумада аль-Авваль",
        translation.h6: "Джумада аль-Тани",
        translation.h7: "Раджаб",
        translation.h8: "Ша'бан",
        translation.h9: "Рамадан",
        translation.h10: "Шауваль",
        translation.h11: "Ду аль-Кида",
        translation.h12: "Ду аль-Хиджа",

        translation.internetError:
            "Проверьте свое подключение к Интернету, затем повторите попытку",

        translation.aboutText: "Мы ценим ваши отзывы!",
        translation.rateBtn: "Оцените нас",
        translation.askBtn: "Задавайте вопросы / получайте поддержку",
      };
}
