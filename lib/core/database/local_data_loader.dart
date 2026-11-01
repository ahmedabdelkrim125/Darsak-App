import '../../feat/attendance/data/attendance_store.dart';
import '../../feat/classroom/data/classroom_store.dart';
import '../../feat/notification/data/notification_store.dart';
import '../../feat/payments/data/payments_store.dart';
import '../sync/sync_service.dart';
import 'database_provider.dart';

class LocalDataLoader {
  LocalDataLoader._();

  static final LocalDataLoader instance = LocalDataLoader._();

  Future<void> open(String userId) async {
    await DatabaseProvider.instance.open(userId);
    await ClassroomStore.instance.load();
    await PaymentsStore.instance.load();
    await AttendanceStore.instance.load();
    await NotificationStore.instance.load();
    SyncService.instance.start(userId);
  }

  Future<void> close() async {
    await SyncService.instance.stop();
    ClassroomStore.instance.reset();
    PaymentsStore.instance.reset();
    AttendanceStore.instance.reset();
    NotificationStore.instance.reset();
    await DatabaseProvider.instance.close();
  }
}
