class Prayer {
  String time;
  String name;
  String status = "upcoming"; // now, upcoming, final
  int index = 0;

  // Prayer({this.time = "N/A", this.title = "Prayer", this.selected = false});

  Prayer(this.time, this.name, this.index);

  Map<String, dynamic> toJson() => {
        'time': time,
        'title': name,
        'index': index,
        'status': status,
      };
}
