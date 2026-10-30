import 'package:flutter/foundation.dart';
import 'models/notification_filter.dart';
import 'models/notification_model.dart';
import 'notification_content.dart';

class NotificationStore extends ChangeNotifier {
  NotificationStore._();

  static final NotificationStore instance = NotificationStore._();

  final List<NotificationModel> _items = NotificationContent.seed();

  int get unreadCount => _items.where((item) => !item.read).length;

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

  void setRead(String id, bool value) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1 || _items[index].read == value) return;
    _items[index] = _items[index].copyWith(read: value);
    notifyListeners();
  }

  void markAllRead() {
    if (unreadCount == 0) return;
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(read: true);
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
