import 'package:flutter/widgets.dart';
import '../../../classroom/data/models/classroom_lesson.dart';
import '../../../home/data/models/home_tone.dart';

class ScheduleLessonModel {
  const ScheduleLessonModel({
    required this.id,
    required this.title,
    required this.grade,
    required this.studentsCount,
    required this.startTime,
    required this.endTime,
    required this.placeLabel,
    required this.placeType,
    required this.icon,
    required this.tone,
  });

  final String id;
  final String title;
  final String grade;
  final int studentsCount;
  final String startTime;
  final String endTime;
  final String placeLabel;
  final LessonPlaceType placeType;
  final IconData icon;
  final HomeTone tone;
}
