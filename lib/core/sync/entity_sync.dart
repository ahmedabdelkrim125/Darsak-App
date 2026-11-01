import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import '../../feat/attendance/data/attendance_store.dart';
import '../../feat/classroom/data/classroom_store.dart';
import '../../feat/notification/data/notification_store.dart';
import '../../feat/payments/data/payments_store.dart';
import '../database/app_database.dart';
import '../helper/date_key.dart';

typedef _ToRemote =
    Future<Map<String, dynamic>?> Function(
      AppDatabase db,
      String id,
      String userId,
    );
typedef _Apply = Future<void> Function(AppDatabase db, Map<String, dynamic> j);

class _Entity {
  const _Entity({
    required this.key,
    required this.table,
    required this.toRemote,
    required this.apply,
    required this.reload,
  });

  final String key;
  final String table;
  final _ToRemote toRemote;
  final _Apply apply;
  final Future<void> Function() reload;
}

class EntitySync {
  EntitySync(this._dio);

  final Dio _dio;

  static const int _pageSize = 500;
  static const int _batchSize = 100;
  static const int _maxAttempts = 3;
  static final RegExp _usernamePattern = RegExp(r'^[a-z][a-z0-9_.]{2,19}$');

  late final List<_Entity> _entities = [
    _Entity(
      key: 'groups',
      table: 'groups',
      toRemote: _groupToRemote,
      apply: _applyGroup,
      reload: ClassroomStore.instance.load,
    ),
    _Entity(
      key: 'students',
      table: 'students',
      toRemote: _studentToRemote,
      apply: _applyStudent,
      reload: ClassroomStore.instance.load,
    ),
    _Entity(
      key: 'lessons',
      table: 'lessons',
      toRemote: _lessonToRemote,
      apply: _applyLesson,
      reload: ClassroomStore.instance.load,
    ),
    _Entity(
      key: 'payments',
      table: 'payments',
      toRemote: _paymentToRemote,
      apply: _applyPayment,
      reload: PaymentsStore.instance.load,
    ),
    _Entity(
      key: 'attendance',
      table: 'attendance',
      toRemote: _attendanceToRemote,
      apply: _applyAttendance,
      reload: AttendanceStore.instance.load,
    ),
    _Entity(
      key: 'notifications',
      table: 'notifications',
      toRemote: _notificationToRemote,
      apply: _applyNotification,
      reload: NotificationStore.instance.load,
    ),
  ];

  Future<void> resetFailed(AppDatabase db) {
    return (db.update(db.outbox)..where((t) => t.failed.equals(true))).write(
      const OutboxCompanion(failed: Value(false), attempts: Value(0)),
    );
  }

  Future<void> push(AppDatabase db, String userId) async {
    final rows =
        await (db.select(db.outbox)
              ..where((t) => t.failed.equals(false))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();
    if (rows.isEmpty) return;

    for (final entity in _entities) {
      final pending = rows.where((row) => row.entity == entity.key).toList();
      for (var from = 0; from < pending.length; from += _batchSize) {
        final end = from + _batchSize > pending.length
            ? pending.length
            : from + _batchSize;
        await _pushBatch(db, entity, pending.sublist(from, end), userId);
      }
    }
  }

  Future<void> _pushBatch(
    AppDatabase db,
    _Entity entity,
    List<OutboxRow> batch,
    String userId,
  ) async {
    final payload = <Map<String, dynamic>>[];
    final sent = <OutboxRow>[];
    for (final row in batch) {
      final map = await entity.toRemote(db, row.entityId, userId);
      if (map == null) {
        await _drop(db, row.id);
        continue;
      }
      payload.add(map);
      sent.add(row);
    }
    if (payload.isEmpty) return;

    try {
      await _upsert(entity.table, payload);
      for (final row in sent) {
        await _drop(db, row.id);
      }
    } on DioException catch (error) {
      if (!_isRejection(error)) rethrow;
      for (var i = 0; i < payload.length; i++) {
        try {
          await _upsert(entity.table, [payload[i]]);
          await _drop(db, sent[i].id);
        } on DioException catch (single) {
          if (!_isRejection(single)) rethrow;
          await _fail(db, sent[i], single);
        }
      }
    }
  }

  Future<void> _upsert(String table, List<Map<String, dynamic>> rows) {
    return _dio.post<dynamic>(
      '/rest/v1/$table',
      queryParameters: {'on_conflict': 'id'},
      data: rows,
      options: Options(
        headers: {'Prefer': 'resolution=merge-duplicates,return=minimal'},
      ),
    );
  }

  bool _isRejection(DioException error) {
    final code = error.response?.statusCode;
    if (code == null) return false;
    return code >= 400 &&
        code < 500 &&
        code != 401 &&
        code != 408 &&
        code != 429;
  }

  Future<void> _drop(AppDatabase db, int outboxId) {
    return (db.delete(db.outbox)..where((t) => t.id.equals(outboxId))).go();
  }

  Future<void> _fail(AppDatabase db, OutboxRow row, DioException error) {
    final attempts = row.attempts + 1;
    final body = '${error.response?.data}';
    return (db.update(db.outbox)..where((t) => t.id.equals(row.id))).write(
      OutboxCompanion(
        attempts: Value(attempts),
        failed: Value(attempts >= _maxAttempts),
        lastError: Value(body.length > 300 ? body.substring(0, 300) : body),
      ),
    );
  }

  Future<void> pull(AppDatabase db) async {
    final reloads = <Future<void> Function()>{};
    for (final entity in _entities) {
      final changed = await _pullEntity(db, entity);
      if (changed) reloads.add(entity.reload);
    }
    for (final reload in reloads) {
      await reload();
    }
  }

  Future<bool> _pullEntity(AppDatabase db, _Entity entity) async {
    var changed = false;
    var cursor = await _cursor(db, entity.key);
    while (true) {
      final response = await _dio.get<List<dynamic>>(
        '/rest/v1/${entity.table}',
        queryParameters: {
          'select': '*',
          'order': 'updated_at.asc',
          'limit': '$_pageSize',
          if (cursor != null) 'updated_at': 'gt.$cursor',
        },
      );
      final rows = response.data ?? const <dynamic>[];
      if (rows.isEmpty) break;
      final dirty = await _dirtyIds(db, entity.key);
      for (final item in rows) {
        final json = Map<String, dynamic>.from(item as Map);
        if (dirty.contains(json['id'])) continue;
        await entity.apply(db, json);
        changed = true;
      }
      cursor = (rows.last as Map)['updated_at'] as String;
      await _saveCursor(db, entity.key, cursor);
      if (rows.length < _pageSize) break;
    }
    return changed;
  }

  Future<Set<String>> _dirtyIds(AppDatabase db, String entity) async {
    final rows = await (db.select(
      db.outbox,
    )..where((t) => t.entity.equals(entity))).get();
    return {for (final row in rows) row.entityId};
  }

  Future<String?> _cursor(AppDatabase db, String entity) async {
    final row = await (db.select(
      db.syncCursors,
    )..where((t) => t.entity.equals(entity))).getSingleOrNull();
    return row?.cursor;
  }

  Future<void> _saveCursor(AppDatabase db, String entity, String cursor) {
    return db
        .into(db.syncCursors)
        .insertOnConflictUpdate(
          SyncCursorsCompanion(entity: Value(entity), cursor: Value(cursor)),
        );
  }

  String _iso(DateTime value) => value.toUtc().toIso8601String();

  String? _isoOrNull(DateTime? value) => value == null ? null : _iso(value);

  DateTime _dt(Object? value) => DateTime.parse(value as String).toLocal();

  DateTime? _dtOrNull(Object? value) {
    return value is String ? DateTime.parse(value).toLocal() : null;
  }

  String _hms(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m:00';
  }

  int _minutes(Object? value) {
    final parts = '$value'.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  Future<Map<String, dynamic>?> _groupToRemote(
    AppDatabase db,
    String id,
    String userId,
  ) async {
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
      'deleted_at': _isoOrNull(row.deletedAt),
    };
  }

  Future<void> _applyGroup(AppDatabase db, Map<String, dynamic> j) {
    return db
        .into(db.groups)
        .insertOnConflictUpdate(
          GroupsCompanion(
            id: Value(j['id'] as String),
            name: Value(j['name'] as String),
            subject: Value(j['subject'] as String),
            schoolYear: Value(j['school_year'] as String),
            monthlyFee: Value(j['monthly_fee'] as int),
            joinCode: Value(j['join_code'] as String?),
            createdAt: Value(_dt(j['created_at'])),
            updatedAt: Value(_dt(j['updated_at'])),
            deletedAt: Value(_dtOrNull(j['deleted_at'])),
          ),
        );
  }

  Future<Map<String, dynamic>?> _studentToRemote(
    AppDatabase db,
    String id,
    String userId,
  ) async {
    final row = await (db.select(
      db.students,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final username = row.username;
    return {
      'id': row.id,
      'teacher_id': userId,
      'group_id': row.groupId,
      'name': row.name,
      'username': username != null && _usernamePattern.hasMatch(username)
          ? username
          : null,
      'deleted_at': _isoOrNull(row.deletedAt),
    };
  }

  Future<void> _applyStudent(AppDatabase db, Map<String, dynamic> j) {
    return db
        .into(db.students)
        .insertOnConflictUpdate(
          StudentsCompanion(
            id: Value(j['id'] as String),
            groupId: Value(j['group_id'] as String),
            name: Value(j['name'] as String),
            username: Value(j['username'] as String?),
            userId: Value(j['user_id'] as String?),
            createdAt: Value(_dt(j['created_at'])),
            updatedAt: Value(_dt(j['updated_at'])),
            deletedAt: Value(_dtOrNull(j['deleted_at'])),
          ),
        );
  }

  Future<Map<String, dynamic>?> _lessonToRemote(
    AppDatabase db,
    String id,
    String userId,
  ) async {
    final row = await (db.select(
      db.lessons,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return {
      'id': row.id,
      'teacher_id': userId,
      'group_id': row.groupId,
      'subject': row.subject,
      'start_time': _hms(row.startMinutes),
      'end_time': _hms(row.endMinutes),
      'weekdays': row.weekdays
          .split(',')
          .where((part) => part.isNotEmpty)
          .map(int.parse)
          .toList(),
      'place_type': row.placeType,
      'place_name': row.placeName,
      'deleted_at': _isoOrNull(row.deletedAt),
    };
  }

  Future<void> _applyLesson(AppDatabase db, Map<String, dynamic> j) {
    final weekdays = (j['weekdays'] as List).map((day) => '$day').join(',');
    return db
        .into(db.lessons)
        .insertOnConflictUpdate(
          LessonsCompanion(
            id: Value(j['id'] as String),
            groupId: Value(j['group_id'] as String),
            subject: Value(j['subject'] as String),
            startMinutes: Value(_minutes(j['start_time'])),
            endMinutes: Value(_minutes(j['end_time'])),
            weekdays: Value(weekdays),
            placeType: Value(j['place_type'] as String),
            placeName: Value((j['place_name'] as String?) ?? ''),
            createdAt: Value(_dt(j['created_at'])),
            updatedAt: Value(_dt(j['updated_at'])),
            deletedAt: Value(_dtOrNull(j['deleted_at'])),
          ),
        );
  }

  Future<Map<String, dynamic>?> _paymentToRemote(
    AppDatabase db,
    String id,
    String userId,
  ) async {
    final row = await (db.select(
      db.payments,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final month = DateKey.parse(row.month);
    return {
      'id': row.id,
      'teacher_id': userId,
      'group_id': row.groupId,
      'student_id': row.studentId,
      'month': DateKey.of(DateTime(month.year, month.month, 1)),
      'amount': row.amount,
      'paid_at': row.paidAt,
      'deleted_at': _isoOrNull(row.deletedAt),
    };
  }

  Future<void> _applyPayment(AppDatabase db, Map<String, dynamic> j) {
    return db
        .into(db.payments)
        .insertOnConflictUpdate(
          PaymentsCompanion(
            id: Value(j['id'] as String),
            groupId: Value(j['group_id'] as String),
            studentId: Value(j['student_id'] as String),
            month: Value(j['month'] as String),
            amount: Value(j['amount'] as int),
            paidAt: Value(j['paid_at'] as String),
            createdAt: Value(_dt(j['created_at'])),
            updatedAt: Value(_dt(j['updated_at'])),
            deletedAt: Value(_dtOrNull(j['deleted_at'])),
          ),
        );
  }

  Future<Map<String, dynamic>?> _attendanceToRemote(
    AppDatabase db,
    String id,
    String userId,
  ) async {
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
      'deleted_at': _isoOrNull(row.deletedAt),
    };
  }

  Future<void> _applyAttendance(AppDatabase db, Map<String, dynamic> j) {
    return db
        .into(db.attendanceRecords)
        .insertOnConflictUpdate(
          AttendanceRecordsCompanion(
            id: Value(j['id'] as String),
            groupId: Value(j['group_id'] as String),
            studentId: Value(j['student_id'] as String),
            attendanceDate: Value(j['attendance_date'] as String),
            status: Value(j['status'] as String),
            createdAt: Value(_dt(j['created_at'])),
            updatedAt: Value(_dt(j['updated_at'])),
            deletedAt: Value(_dtOrNull(j['deleted_at'])),
          ),
        );
  }

  Future<Map<String, dynamic>?> _notificationToRemote(
    AppDatabase db,
    String id,
    String userId,
  ) async {
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
      'created_at': _iso(row.createdAt),
      'deleted_at': _isoOrNull(row.deletedAt),
    };
  }

  Future<void> _applyNotification(AppDatabase db, Map<String, dynamic> j) {
    return db
        .into(db.notifications)
        .insertOnConflictUpdate(
          NotificationsCompanion(
            id: Value(j['id'] as String),
            type: Value(j['type'] as String),
            title: Value(j['title'] as String),
            body: Value((j['body'] as String?) ?? ''),
            pinned: Value((j['pinned'] as bool?) ?? false),
            isRead: Value((j['is_read'] as bool?) ?? false),
            createdAt: Value(_dt(j['created_at'])),
            updatedAt: Value(_dt(j['updated_at'])),
            deletedAt: Value(_dtOrNull(j['deleted_at'])),
          ),
        );
  }
}
