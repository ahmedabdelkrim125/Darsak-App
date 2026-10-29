import 'package:flutter/material.dart';

String formatTime(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final suffix = time.period == DayPeriod.am ? 'ص' : 'م';
  return '$hour:$minute $suffix';
}
