import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/app_env.dart';
import 'core/cubit/app_bloc_observer.dart';
import 'core/di/service_locator.dart';
import 'core/network/auth/session_expired_notifier.dart';
import 'core/routing/app_navigator.dart';
import 'core/routing/routes.dart';
import 'core/settings/app_settings.dart';
import 'darsak_app.dart';
import 'feat/auth/data/repo/auth_repository.dart';
import 'feat/classroom/data/classroom_store.dart';
import 'feat/payments/data/payments_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.load();
  setupServiceLocator();
  Bloc.observer = AppBlocObserver();
  await AppSettings.instance.load();
  await getIt<AuthRepository>().restoreSession();
  _listenForSessionExpiry();
  runApp(const DarsakApp());
}

void _listenForSessionExpiry() {
  getIt<SessionExpiredNotifier>().stream.listen((_) async {
    await getIt<AuthRepository>().signOut();
    ClassroomStore.instance.reset();
    PaymentsStore.instance.reset();
    AppNavigator.key.currentState?.pushNamedAndRemoveUntil(
      Routes.roleSelection,
      (route) => false,
    );
  });
}
