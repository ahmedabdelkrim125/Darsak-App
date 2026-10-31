class ApiConstants {
  ApiConstants._();

  static const String apiKeyHeader = 'apikey';
  static const String skipAuthKey = 'skip_auth';
  static const String retriedKey = 'auth_retried';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
