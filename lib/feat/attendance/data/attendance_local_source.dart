import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/helper/date_key.dart';
import 'models/attendance_record.dart';
import 'models/attendance_status.dart';

class AttendanceLocalSource {
  AttendanceLocalSource._();

  static final AttendanceLocalSource instance = AttendanceLocalSource._();

  AppDatabase get _db => DatabaseProvider.instance.db;

  Future<List<AttendanceRecord>> load() async {
    final rows = await (_db.select(
      _db.attendanceRecords,
    )..where((t) => t.deletedAt.isNull())).get();
    return [
      for (final row in rows)
        AttendanceRecord(
          id: row.id,
          studentId: row.studentId,
          groupId: row.groupId,
          date: DateKey.parse(row.attendanceDate),
          status: AttendanceStatus.fromKey(row.status),
        ),
    ];
  }

  Future<void> save(AttendanceRecord record) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await _db
          .into(_db.attendanceRecords)
          .insertOnConflictUpdate(
            AttendanceRecordsCompanion(
              id: Value(record.id),
              groupId: Value(record.groupId),
              studentId: Value(record.studentId),
              attendanceDate: Value(DateKey.of(record.date)),
              status: Value(record.status.key),
              createdAt: Value(now),
              updatedAt: Value(now),
              deletedAt: const Value<DateTime?>(null),
            ),
          );
      await _db.markDirty('attendance', record.id);
    });
  }

  Future<void> delete(String id) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(
        _db.attendanceRecords,
      )..where((t) => t.id.equals(id))).write(
        AttendanceRecordsCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      await _db.markDirty('attendance', id);
    });
  }
}
