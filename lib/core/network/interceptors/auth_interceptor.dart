import 'package:dio/dio.dart';
import '../api_constants.dart';
import '../auth/auth_tokens.dart';
import '../auth/session_expired_notifier.dart';
import '../auth/token_refresher.dart';
import '../auth/token_storage.dart';
import '../error/api_error.dart';
import '../error/api_error_type.dart';
import '../network_info.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage storage,
    required TokenRefresher refresher,
    required NetworkInfo network,
    required SessionExpiredNotifier sessionExpired,
    required Dio retryDio,
  }) : _storage = storage,
       _refresher = refresher,
       _network = network,
       _sessionExpired = sessionExpired,
       _retryDio = retryDio;

  final TokenStorage _storage;
  final TokenRefresher _refresher;
  final NetworkInfo _network;
  final SessionExpiredNotifier _sessionExpired;
  final Dio _retryDio;

  Future<AuthTokens?>? _refreshing;

  bool _skips(RequestOptions options) {
    return options.extra[ApiConstants.skipAuthKey] == true;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_skips(options)) {
      handler.next(options);
      return;
    }
    var tokens = await _storage.read();
    if (tokens != null && tokens.isExpiringSoon) {
      tokens = await _refresh() ?? tokens;
    }
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final unauthorized = err.response?.statusCode == 401;
    final alreadyRetried = options.extra[ApiConstants.retriedKey] == true;

    if (!unauthorized || _skips(options) || alreadyRetried) {
      handler.next(err);
      return;
    }

    final tokens = await _refresh();
    if (tokens == null) {
      handler.next(err);
      return;
    }

    options.extra[ApiConstants.retriedKey] = true;
    options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    try {
      final response = await _retryDio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<AuthTokens?> _refresh() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<AuthTokens?> _doRefresh() async {
    final current = await _storage.read();
    if (current == null) return null;
    if (!await _network.isConnected) return null;

    try {
      final fresh = await _refresher.refresh(current.refreshToken);
      await _storage.write(fresh);
      return fresh;
    } on ApiError catch (error) {
      final invalidSession =
          error.type == ApiErrorType.sessionExpired ||
          error.type == ApiErrorType.unauthorized ||
          error.type == ApiErrorType.badRequest;
      if (invalidSession) {
        await _storage.clear();
        _sessionExpired.notify();
      }
      return null;
    }
  }
}
