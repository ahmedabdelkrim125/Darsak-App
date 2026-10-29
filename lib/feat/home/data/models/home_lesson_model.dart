import 'home_tone.dart';

class HomeLessonModel {
  const HomeLessonModel({
    required this.id,
    required this.title,
    required this.grade,
    required this.studentsCount,
    required this.time,
    required this.tone,
  });

  final String id;
  final String title;
  final String grade;
  final int studentsCount;
  final String time;
  final HomeTone tone;
}
