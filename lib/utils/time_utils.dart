String durationToString(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes;
  if (hours == 0) return "${formatNumber(minutes)}min";
  return "${hours}h${formatNumber(minutes % 60)}";
}

String formatNumber(int n) {
  return n.toString().padLeft(2, "0");
}

String formatTime(DateTime datetime) {
  return "${datetime.hour}:${formatNumber(datetime.minute)}";
}

String getMonth(int monthIndex) {
  return switch (monthIndex) {
    1 => "Janvier",
    2 => "Février",
    3 => "Mars",
    4 => "Avril",
    5 => "Mai",
    6 => "Juin",
    7 => "Juillet",
    8 => "Août",
    9 => "Septembre",
    10 => "Octobre",
    11 => "Novembre",
    12 => "Décembre",
    _ => ""
  };
}