import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../../feat/notification/ui/notification_navigator.dart';
import '../config/app_env.dart';
import '../di/service_locator.dart';
import '../routing/app_navigator.dart';
import '../sync/sync_engine.dart';
import 'local_notification_service.dart';

class PushService {
  PushService._();

  static final PushService instance = PushService._();

  StreamSubscription<String>? _refreshSub;
  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<RemoteMessage>? _openedSub;
  String? _token;
  String? _registeredToken;

  bool get _firebaseReady => Firebase.apps.isNotEmpty;

  Future<void> onLogin() async {
    if (!_firebaseReady) return;
    try {
      await LocalNotificationService.instance.requestPermission();
      final messaging = FirebaseMessaging.instance;
      _token = await messaging.getToken();
      await ensureRegistered();

      _refreshSub ??= messaging.onTokenRefresh.listen((token) {
        _token = token;
        unawaited(ensureRegistered());
      });
      _foregroundSub ??= FirebaseMessaging.onMessage.listen(_onForeground);
      _openedSub ??= FirebaseMessaging.onMessageOpenedApp.listen(
        (_) => _openNotifications(),
      );

      final initial = await messaging.getInitialMessage();
      if (initial != null) {
        Future<void>.delayed(const Duration(seconds: 2), _openNotifications);
      }
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Push] login: $error');
    }
  }

  Future<void> ensureRegistered() async {
    final token = _token;
    if (token == null || token == _registeredToken) return;
    try {
      await getIt<Dio>().post<dynamic>(
        '${AppEnv.restUrl}/rpc/register_device_token',
        data: {'p_token': token, 'p_platform': 'android'},
      );
      _registeredToken = token;
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Push] register: $error');
    }
  }

  Future<void> onLogout() async {
    if (!_firebaseReady) return;
    try {
      final token = _token ?? await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await getIt<Dio>().delete<dynamic>(
          '${AppEnv.restUrl}/device_tokens',
          queryParameters: {'token': 'eq.$token'},
        );
      }
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Push] unregister: $error');
    }
    _registeredToken = null;
    _token = null;
    try {
      await FirebaseMessaging.instance.deleteToken();
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Push] deleteToken: $error');
    }
  }

  void _onForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      unawaited(
        LocalNotificationService.instance.show(
          title: notification.title ?? 'درسّك',
          body: notification.body ?? '',
          payload: 'push',
        ),
      );
    }
    SyncEngine.instance.requestSync();
  }

  void _openNotifications() {
    final context = AppNavigator.key.currentContext;
    if (context != null) NotificationNavigator.open(context);
  }
}
