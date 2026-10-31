import 'package:dio/dio.dart';
import '../../config/app_env.dart';
import '../api/auth_api.dart';
import '../error/api_error.dart';
import '../error/api_error_handler.dart';
import '../error/api_error_type.dart';
import '../error/api_messages.dart';
import 'auth_tokens.dart';

class TokenRefresher {
  TokenRefresher({required Dio dio})
    : _api = AuthApi(dio, baseUrl: AppEnv.authUrl);

  final AuthApi _api;

  Future<AuthTokens> refresh(String refreshToken) async {
    try {
      final response = await _api.refreshToken({'refresh_token': refreshToken});
      final tokens = response.tokens;
      if (tokens == null) {
        throw const ApiError(
          type: ApiErrorType.parsing,
          message: ApiMessages.parsing,
        );
      }
      return tokens;
    } on Object catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }
}
