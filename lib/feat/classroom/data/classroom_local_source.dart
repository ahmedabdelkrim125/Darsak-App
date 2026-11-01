import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import '../../../core/const/school_year.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import 'models/classroom_group.dart';
import 'models/classroom_lesson.dart';
import 'models/classroom_student.dart';

class ClassroomSnapshot {
  const ClassroomSnapshot({required this.groups, required this.lessons});

  final List<ClassroomGroup> groups;
  final List<ClassroomLesson> lessons;
}

class ClassroomLocalSource {
  ClassroomLocalSource._();

  static final ClassroomLocalSource instance = ClassroomLocalSource._();

  AppDatabase get _db => DatabaseProvider.instance.db;

  Future<ClassroomSnapshot> load() async {
    final groupRows =
        await (_db.select(_db.groups)
              ..where((t) => t.deletedAt.isNull())
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();
    final studentRows =
        await (_db.select(_db.students)
              ..where((t) => t.deletedAt.isNull())
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();
    final lessonRows =
        await (_db.select(_db.lessons)
              ..where((t) => t.deletedAt.isNull())
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();

    final byGroup = <String, List<ClassroomStudent>>{};
    for (final row in studentRows) {
      byGroup
          .putIfAbsent(row.groupId, () => [])
          .add(
            ClassroomStudent(
              id: row.id,
              name: row.name,
              username: row.username,
            ),
          );
    }

    final groups = [
      for (final row in groupRows)
        ClassroomGroup(
          id: row.id,
          name: row.name,
          subject: row.subject,
          year: _yearOf(row.schoolYear),
          monthlyFee: row.monthlyFee,
          students: byGroup[row.id] ?? const [],
        ),
    ];

    final lessons = [
      for (final row in lessonRows)
        ClassroomLesson(
          id: row.id,
          groupId: row.groupId,
          subject: row.subject,
          time: TimeOfDay(
            hour: row.startMinutes ~/ 60,
            minute: row.startMinutes % 60,
          ),
          endTime: TimeOfDay(
            hour: row.endMinutes ~/ 60,
            minute: row.endMinutes % 60,
          ),
          weekdays: Set.unmodifiable(_weekdaysOf(row.weekdays)),
          placeType: row.placeType == 'online'
              ? LessonPlaceType.online
              : LessonPlaceType.onsite,
          placeName: row.placeName,
        ),
    ];

    return ClassroomSnapshot(groups: groups, lessons: lessons);
  }

  Future<void> saveGroup(ClassroomGroup group) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await _db
          .into(_db.groups)
          .insertOnConflictUpdate(
            GroupsCompanion(
              id: Value(group.id),
              name: Value(group.name),
              subject: Value(group.subject),
              schoolYear: Value(group.year.name),
              monthlyFee: Value(group.monthlyFee),
              createdAt: Value(now),
              updatedAt: Value(now),
              deletedAt: const Value<DateTime?>(null),
            ),
          );
      await _db.markDirty('groups', group.id);
    });
  }

  Future<void> deleteGroup(String id) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(_db.groups)..where((t) => t.id.equals(id))).write(
        GroupsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await _db.markDirty('groups', id);
      await (_db.update(
        _db.students,
      )..where((t) => t.groupId.equals(id) & t.deletedAt.isNull())).write(
        StudentsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await (_db.update(
        _db.lessons,
      )..where((t) => t.groupId.equals(id) & t.deletedAt.isNull())).write(
        LessonsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }

  Future<void> saveStudent({
    required String groupId,
    required ClassroomStudent student,
  }) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await _db
          .into(_db.students)
          .insertOnConflictUpdate(
            StudentsCompanion(
              id: Value(student.id),
              groupId: Value(groupId),
              name: Value(student.name),
              username: Value(student.username),
              createdAt: Value(now),
              updatedAt: Value(now),
              deletedAt: const Value<DateTime?>(null),
            ),
          );
      await _db.markDirty('students', student.id);
    });
  }

  Future<void> deleteStudent(String id) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(_db.students)..where((t) => t.id.equals(id))).write(
        StudentsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await _db.markDirty('students', id);
    });
  }

  Future<void> saveLesson(ClassroomLesson lesson) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await _db
          .into(_db.lessons)
          .insertOnConflictUpdate(
            LessonsCompanion(
              id: Value(lesson.id),
              groupId: Value(lesson.groupId),
              subject: Value(lesson.subject),
              startMinutes: Value(lesson.startMinutes),
              endMinutes: Value(lesson.endMinutes),
              weekdays: Value(lesson.weekdays.join(',')),
              placeType: Value(lesson.placeType.name),
              placeName: Value(lesson.placeName),
              createdAt: Value(now),
              updatedAt: Value(now),
              deletedAt: const Value<DateTime?>(null),
            ),
          );
      await _db.markDirty('lessons', lesson.id);
    });
  }

  Future<void> deleteLesson(String id) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(_db.lessons)..where((t) => t.id.equals(id))).write(
        LessonsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await _db.markDirty('lessons', id);
    });
  }

  SchoolYear _yearOf(String name) {
    return SchoolYear.values.firstWhere(
      (year) => year.name == name,
      orElse: () => SchoolYear.primary1,
    );
  }

  Set<int> _weekdaysOf(String csv) {
    return csv
        .split(',')
        .where((part) => part.isNotEmpty)
        .map(int.parse)
        .toSet();
  }
}