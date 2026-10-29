import 'package:flutter/material.dart';

enum LessonPlaceType { online, onsite }

class ClassroomLesson {
  const ClassroomLesson({
    required this.id,
    required this.groupId,
    required this.subject,
    required this.time,
    required this.endTime,
    required this.weekdays,
    required this.placeType,
    this.placeName = '',
  });

  final String id;
  final String groupId;
  final String subject;
  final TimeOfDay time;
  final TimeOfDay endTime;
  final Set<int> weekdays;
  final LessonPlaceType placeType;
  final String placeName;

  int get startMinutes => time.hour * 60 + time.minute;
  int get endMinutes => endTime.hour * 60 + endTime.minute;

  String get placeLabel {
    return switch (placeType) {
      LessonPlaceType.online =>
        placeName.isEmpty ? 'أونلاين' : '$placeName - أونلاين',
      LessonPlaceType.onsite => placeName.isEmpty ? 'حضوري' : placeName,
    };
  }
}
