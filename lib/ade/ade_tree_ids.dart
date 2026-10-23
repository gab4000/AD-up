import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';

import '../components/class.dart';
import 'ade_ical.dart';
import 'ade_types.dart';

final Map<String, String> classID = const {
  "1A": "1130",
  "1B": "1134",
  "1C": "1133",
  "1D": "1198",
  "2A": "1471",
  "2B": "1468",
  "2C": "1472"
};

void load(BuildContext context, ADESessionParams params, String classID) async {
  classes = {};
  getStrIcal(params, classID).then((value) {
    ICalendar calendar = ICalendar.fromString(value);
    for (var element in calendar.data) {
      String description = element["description"].toString()
          .replaceAll(
          RegExp(r'\(Exporté\s+le\s*:\s*\d{2}/\d{2}/\d{4}\s+\d{2}:\d{2}\)'),
          "");
      Class c = Class(
          name: element["summary"].toString(),
          location: element["location"].toString().replaceAll("(V)", ""),
          teacher: RegExp(r'^[^\d\n]+$', multiLine: true).firstMatch(description)?.group(0) ?? "N/A",
          start: DateTime.parse((element["dtstart"] as IcsDateTime).dt).add(Duration(hours: 1)),
          end: DateTime.parse((element["dtend"] as IcsDateTime).dt).add(Duration(hours: 1)),
          type: RegExp(r'_(CM|TD|TP)_').firstMatch(description)?.group(1) ?? "TD");
      classes.add(c);
      // print(description);
      // print(RegExp(r'^[^\d\n]+$', multiLine: false).firstMatch(description)?.group(0));
    }
  });
}