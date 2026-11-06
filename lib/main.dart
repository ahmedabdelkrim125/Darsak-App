import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/app_env.dart';
import 'core/cubit/app_bloc_observer.dart';
import 'core/di/service_locator.dart';
import 'core/network/auth/session_expired_notifier.dart';
import 'core/notifications/notification_service.dart';
import 'core/notifications/lesson_reminder_scheduler.dart';
import 'core/notifications/local_notification_service.dart';
import 'core/routing/app_navigator.dart';
import 'core/routing/routes.dart';
import 'core/settings/app_settings.dart';
import 'darsak_app.dart';
import 'feat/auth/data/repo/auth_repository.dart';
import 'feat/classroom/data/classroom_store.dart';
import 'feat/notification/ui/notification_navigator.dart';
import 'feat/payments/data/payments_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.load();
  setupServiceLocator();
  Bloc.observer = AppBlocObserver();
  await AppSettings.instance.load();
  await NotificationService.instance.init();
  await _initNotifications();
  await getIt<AuthRepository>().restoreSession();
  _listenForSessionExpiry();
  LessonReminderScheduler.instance.start();
  runApp(const DarsakApp());
}

Future<void> _initNotifications() async {
  try {
    await Firebase.initializeApp();
  } on Object catch (error) {
    debugPrint('[Firebase] $error');
  }
  try {
    await LocalNotificationService.instance.init(
      onTap: (payload) {
        final context = AppNavigator.key.currentContext;
        if (context != null && payload == 'push') {
          NotificationNavigator.open(context);
        }
      },
    );
  } on Object catch (error) {
    debugPrint('[Notify] $error');
  }
}

void _listenForSessionExpiry() {
  getIt<SessionExpiredNotifier>().stream.listen((_) async {
    await getIt<AuthRepository>().signOut(flush: false);
    ClassroomStore.instance.reset();
    PaymentsStore.instance.reset();
    AppNavigator.key.currentState?.pushNamedAndRemoveUntil(
      Routes.roleSelection,
      (route) => false,
    );
  });
}
