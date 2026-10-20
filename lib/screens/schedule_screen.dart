import 'package:ad_up/ade/ade_ical.dart';
import 'package:ad_up/components/break.dart';
import 'package:ad_up/components/period.dart';
import 'package:flutter/material.dart';

import '../utils/time_utils.dart';
import 'options_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreen();
}

class _ScheduleScreen extends State<ScheduleScreen> {
  DateTime date = DateTime.now();
  late List<Period> todayClasses = getTodayClasses();

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      locale: Locale("fr", "FR"),
      context: context,
      initialDate: date,
      firstDate: DateTime(2026, 09, 01),
      lastDate: DateTime(2027, 06, 15),
    );

    setState(() {
      date = pickedDate ?? DateTime.now();
      todayClasses = getTodayClasses();
    });
  }

  List<Period> getTodayClasses() {
    List<Period> todayClasses = [];
    todayClasses.addAll(classes.where((element) =>
        element.start.day == date.day
            && element.start.month == date.month
            && element.start.year == date.year).toList() as List<Period>);

    todayClasses.sort((a, b) => a.start.compareTo(b.start));
    List<Period> breaksToAdd = <Period>[];
    for (Period el in todayClasses) {
      int index = todayClasses.indexOf(el);
      if (index == todayClasses.length - 1) continue;
      Period next = todayClasses.elementAt(index + 1);
      if (el.start == next.start || el.end == next.end) continue;
      if (el.end != next.start) breaksToAdd.add(Break(start: el.end, end: next.start));
    }

    todayClasses.addAll(breaksToAdd);
    return todayClasses;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: TextButton(
              onPressed: _selectDate,
              child: Text("${date.day} ${getMonth(date.month)} ${date.year}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontSize: 22
                ),
              )
          ),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OptionsScreen())),
                icon: Icon(Icons.settings_rounded)
            )
          ],
        ),
        body: Center(
          child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: todayClasses.isNotEmpty ? ListView(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                  children: todayClasses..sort((a, b) => a.start.compareTo(b.start))
              ) : Text("Pas de cours aujourd'hui",
                style: TextStyle(
                    fontSize: 24
                ),
              )
          ),
        ),
      )
    );
  }
}