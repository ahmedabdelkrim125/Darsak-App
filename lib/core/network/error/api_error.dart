import 'package:equatable/equatable.dart';
import 'api_error_type.dart';

class ApiError extends Equatable implements Exception {
  const ApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.code,
    this.details,
  });

  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final String? code;
  final String? details;

  bool get isConnectionIssue =>
      type == ApiErrorType.noConnection || type == ApiErrorType.timeout;

  bool get isSessionIssue =>
      type == ApiErrorType.sessionExpired || type == ApiErrorType.unauthorized;

  bool get isRetryable =>
      isConnectionIssue ||
      type == ApiErrorType.server ||
      type == ApiErrorType.rateLimited;

  @override
  List<Object?> get props => [type, message, statusCode, code, details];

  @override
  String toString() => 'ApiError(${type.name}, $statusCode, $code): $message';
}
