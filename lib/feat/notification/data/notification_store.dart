import 'package:flutter/foundation.dart';
import '../../../core/database/run_local.dart';
import '../../../core/helper/id_generator.dart';
import 'models/notification_filter.dart';
import 'models/notification_model.dart';
import 'models/notification_type.dart';
import 'notification_local_source.dart';

class NotificationStore extends ChangeNotifier {
  NotificationStore._();

  static final NotificationStore instance = NotificationStore._();

  final List<NotificationModel> _items = [];

  int get unreadCount => _items.where((item) => !item.read).length;

  Future<void> load() async {
    final loaded = await NotificationLocalSource.instance.load();
    _items
      ..clear()
      ..addAll(loaded);
    notifyListeners();
  }

  List<NotificationModel> filtered(NotificationFilter filter) {
    final list = _items
        .where(
          (item) =>
              filter == NotificationFilter.all || item.type.filter == filter,
        )
        .toList();
    list.sort((a, b) => b.time.compareTo(a.time));
    return list;
  }

  void add({
    required NotificationType type,
    required String title,
    required String body,
    bool pinned = false,
  }) {
    final item = NotificationModel(
      id: IdGenerator.newId(),
      type: type,
      title: title,
      body: body,
      time: DateTime.now(),
      pinned: pinned,
    );
    _items.add(item);
    runLocal(() => NotificationLocalSource.instance.saveMany([item]));
    notifyListeners();
  }

  void setRead(String id, bool value) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1 || _items[index].read == value) return;
    final updated = _items[index].copyWith(read: value);
    _items[index] = updated;
    runLocal(() => NotificationLocalSource.instance.saveMany([updated]));
    notifyListeners();
  }

  void markAllRead() {
    final changed = <NotificationModel>[];
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].read) continue;
      final updated = _items[i].copyWith(read: true);
      _items[i] = updated;
      changed.add(updated);
    }
    if (changed.isEmpty) return;
    runLocal(() => NotificationLocalSource.instance.saveMany(changed));
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((item) => item.id == id);
    runLocal(() => NotificationLocalSource.instance.delete(id));
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }
}