import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/const/school_year.dart';
import '../../../core/session/app_session.dart';
import 'models/classroom_group.dart';
import 'models/classroom_lesson.dart';
import 'models/classroom_student.dart';

class ClassroomStore extends ChangeNotifier {
  ClassroomStore._();

  static final ClassroomStore instance = ClassroomStore._();

  final List<ClassroomGroup> _groups = [];
  final List<ClassroomLesson> _lessons = [];
  int _counter = 0;

  String _newId() => '${++_counter}';

  bool _visible(String subject) {
    final session = AppSession.instance;
    if (!session.hasSubject) return true;
    return AppSession.normalize(subject) == session.subjectKey;
  }

  List<ClassroomGroup> get groups {
    return List.unmodifiable(_groups.where((group) => _visible(group.subject)));
  }

  ClassroomGroup? groupById(String id) {
    for (final group in _groups) {
      if (group.id == id) return group;
    }
    return null;
  }

  ClassroomLesson? lessonById(String id) {
    for (final lesson in _lessons) {
      if (lesson.id == id) return lesson;
    }
    return null;
  }

  List<ClassroomLesson> lessonsOn(int weekday) {
    final result = _lessons
        .where(
          (lesson) =>
              _visible(lesson.subject) && lesson.weekdays.contains(weekday),
        )
        .toList();
    result.sort((a, b) => a.minutes.compareTo(b.minutes));
    return result;
  }

  String? addGroup({
    required String name,
    required SchoolYear year,
    required String subject,
  }) {
    final cleanName = name.trim();
    final exists = _groups.any(
      (group) =>
          _visible(group.subject) &&
          group.year == year &&
          group.name == cleanName,
    );
    if (exists) return 'يوجد مجموعة بنفس الاسم في نفس السنة';
    _groups.add(
      ClassroomGroup(
        id: _newId(),
        name: cleanName,
        subject: subject,
        year: year,
      ),
    );
    notifyListeners();
    return null;
  }

  String? addStudent({
    required String groupId,
    required String name,
    String? username,
  }) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return 'المجموعة غير موجودة';
    final group = _groups[index];
    final cleanUsername = username?.trim().toLowerCase();
    if (cleanUsername != null &&
        group.students.any((student) => student.username == cleanUsername)) {
      return 'هذا الطالب مضاف بالفعل في المجموعة';
    }
    final student = ClassroomStudent(
      id: _newId(),
      name: name.trim(),
      username: cleanUsername,
    );
    _groups[index] = group.copyWith(students: [...group.students, student]);
    notifyListeners();
    return null;
  }

  String? addLesson({
    required String groupId,
    required TimeOfDay time,
    required Set<int> weekdays,
  }) {
    final group = groupById(groupId);
    if (group == null) return 'المجموعة غير موجودة';
    final clash = _lessons.any(
      (lesson) =>
          lesson.groupId == groupId &&
          lesson.time == time &&
          lesson.weekdays.intersection(weekdays).isNotEmpty,
    );
    if (clash) return 'توجد حصة لنفس المجموعة في نفس الوقت واليوم';
    _lessons.add(
      ClassroomLesson(
        id: _newId(),
        groupId: groupId,
        subject: group.subject,
        time: time,
        weekdays: Set.unmodifiable(weekdays),
      ),
    );
    notifyListeners();
    return null;
  }
}
