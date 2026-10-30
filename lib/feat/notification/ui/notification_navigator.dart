import 'package:flutter/material.dart';
import '../../../core/routing/routes.dart';

class NotificationNavigator {
  NotificationNavigator._();

  static Future<void> open(BuildContext context) {
    return Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(Routes.notifications);
  }
}
