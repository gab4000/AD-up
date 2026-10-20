import 'package:ad_up/components/period.dart';
import 'package:ad_up/utils/class_color_utils.dart';
import 'package:flutter/material.dart';

import '../utils/time_utils.dart';

class Class extends Period {
  const Class({super.key, required this.name, required this.teacher, required this.location, required super.start, required super.end, this.type = "TD"});

  final String name;
  final String teacher;
  final String location;
  DateTimeRange<DateTime> get duration => DateTimeRange(start: start, end: end);
  final String type;

  @override
  Widget build(BuildContext context) {
    (Color, Color) color = getColorsFromClass(context, name);

    return Card(
      color: color.$1,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: color.$2,
              width: 3
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(name.length > 18 ? "${name.substring(0, 15)}..." : name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.person_rounded,
                      size: 24,
                    ),
                    Text(teacher.length > 20 ? "${teacher.substring(0, 17)}..." : teacher,
                      style: TextStyle(
                          fontSize: 18
                      ),
                    )
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.place_rounded,
                      size: 24,
                    ),
                    Text(location.isNotEmpty ? location.length > 20 ? "${location.substring(0, 17)}..." : location : "Non précisé",
                      style: TextStyle(
                          fontSize: 18
                      ),
                    )
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.access_time_filled_rounded,
                      size: 24,
                    ),
                    Text(durationToString(duration.duration),
                      style: TextStyle(
                          fontSize: 18
                      ),
                    )
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: formatTime(start),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.inverseSurface
                          )
                        ),
                        WidgetSpan(
                            child: Icon(Icons.arrow_right_alt_rounded)
                        ),
                        TextSpan(
                            text: formatTime(end),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.inverseSurface
                            )
                        ),
                      ],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    )
                ),
                Container(
                  alignment: AlignmentGeometry.bottomCenter,
                  height: 100,
                  child: Text(type,
                    style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: color.$2
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}