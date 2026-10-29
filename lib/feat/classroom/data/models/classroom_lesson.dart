import 'package:flutter/material.dart';

class ClassroomLesson {
  const ClassroomLesson({
    required this.id,
    required this.groupId,
    required this.subject,
    required this.time,
    required this.weekdays,
  });

  final String id;
  final String groupId;
  final String subject;
  final TimeOfDay time;
  final Set<int> weekdays;

  int get minutes => time.hour * 60 + time.minute;
}
