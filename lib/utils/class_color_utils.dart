import 'package:flutter/material.dart';

(Color, Color) getColorsFromClass(BuildContext context, String className) {
  int hash = 0;
  for (int i = 0; i < className.length; i++) {
    hash = className.codeUnitAt(i) + ((hash << 5) - hash);
  }

  int factor = Theme.brightnessOf(context).index == 0 ? 1 : -1;
  double added = 30/255;

  Color color1 = HSLColor.fromAHSL(0.7, hash.toDouble() % 360, 1, (factor + 0.3).abs() % 1).toColor();
  Color color2 = Color.from(
      alpha: 1,
      blue: color1.b + factor * added,
      red: color1.r + factor * added,
      green: color1.g + factor * added
  );

  return (color1, color2);
}

(Color, Color) getColorsFromBreak(BuildContext context) {

  int factor = Theme.brightnessOf(context).index == 0 ? 1 : -1;
  double added = 30/255;

  Color color1 = HSLColor.fromAHSL(1, 0, 0, (factor + 0.3).abs() % 1).toColor();
  Color color2 = Color.from(
      alpha: 1,
      blue: color1.b + factor * added,
      red: color1.r + factor * added,
      green: color1.g + factor * added
  );

  return (color1, color2);
}