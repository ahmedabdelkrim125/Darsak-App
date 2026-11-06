import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'notification_channels.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  static const String _exactAskedKey = 'exact_alarm_asked';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;
  int _counter = 0;

  bool get isReady => _ready;

  AndroidFlutterLocalNotificationsPlugin? get _android {
    return _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
  }

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      NotificationChannels.alertsId,
      NotificationChannels.alertsName,
      channelDescription: NotificationChannels.alertsDescription,
      icon: NotificationChannels.iconName,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound(NotificationChannels.soundName),
    ),
  );

  Future<void> init({void Function(String? payload)? onTap}) async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Notify] timezone: $error');
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(NotificationChannels.iconName),
      ),
      onDidReceiveNotificationResponse: (response) =>
          onTap?.call(response.payload),
    );

    await _android?.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.alertsId,
        NotificationChannels.alertsName,
        description: NotificationChannels.alertsDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound(
          NotificationChannels.soundName,
        ),
      ),
    );
    _ready = true;
  }

  Future<bool> requestPermission() async {
    final granted = await _android?.requestNotificationsPermission();
    return granted ?? true;
  }

  Future<void> askExactAlarmsOnce() async {
    final android = _android;
    if (android == null) return;
    final can = await android.canScheduleExactNotifications() ?? false;
    if (can) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_exactAskedKey) ?? false) return;
    await prefs.setBool(_exactAskedKey, true);
    await android.requestExactAlarmsPermission();
  }

  Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_ready) return;
    _counter = (_counter + 1) % 100000;
    await _plugin.show(
      id: 900000 + _counter,
      title: title,
      body: body,
      notificationDetails: _details,
      payload: payload,
    );
  }

  Future<void> scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required int weekday,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    if (!_ready) return;
    final can = await _android?.canScheduleExactNotifications() ?? false;
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextWeekly(weekday, hour, minute),
      notificationDetails: _details,
      androidScheduleMode: can
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancelReminders() async {
    if (!_ready) return;
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      final payload = request.payload ?? '';
      if (payload.startsWith(NotificationChannels.reminderPayloadPrefix)) {
        await _plugin.cancel(id: request.id);
      }
    }
  }

  tz.TZDateTime _nextWeekly(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    for (var i = 0; i < 8; i++) {
      final candidate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + i,
        hour,
        minute,
      );
      if (candidate.weekday == weekday && candidate.isAfter(now)) {
        return candidate;
      }
    }
    return now.add(const Duration(days: 7));
  }
}
