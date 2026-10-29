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

  int get studentsTotal {
    return groups.fold(0, (total, group) => total + group.students.length);
  }

  int get weeklyLessonsCount {
    return _lessons
        .where((lesson) => _visible(lesson.subject))
        .fold(0, (total, lesson) => total + lesson.weekdays.length);
  }

  int weeklyLessonsOf(String groupId) {
    return _lessons
        .where((lesson) => lesson.groupId == groupId)
        .fold(0, (total, lesson) => total + lesson.weekdays.length);
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
    result.sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
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

  void deleteGroup(String id) {
    _groups.removeWhere((group) => group.id == id);
    _lessons.removeWhere((lesson) => lesson.groupId == id);
    notifyListeners();
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

  void removeStudent({required String groupId, required String studentId}) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;
    final group = _groups[index];
    _groups[index] = group.copyWith(
      students: group.students
          .where((student) => student.id != studentId)
          .toList(),
    );
    notifyListeners();
  }

  String? addLesson({
    required String groupId,
    required TimeOfDay time,
    required TimeOfDay endTime,
    required Set<int> weekdays,
    required LessonPlaceType placeType,
    String placeName = '',
  }) {
    final group = groupById(groupId);
    if (group == null) return 'المجموعة غير موجودة';
    final start = time.hour * 60 + time.minute;
    final end = endTime.hour * 60 + endTime.minute;
    if (end <= start) return 'وقت النهاية يجب أن يكون بعد وقت البداية';
    final clash = _lessons.any(
      (lesson) =>
          _visible(lesson.subject) &&
          lesson.weekdays.intersection(weekdays).isNotEmpty &&
          start < lesson.endMinutes &&
          lesson.startMinutes < end,
    );
    if (clash) return 'يتعارض مع حصة أخرى في نفس اليوم';
    _lessons.add(
      ClassroomLesson(
        id: _newId(),
        groupId: groupId,
        subject: group.subject,
        time: time,
        endTime: endTime,
        weekdays: Set.unmodifiable(weekdays),
        placeType: placeType,
        placeName: placeName.trim(),
      ),
    );
    notifyListeners();
    return null;
  }

  void deleteLesson(String id) {
    _lessons.removeWhere((lesson) => lesson.id == id);
    notifyListeners();
  }
}
