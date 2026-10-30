import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'models/notification_filter.dart';
import 'models/notification_type.dart';

class NotificationIcons {
  NotificationIcons._();

  static IconData ofType(NotificationType type) {
    return switch (type) {
      NotificationType.lessonUpcoming => SolarIconsBold.calendar,
      NotificationType.paymentReceived => SolarIconsBold.wallet,
      NotificationType.studentAbsent => SolarIconsBold.usersGroupRounded,
      NotificationType.newMessage => SolarIconsBold.chatRoundDots,
      NotificationType.studentJoined => SolarIconsBold.userPlus,
      NotificationType.paymentReminder => SolarIconsBold.dangerCircle,
      NotificationType.scheduleChanged => SolarIconsBold.clockCircle,
      NotificationType.reportReady => SolarIconsBold.document,
      NotificationType.accountVerified => SolarIconsBold.shieldCheck,
    };
  }

  static IconData ofFilter(NotificationFilter filter) {
    return switch (filter) {
      NotificationFilter.all => SolarIconsOutline.bell,
      NotificationFilter.lessons => SolarIconsOutline.calendar,
      NotificationFilter.payments => SolarIconsOutline.wallet,
      NotificationFilter.students => SolarIconsOutline.usersGroupRounded,
      NotificationFilter.system => SolarIconsOutline.settings,
    };
  }
}
