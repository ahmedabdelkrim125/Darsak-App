import 'notification_filter.dart';
import 'notification_tone.dart';

enum NotificationType {
  lessonUpcoming(
    'lesson_upcoming',
    NotificationFilter.lessons,
    NotificationTone.primary,
  ),
  paymentReceived(
    'payment_received',
    NotificationFilter.payments,
    NotificationTone.success,
  ),
  studentAbsent(
    'student_absent',
    NotificationFilter.students,
    NotificationTone.accent,
  ),
  newMessage(
    'new_message',
    NotificationFilter.students,
    NotificationTone.info,
  ),
  studentJoined(
    'student_joined',
    NotificationFilter.students,
    NotificationTone.primary,
  ),
  paymentReminder(
    'payment_reminder',
    NotificationFilter.payments,
    NotificationTone.danger,
  ),
  scheduleChanged(
    'schedule_changed',
    NotificationFilter.lessons,
    NotificationTone.warning,
  ),
  reportReady(
    'report_ready',
    NotificationFilter.system,
    NotificationTone.primary,
  ),
  accountVerified(
    'account_verified',
    NotificationFilter.system,
    NotificationTone.success,
  ),
  verificationRejected(
    'verification_rejected',
    NotificationFilter.system,
    NotificationTone.danger,
  ),
  general('general', NotificationFilter.system, NotificationTone.primary);

  const NotificationType(this.key, this.filter, this.tone);

  final String key;
  final NotificationFilter filter;
  final NotificationTone tone;

  static NotificationType fromKey(String key) {
    return values.firstWhere(
      (type) => type.key == key,
      orElse: () => NotificationType.general,
    );
  }
}
