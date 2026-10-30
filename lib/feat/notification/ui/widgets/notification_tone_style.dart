import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/notification_tone.dart';

class NotificationToneStyle {
  NotificationToneStyle._();

  static Color of(BuildContext context, NotificationTone tone) {
    final palette = context.palette;
    return switch (tone) {
      NotificationTone.primary => palette.primary,
      NotificationTone.accent => palette.accent,
      NotificationTone.success => palette.success,
      NotificationTone.info => const Color(0xFF3B82F6),
      NotificationTone.warning => const Color(0xFFF59E0B),
      NotificationTone.danger => palette.error,
    };
  }
}
