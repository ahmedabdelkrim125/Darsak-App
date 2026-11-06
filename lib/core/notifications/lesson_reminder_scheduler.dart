import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../feat/classroom/data/classroom_store.dart';
import '../../feat/classroom/data/models/classroom_lesson.dart';
import '../helper/time_formatter.dart';
import '../session/app_session.dart';
import '../settings/app_settings.dart';
import 'local_notification_service.dart';
import 'notification_channels.dart';

class LessonReminderScheduler {
  LessonReminderScheduler._();

  static final LessonReminderScheduler instance = LessonReminderScheduler._();

  Timer? _debounce;
  bool _started = false;
  bool _busy = false;
  bool _again = false;

  void start() {
    if (_started) return;
    _started = true;
    ClassroomStore.instance.addListener(_request);
    AppSettings.instance.addListener(_request);
    AppSession.instance.addListener(_request);
    _request();
  }

  void _request() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () => unawaited(_run()));
  }

  Future<void> _run() async {
    if (_busy) {
      _again = true;
      return;
    }
    _busy = true;
    try {
      await _reschedule();
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Reminders] $error');
    } finally {
      _busy = false;
      if (_again) {
        _again = false;
        _request();
      }
    }
  }

  Future<void> _reschedule() async {
    final service = LocalNotificationService.instance;
    if (!service.isReady) return;
    await service.cancelReminders();

    final settings = AppSettings.instance;
    if (!AppSession.instance.isSignedIn || !settings.notifyLessons) return;

    final lead = settings.reminderMinutes;
    final store = ClassroomStore.instance;
    var scheduled = 0;

    for (var weekday = 1; weekday <= 7; weekday++) {
      for (final lesson in store.lessonsOn(weekday)) {
        var minutes = lesson.startMinutes - lead;
        var day = weekday;
        if (minutes < 0) {
          minutes += 1440;
          day = weekday == 1 ? 7 : weekday - 1;
        }
        final group = store.groupById(lesson.groupId);
        await service.scheduleWeekly(
          id: _idFor(lesson.id, weekday),
          title: _title(lesson.subject, lead),
          body: _body(group?.name, lesson),
          weekday: day,
          hour: minutes ~/ 60,
          minute: minutes % 60,
          payload: '${NotificationChannels.reminderPayloadPrefix}${lesson.id}',
        );
        scheduled++;
      }
    }

    if (scheduled > 0) await service.askExactAlarmsOnce();
  }

  int _idFor(String lessonId, int weekday) {
    var hash = 2166136261;
    for (final unit in lessonId.codeUnits) {
      hash = ((hash ^ unit) * 16777619) & 0x0fffffff;
    }
    return hash * 8 + weekday;
  }

  String _title(String subject, int lead) {
    return 'حصة $subject بعد ${_leadLabel(lead)}';
  }

  String _leadLabel(int lead) {
    if (lead == 60) return 'ساعة';
    if (lead >= 3 && lead <= 10) return '$lead دقائق';
    return '$lead دقيقة';
  }

  String _body(String? groupName, ClassroomLesson lesson) {
    final parts = <String>[
      if (groupName != null && groupName.isNotEmpty) groupName,
      'الساعة ${formatTime(lesson.time)}',
      if (lesson.placeName.isNotEmpty) lesson.placeName,
    ];
    return parts.join(' · ');
  }
}
