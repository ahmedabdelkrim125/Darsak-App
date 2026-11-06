import 'dart:async';
import '../../feat/attendance/data/attendance_store.dart';
import '../../feat/classroom/data/classroom_store.dart';
import '../../feat/notification/data/notification_store.dart';
import '../../feat/payments/data/payments_store.dart';
import '../notifications/push_service.dart';
import '../sync/profile_sync.dart';
import '../sync/sync_engine.dart';
import 'database_provider.dart';

class LocalDataLoader {
  LocalDataLoader._();

  static final LocalDataLoader instance = LocalDataLoader._();

  Future<void> open(String userId) async {
    await DatabaseProvider.instance.open(userId);
    await reload();
    ProfileSync.instance.attach();
    SyncEngine.instance.start();
    unawaited(PushService.instance.onLogin());
    unawaited(SyncEngine.instance.syncNow());
  }

  Future<void> reload() async {
    await ClassroomStore.instance.load();
    await PaymentsStore.instance.load();
    await AttendanceStore.instance.load();
    await NotificationStore.instance.load();
  }

  Future<void> close() async {
    if (DatabaseProvider.instance.isOpen) {
      await SyncEngine.instance.flush();
      await PushService.instance.onLogout();
    }
    SyncEngine.instance.stop();
    ClassroomStore.instance.reset();
    PaymentsStore.instance.reset();
    AttendanceStore.instance.reset();
    NotificationStore.instance.reset();
    await DatabaseProvider.instance.close();
  }
}
