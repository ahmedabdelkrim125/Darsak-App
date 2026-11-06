import 'package:drift/drift.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Groups,
    Students,
    Lessons,
    Payments,
    AttendanceRecords,
    Notifications,
    Outbox,
    SyncCursors,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(outbox, outbox.payload);
      }
    },
  );

  Future<void> markDirty(
    String entity,
    String entityId, {
    String? payload,
  }) async {
    await (delete(
      outbox,
    )..where((t) => t.entity.equals(entity) & t.entityId.equals(entityId))).go();
    await into(outbox).insert(
      OutboxRowCompanion.insert(
        entity: entity,
        entityId: entityId,
        createdAt: DateTime.now(),
        payload: Value(payload),
      ),
    );
  }
}
