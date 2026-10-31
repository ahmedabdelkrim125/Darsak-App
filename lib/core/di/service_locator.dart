import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../feat/auth/data/repo/auth_repository.dart';
import '../config/app_env.dart';
import '../network/api/auth_api.dart';
import '../network/api/profile_api.dart';
import '../network/auth/session_expired_notifier.dart';
import '../network/auth/token_refresher.dart';
import '../network/auth/token_storage.dart';
import '../network/dio_factory.dart';
import '../network/network_info.dart';
import '../session/app_session.dart';
import '../session/session_cache.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt
    ..registerLazySingleton<TokenStorage>(() => SecureTokenStorage())
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfo())
    ..registerLazySingleton<SessionExpiredNotifier>(
      () => SessionExpiredNotifier(),
    )
    ..registerLazySingleton<SessionCache>(() => SessionCache())
    ..registerLazySingleton<TokenRefresher>(
      () => TokenRefresher(dio: DioFactory.bare()),
    )
    ..registerLazySingleton<Dio>(
      () => DioFactory.create(
        storage: getIt(),
        refresher: getIt(),
        network: getIt(),
        sessionExpired: getIt(),
      ),
    )
    ..registerLazySingleton<AuthApi>(
      () => AuthApi(getIt<Dio>(), baseUrl: AppEnv.authUrl),
    )
    ..registerLazySingleton<ProfileApi>(
      () => ProfileApi(getIt<Dio>(), baseUrl: AppEnv.restUrl),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        authApi: getIt(),
        profileApi: getIt(),
        storage: getIt(),
        cache: getIt(),
        session: AppSession.instance,
      ),
    );
}
