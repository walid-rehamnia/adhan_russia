import 'dart:convert';

import 'package:adan_russia/models/prayer.dart';

// class Prayer {
//   String time;
//   String title;
//   bool selected = false; //means current
//   String status = "upcoming"; // now, upcoming, final

//   // Prayer({this.time = "N/A", this.title = "Prayer", this.selected = false});

//   Prayer(this.time, this.title, this.selected);

//   Map<String, dynamic> toJson() => {
//         'time': time,
//         'title': title,
//         'selected': selected,
//         'status': status,
//       };

//   factory Prayer.fromJson(Map<String, dynamic> value) {
//     return Prayer(value["time"], value["title"], value["selected"]);
//   }
// }

class PrayerDate {
  PrayerDate(this.date, this.prayers);

  List<MyPrayer> prayers;
  String date;

  factory PrayerDate.fromJson(Map<String, dynamic> json) {
    List<MyPrayer> prayers = [];
    (json["timings"] as Map<String, dynamic>).forEach((key, value) {
      prayers.add(MyPrayer(value, key, 0));
    });
    var dateGregorianModel = (json["date"] as Map<String, dynamic>)["gregorian"]
        as Map<String, dynamic>;
    return PrayerDate(dateGregorianModel["date"], prayers);
  }

  factory PrayerDate.fromJsonPrf(Map<String, dynamic> value) {
    List<MyPrayer> prayers = [];
    prayers.add(MyPrayer(value["time"], value["title"], value["selected"]));
    return PrayerDate(value["date"], prayers);
  }

  Map<String, dynamic> toJson() => {
        'prayers':
            jsonEncode(prayers, toEncodable: (e) => (e as MyPrayer).toJson()),
        'date': date,
      };
}
