import 'notification_filter.dart';
import 'notification_tone.dart';

enum NotificationType {
  lessonUpcoming(NotificationFilter.lessons, NotificationTone.primary),
  paymentReceived(NotificationFilter.payments, NotificationTone.success),
  studentAbsent(NotificationFilter.students, NotificationTone.accent),
  newMessage(NotificationFilter.students, NotificationTone.info),
  studentJoined(NotificationFilter.students, NotificationTone.primary),
  paymentReminder(NotificationFilter.payments, NotificationTone.danger),
  scheduleChanged(NotificationFilter.lessons, NotificationTone.warning),
  reportReady(NotificationFilter.system, NotificationTone.primary),
  accountVerified(NotificationFilter.system, NotificationTone.success);

  const NotificationType(this.filter, this.tone);

  final NotificationFilter filter;
  final NotificationTone tone;
}
