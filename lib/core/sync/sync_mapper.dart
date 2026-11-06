import 'package:drift/drift.dart';
import '../database/app_database.dart';

class SyncMapper {
  SyncMapper._();

  static const List<String> entities = [
    'groups',
    'students',
    'lessons',
    'payments',
    'attendance',
    'notifications',
  ];

  static String _ts(DateTime value) => value.toUtc().toIso8601String();

  static String? _tsOrNull(DateTime? value) {
    return value == null ? null : _ts(value);
  }

  static DateTime _parse(Object? value) => DateTime.parse(value as String);

  static DateTime? _parseOrNull(Object? value) {
    return value is String ? DateTime.parse(value) : null;
  }

  static String _time(int minutes) {
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  static int _minutes(String value) {
    final parts = value.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  static Future<Map<String, dynamic>?> toRemote(
    AppDatabase db,
    String entity,
    String id,
    String userId,
  ) async {
    switch (entity) {
      case 'groups':
        final row = await (db.select(
          db.groups,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (row == null) return null;
        return {
          'id': row.id,
          'teacher_id': userId,
          'name': row.name,
          'subject': row.subject,
          'school_year': row.schoolYear,
          'monthly_fee': row.monthlyFee,
          'created_at': _ts(row.createdAt),
          'deleted_at': _tsOrNull(row.deletedAt),
        };
      case 'students':
        final row = await (db.select(
          db.students,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (row == null) return null;
        return {
          'id': row.id,
          'teacher_id': userId,
          'group_id': row.groupId,
          'name': row.name,
          'username': row.username,
          'created_at': _ts(row.createdAt),
          'deleted_at': _tsOrNull(row.deletedAt),
        };
      case 'lessons':
        final row = await (db.select(
          db.lessons,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (row == null) return null;
        return {
          'id': row.id,
          'teacher_id': userId,
          'group_id': row.groupId,
          'subject': row.subject,
          'start_time': _time(row.startMinutes),
          'end_time': _time(row.endMinutes),
          'weekdays': row.weekdays
              .split(',')
              .where((part) => part.isNotEmpty)
              .map(int.parse)
              .toList(),
          'place_type': row.placeType,
          'place_name': row.placeName,
          'created_at': _ts(row.createdAt),
          'deleted_at': _tsOrNull(row.deletedAt),
        };
      case 'payments':
        final row = await (db.select(
          db.payments,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (row == null) return null;
        return {
          'id': row.id,
          'teacher_id': userId,
          'group_id': row.groupId,
          'student_id': row.studentId,
          'month': row.month,
          'amount': row.amount,
          'paid_at': row.paidAt,
          'created_at': _ts(row.createdAt),
          'deleted_at': _tsOrNull(row.deletedAt),
        };
      case 'attendance':
        final row = await (db.select(
          db.attendanceRecords,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (row == null) return null;
        return {
          'id': row.id,
          'teacher_id': userId,
          'group_id': row.groupId,
          'student_id': row.studentId,
          'attendance_date': row.attendanceDate,
          'status': row.status,
          'created_at': _ts(row.createdAt),
          'deleted_at': _tsOrNull(row.deletedAt),
        };
      case 'notifications':
        final row = await (db.select(
          db.notifications,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (row == null) return null;
        return {
          'id': row.id,
          'user_id': userId,
          'type': row.type,
          'title': row.title,
          'body': row.body,
          'pinned': row.pinned,
          'is_read': row.isRead,
          'created_at': _ts(row.createdAt),
          'deleted_at': _tsOrNull(row.deletedAt),
        };
    }
    return null;
  }

  static Future<bool> apply(
    AppDatabase db,
    String entity,
    List<Map<String, dynamic>> rows,
    Set<String> skipIds,
  ) async {
    var changed = false;
    await db.transaction(() async {
      for (final json in rows) {
        final id = json['id'] as String;
        if (skipIds.contains(id)) continue;
        final remoteUpdated = _parse(json['updated_at']);
        final known = await _localUpdatedAt(db, entity, id);
        if (known != null &&
            known.millisecondsSinceEpoch ~/ 1000 ==
                remoteUpdated.millisecondsSinceEpoch ~/ 1000) {
          continue;
        }
        await _upsert(db, entity, json, remoteUpdated);
        changed = true;
      }
    });
    return changed;
  }

  static Future<DateTime?> _localUpdatedAt(
    AppDatabase db,
    String entity,
    String id,
  ) async {
    switch (entity) {
      case 'groups':
        return (await (db.select(
          db.groups,
        )..where((t) => t.id.equals(id))).getSingleOrNull())?.updatedAt;
      case 'students':
        return (await (db.select(
          db.students,
        )..where((t) => t.id.equals(id))).getSingleOrNull())?.updatedAt;
      case 'lessons':
        return (await (db.select(
          db.lessons,
        )..where((t) => t.id.equals(id))).getSingleOrNull())?.updatedAt;
      case 'payments':
        return (await (db.select(
          db.payments,
        )..where((t) => t.id.equals(id))).getSingleOrNull())?.updatedAt;
      case 'attendance':
        return (await (db.select(
          db.attendanceRecords,
        )..where((t) => t.id.equals(id))).getSingleOrNull())?.updatedAt;
      case 'notifications':
        return (await (db.select(
          db.notifications,
        )..where((t) => t.id.equals(id))).getSingleOrNull())?.updatedAt;
    }
    return null;
  }

  static Future<void> _upsert(
    AppDatabase db,
    String entity,
    Map<String, dynamic> json,
    DateTime updatedAt,
  ) async {
    final createdAt = _parse(json['created_at']);
    final deletedAt = _parseOrNull(json['deleted_at']);

    switch (entity) {
      case 'groups':
        await db
            .into(db.groups)
            .insertOnConflictUpdate(
              GroupRowCompanion(
                id: Value(json['id'] as String),
                name: Value(json['name'] as String),
                subject: Value(json['subject'] as String),
                schoolYear: Value(json['school_year'] as String),
                monthlyFee: Value((json['monthly_fee'] as num).toInt()),
                joinCode: Value(json['join_code'] as String?),
                createdAt: Value(createdAt),
                updatedAt: Value(updatedAt),
                deletedAt: Value<DateTime?>(deletedAt),
              ),
            );
      case 'students':
        await db
            .into(db.students)
            .insertOnConflictUpdate(
              StudentRowCompanion(
                id: Value(json['id'] as String),
                groupId: Value(json['group_id'] as String),
                name: Value(json['name'] as String),
                username: Value(json['username'] as String?),
                userId: Value(json['user_id'] as String?),
                createdAt: Value(createdAt),
                updatedAt: Value(updatedAt),
                deletedAt: Value<DateTime?>(deletedAt),
              ),
            );
      case 'lessons':
        await db
            .into(db.lessons)
            .insertOnConflictUpdate(
              LessonRowCompanion(
                id: Value(json['id'] as String),
                groupId: Value(json['group_id'] as String),
                subject: Value(json['subject'] as String),
                startMinutes: Value(_minutes(json['start_time'] as String)),
                endMinutes: Value(_minutes(json['end_time'] as String)),
                weekdays: Value(
                  (json['weekdays'] as List)
                      .map((day) => day.toString())
                      .join(','),
                ),
                placeType: Value(json['place_type'] as String),
                placeName: Value((json['place_name'] as String?) ?? ''),
                createdAt: Value(createdAt),
                updatedAt: Value(updatedAt),
                deletedAt: Value<DateTime?>(deletedAt),
              ),
            );
      case 'payments':
        await db
            .into(db.payments)
            .insertOnConflictUpdate(
              PaymentRowCompanion(
                id: Value(json['id'] as String),
                groupId: Value(json['group_id'] as String),
                studentId: Value(json['student_id'] as String),
                month: Value(json['month'] as String),
                amount: Value((json['amount'] as num).toInt()),
                paidAt: Value(json['paid_at'] as String),
                createdAt: Value(createdAt),
                updatedAt: Value(updatedAt),
                deletedAt: Value<DateTime?>(deletedAt),
              ),
            );
      case 'attendance':
        await db
            .into(db.attendanceRecords)
            .insertOnConflictUpdate(
              AttendanceRowCompanion(
                id: Value(json['id'] as String),
                groupId: Value(json['group_id'] as String),
                studentId: Value(json['student_id'] as String),
                attendanceDate: Value(json['attendance_date'] as String),
                status: Value(json['status'] as String),
                createdAt: Value(createdAt),
                updatedAt: Value(updatedAt),
                deletedAt: Value<DateTime?>(deletedAt),
              ),
            );
      case 'notifications':
        await db
            .into(db.notifications)
            .insertOnConflictUpdate(
              NotificationRowCompanion(
                id: Value(json['id'] as String),
                type: Value(json['type'] as String),
                title: Value(json['title'] as String),
                body: Value((json['body'] as String?) ?? ''),
                pinned: Value(json['pinned'] == true),
                isRead: Value(json['is_read'] == true),
                createdAt: Value(createdAt),
                updatedAt: Value(updatedAt),
                deletedAt: Value<DateTime?>(deletedAt),
              ),
            );
    }
  }
}
