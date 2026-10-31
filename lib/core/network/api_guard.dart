import 'api_result.dart';
import 'error/api_error_handler.dart';

class ApiGuard {
  ApiGuard._();

  static Future<ApiResult<T>> run<T>(Future<T> Function() call) async {
    try {
      return ApiSuccess<T>(await call());
    } on Object catch (error) {
      return ApiFailure<T>(ApiErrorHandler.handle(error));
    }
  }
}
