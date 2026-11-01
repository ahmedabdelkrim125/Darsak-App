import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../feat/classroom/data/classroom_store.dart';
import '../helper/time_formatter.dart';
import '../session/app_session.dart';
import '../settings/app_settings.dart';
import 'notification_service.dart';

class LessonReminderService {
  LessonReminderService._();

  static final LessonReminderService instance = LessonReminderService._();

  Timer? _debounce;
  bool _listening = false;
  bool _running = false;
  bool _again = false;

  void start() {
    if (!_listening) {
      ClassroomStore.instance.addListener(_request);
      AppSettings.instance.addListener(_request);
      _listening = true;
    }
    _request();
  }

  Future<void> stop() async {
    if (_listening) {
      ClassroomStore.instance.removeListener(_request);
      AppSettings.instance.removeListener(_request);
      _listening = false;
    }
    _debounce?.cancel();
    _debounce = null;
    await NotificationService.instance.cancelAll();
  }

  void _request() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      unawaited(_apply());
    });
  }

  Future<void> _apply() async {
    if (_running) {
      _again = true;
      return;
    }
    _running = true;
    try {
      final service = NotificationService.instance;
      await service.cancelLessonReminders();
      final settings = AppSettings.instance;
      if (!settings.notifyLessons || !AppSession.instance.isSignedIn) return;

      final store = ClassroomStore.instance;
      final minutes = settings.reminderMinutes;
      final now = tz.TZDateTime.now(tz.local);
      var id = 1;
      for (var weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++) {
        for (final lesson in store.lessonsOn(weekday)) {
          final group = store.groupById(lesson.groupId);
          if (group == null) continue;
          await service.scheduleWeekly(
            id: id++,
            title: 'حصتك بعد ${_label(minutes)}',
            body:
                '${lesson.subject} - ${group.name} الساعة ${formatTime(lesson.time)}',
            firstFire: _nextFire(now, weekday, lesson.time, minutes),
            payload: '${NotificationService.lessonPayloadPrefix}${lesson.id}',
          );
        }
      }
    } finally {
      _running = false;
      if (_again) {
        _again = false;
        _request();
      }
    }
  }

  tz.TZDateTime _nextFire(
    tz.TZDateTime now,
    int weekday,
    TimeOfDay time,
    int minutes,
  ) {
    for (var offset = 0; offset <= 7; offset++) {
      final day = now.add(Duration(days: offset));
      if (day.weekday != weekday) continue;
      final start = tz.TZDateTime(
        tz.local,
        day.year,
        day.month,
        day.day,
        time.hour,
        time.minute,
      );
      final fire = start.subtract(Duration(minutes: minutes));
      if (fire.isAfter(now)) return fire;
    }
    return now.add(const Duration(days: 7));
  }

  String _label(int minutes) {
    if (minutes == 60) return 'ساعة';
    if (minutes <= 10) return '$minutes دقائق';
    return '$minutes دقيقة';
  }
}
