import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_env.dart';
import 'api_constants.dart';
import 'auth/session_expired_notifier.dart';
import 'auth/token_refresher.dart';
import 'auth/token_storage.dart';
import 'interceptors/app_log_interceptor.dart';
import 'interceptors/auth_interceptor.dart';
import 'network_info.dart';

class DioFactory {
  DioFactory._();

  static BaseOptions baseOptions() {
    return BaseOptions(
      baseUrl: AppEnv.supabaseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      responseType: ResponseType.json,
      headers: {
        ApiConstants.apiKeyHeader: AppEnv.publishableKey,
        'Accept': 'application/json',
      },
    );
  }

  static Dio bare() => Dio(baseOptions());

  static Dio create({
    required TokenStorage storage,
    required TokenRefresher refresher,
    required NetworkInfo network,
    required SessionExpiredNotifier sessionExpired,
  }) {
    final dio = Dio(baseOptions());
    dio.interceptors.add(
      AuthInterceptor(
        storage: storage,
        refresher: refresher,
        network: network,
        sessionExpired: sessionExpired,
        retryDio: bare(),
      ),
    );
    if (kDebugMode) dio.interceptors.add(AppLogInterceptor());
    return dio;
  }
}
