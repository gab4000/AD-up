import 'package:ad_up/components/period.dart';
import 'package:flutter/material.dart';

import '../utils/class_color_utils.dart';
import '../utils/time_utils.dart';

class Break extends Period {
  const Break({super.key, required super.start, required super.end});

  DateTimeRange<DateTime> get duration => DateTimeRange(start: start, end: end);

  @override
  Widget build(BuildContext context) {
    (Color, Color) color = getColorsFromBreak(context);

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
                Text("Pause",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.access_time_rounded,
                      size: 28,
                    ),
                    Text(durationToString(duration.duration),
                      style: TextStyle(
                          fontSize: 21
                      ),
                    )
                  ],
                )
              ],
            ),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}