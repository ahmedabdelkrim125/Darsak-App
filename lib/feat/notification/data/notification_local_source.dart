import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import 'models/notification_model.dart';
import 'models/notification_type.dart';

class NotificationLocalSource {
  NotificationLocalSource._();

  static final NotificationLocalSource instance = NotificationLocalSource._();

  AppDatabase get _db => DatabaseProvider.instance.db;

  Future<List<NotificationModel>> load() async {
    final rows =
        await (_db.select(_db.notifications)
              ..where((t) => t.deletedAt.isNull())
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    return [
      for (final row in rows)
        NotificationModel(
          id: row.id,
          type: NotificationType.fromKey(row.type),
          title: row.title,
          body: row.body,
          time: row.createdAt,
          read: row.isRead,
          pinned: row.pinned,
        ),
    ];
  }

  Future<void> saveMany(List<NotificationModel> items) {
    final now = DateTime.now();
    return _db.transaction(() async {
      for (final item in items) {
        await _db
            .into(_db.notifications)
            .insertOnConflictUpdate(
              NotificationRowCompanion(
                id: Value(item.id),
                type: Value(item.type.key),
                title: Value(item.title),
                body: Value(item.body),
                pinned: Value(item.pinned),
                isRead: Value(item.read),
                createdAt: Value(item.time),
                updatedAt: Value(now),
                deletedAt: const Value<DateTime?>(null),
              ),
            );
        await _db.markDirty('notifications', item.id);
      }
    });
  }

  Future<void> delete(String id) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(_db.notifications)..where((t) => t.id.equals(id)))
          .write(
            NotificationRowCompanion(
              deletedAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      await _db.markDirty('notifications', id);
    });
  }
}
