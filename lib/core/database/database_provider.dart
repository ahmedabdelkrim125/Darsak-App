import 'package:drift_flutter/drift_flutter.dart';
import 'app_database.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider instance = DatabaseProvider._();

  AppDatabase? _db;
  String? _userId;

  bool get isOpen => _db != null;

  String? get userId => _userId;

  AppDatabase get db {
    final value = _db;
    if (value == null) throw StateError('Database is not open');
    return value;
  }

  Future<void> open(String userId) async {
    if (_userId == userId && _db != null) return;
    await close();
    _db = AppDatabase(driftDatabase(name: 'darsak_$userId'));
    _userId = userId;
  }

  Future<void> close() async {
    final current = _db;
    _db = null;
    _userId = null;
    await current?.close();
  }
}