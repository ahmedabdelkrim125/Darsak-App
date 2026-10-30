import 'package:flutter/foundation.dart';
import 'notification_type.dart';

@immutable
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.read = false,
    this.pinned = false,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime time;
  final bool read;
  final bool pinned;

  NotificationModel copyWith({bool? read}) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      body: body,
      time: time,
      read: read ?? this.read,
      pinned: pinned,
    );
  }
}
