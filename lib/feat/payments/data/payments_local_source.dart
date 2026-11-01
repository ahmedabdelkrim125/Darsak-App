import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/helper/date_key.dart';
import 'models/payment_record.dart';

class PaymentsLocalSource {
  PaymentsLocalSource._();

  static final PaymentsLocalSource instance = PaymentsLocalSource._();

  AppDatabase get _db => DatabaseProvider.instance.db;

  Future<List<PaymentRecord>> load() async {
    final rows = await (_db.select(
      _db.payments,
    )..where((t) => t.deletedAt.isNull())).get();
    return [
      for (final row in rows)
        PaymentRecord(
          id: row.id,
          studentId: row.studentId,
          groupId: row.groupId,
          month: DateKey.parse(row.month),
          amount: row.amount,
          paidAt: DateKey.parse(row.paidAt),
        ),
    ];
  }

  Future<void> saveRecord(PaymentRecord record) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await _db
          .into(_db.payments)
          .insertOnConflictUpdate(
            PaymentRowCompanion(
              id: Value(record.id),
              groupId: Value(record.groupId),
              studentId: Value(record.studentId),
              month: Value(DateKey.of(record.month)),
              amount: Value(record.amount),
              paidAt: Value(DateKey.of(record.paidAt)),
              createdAt: Value(now),
              updatedAt: Value(now),
              deletedAt: const Value<DateTime?>(null),
            ),
          );
      await _db.markDirty('payments', record.id);
    });
  }

  Future<void> deleteRecord(String id) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(_db.payments)..where((t) => t.id.equals(id))).write(
        PaymentRowCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await _db.markDirty('payments', id);
    });
  }
}