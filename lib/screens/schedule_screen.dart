import 'package:ad_up/components/break.dart';
import 'package:ad_up/components/period.dart';
import 'package:flutter/material.dart';

import '../ade/ade_tree_ids.dart';
import '../utils/time_utils.dart';
import 'options_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreen();
}

class _ScheduleScreen extends State<ScheduleScreen> {
  late DateTime date = DateTime.now();
  late List<Period> todayClasses = getTodayClasses();

  Future<void> _selectDate([DateTime? givenDate]) async {
    if (givenDate == null) {
      final DateTime? pickedDate = await showDatePicker(
        locale: Locale("fr", "FR"),
        context: context,
        initialDate: date,
        firstDate: DateTime(2026, 09, 01),
        lastDate: DateTime(2027, 06, 18),
      );
      date = pickedDate ?? DateTime.now();
    } else {
      date = givenDate;
    }

    setState(() => todayClasses = getTodayClasses());
  }

  List<Period> getTodayClasses() {
    List<Period> todayClasses = [];
    todayClasses.addAll(classes.where((element) =>
        element.start.day == date.day
            && element.start.month == date.month
            && element.start.year == date.year).toList() as List<Period>);

    todayClasses.sort((a, b) => a.start.compareTo(b.start));
    List<Period> breaksToAdd = <Period>[];
    for (Period cl in todayClasses) {
      int index = todayClasses.indexOf(cl);
      if (index == todayClasses.length - 1) continue;

      Period nextCl = todayClasses.elementAt(index + 1);
      if (cl.start == nextCl.start || cl.end == nextCl.end) continue;

      if (cl.end != nextCl.start) breaksToAdd.add(Break(start: cl.end, end: nextCl.start));
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