import 'package:flutter/cupertino.dart';

abstract class Period extends StatelessWidget {
  const Period({super.key, required this.start, required this.end});
  final DateTime start;
  final DateTime end;

  @override
  Widget build(BuildContext context);
}