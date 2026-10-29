import 'package:flutter/widgets.dart';
import '../../../home/data/models/home_tone.dart';

class GroupCardModel {
  const GroupCardModel({
    required this.id,
    required this.title,
    required this.yearLabel,
    required this.studentsCount,
    required this.lessonsCount,
    required this.icon,
    required this.tone,
  });

  final String id;
  final String title;
  final String yearLabel;
  final int studentsCount;
  final int lessonsCount;
  final IconData icon;
  final HomeTone tone;
}
