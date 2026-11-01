import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../routing/app_navigator.dart';
import '../routing/routes.dart';
import '../session/app_session.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String lessonPayloadPrefix = 'lesson:';

  static const String _channelId = 'darsak_alerts_v1';
  static const String _channelName = 'تنبيهات درسّك';
  static const String _channelDescription =
      'تنبيهات الحصص والمدفوعات والمجموعات';
  static const String _soundName = 'darsak_notification';
  static const String _statIcon = 'ic_stat_notification';
  static const String _exactAskedKey = 'notifications.exact_alarm_asked';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _ready = false;
  int _immediateCounter = 0;

  AndroidFlutterLocalNotificationsPlugin? get _android {
    return _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
  }

  Future<void> init() async {
    if (_ready) return;
    try {
      tz_data.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
      await _plugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings(_statIcon),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (_) => _openInbox(),
      );
      await _android?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(_soundName),
          enableVibration: true,
        ),
      );
      _ready = true;
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Notifications] init: $error');
    }
  }

  Future<void> requestPermissions() async {
    if (!_ready) return;
    try {
      await _android?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await _askExactAlarmOnce();
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Notifications] permissions: $error');
    }
  }

  Future<void> _askExactAlarmOnce() async {
    final android = _android;
    if (android == null) return;
    final can = await android.canScheduleExactNotifications() ?? true;
    if (can) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_exactAskedKey) ?? false) return;
    await prefs.setBool(_exactAskedKey, true);
    await android.requestExactAlarmsPermission();
  }

  NotificationDetails _details(String body) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound(_soundName),
        enableVibration: true,
        icon: _statIcon,
        styleInformation: BigTextStyleInformation(body),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> show({required String title, required String body}) async {
    if (!_ready) return;
    try {
      _immediateCounter++;
      final id = 1000000 + (_immediateCounter % 1000000);
      await _plugin.show(id, title, body, _details(body));
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Notifications] show: $error');
    }
  }

  Future<void> scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime firstFire,
    required String payload,
  }) async {
    if (!_ready) return;
    try {
      final exact = await _android?.canScheduleExactNotifications() ?? false;
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        firstFire,
        _details(body),
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: payload,
      );
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Notifications] schedule: $error');
    }
  }

  Future<void> cancelLessonReminders() async {
    if (!_ready) return;
    try {
      final pending = await _plugin.pendingNotificationRequests();
      for (final request in pending) {
        if (request.payload?.startsWith(lessonPayloadPrefix) ?? false) {
          await _plugin.cancel(request.id);
        }
      }
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Notifications] cancel: $error');
    }
  }

  Future<void> cancelAll() async {
    if (!_ready) return;
    try {
      await _plugin.cancelAll();
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Notifications] cancelAll: $error');
    }
  }

  void _openInbox() {
    if (!AppSession.instance.isSignedIn) return;
    AppNavigator.key.currentState?.pushNamed(Routes.notifications);
  }
}
