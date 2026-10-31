import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'api_error.dart';
import 'api_error_type.dart';
import 'api_messages.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  static const Set<String> _sessionCodes = {
    'refresh_token_not_found',
    'refresh_token_already_used',
    'session_not_found',
    'session_expired',
    'bad_jwt',
    'no_authorization',
    'PGRST301',
    'PGRST303',
  };

  static const Set<String> _conflictCodes = {'23505', '23503'};

  static const Set<String> _forbiddenCodes = {'42501'};

  static const Set<String> _validationCodes = {
    '23502',
    '23514',
    '22023',
    '22P02',
    'validation_failed',
    'weak_password',
    'same_password',
  };

  static ApiError handle(Object error) {
    if (error is ApiError) return error;
    if (error is DioException) return _fromDio(error);
    if (error is SocketException) return _simple(ApiErrorType.noConnection);
    if (error is TimeoutException) return _simple(ApiErrorType.timeout);
    if (error is FormatException || error is TypeError) {
      return _simple(ApiErrorType.parsing);
    }
    return _simple(ApiErrorType.unknown);
  }

  static ApiError _simple(ApiErrorType type) {
    return ApiError(
      type: type,
      message: ApiMessages.resolve(type: type),
    );
  }

  static ApiError _fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return _simple(ApiErrorType.timeout);
      case DioExceptionType.connectionError:
        return _simple(ApiErrorType.noConnection);
      case DioExceptionType.cancel:
        return _simple(ApiErrorType.cancelled);
      case DioExceptionType.badCertificate:
        return _simple(ApiErrorType.unknown);
      case DioExceptionType.badResponse:
        return _fromResponse(error.response);
      case DioExceptionType.unknown:
        final inner = error.error;
        if (inner is ApiError) return inner;
        if (inner is SocketException) return _simple(ApiErrorType.noConnection);
        if (inner is FormatException) return _simple(ApiErrorType.parsing);
        return _simple(ApiErrorType.unknown);
    }
  }

  static ApiError _fromResponse(Response<dynamic>? response) {
    final status = response?.statusCode;
    final body = _asMap(response?.data);
    final code = _readCode(body);
    final raw = _readMessage(body);
    final type = _typeOf(status, code);

    return ApiError(
      type: type,
      message: ApiMessages.resolve(type: type, code: code, raw: raw),
      statusCode: status,
      code: code,
      details: raw,
    );
  }

  static ApiErrorType _typeOf(int? status, String? code) {
    if (code != null) {
      if (_sessionCodes.contains(code)) return ApiErrorType.sessionExpired;
      if (_conflictCodes.contains(code)) return ApiErrorType.conflict;
      if (_forbiddenCodes.contains(code)) return ApiErrorType.forbidden;
      if (_validationCodes.contains(code)) return ApiErrorType.validation;
    }
    if (status == null) return ApiErrorType.unknown;
    if (status >= 500) return ApiErrorType.server;
    return switch (status) {
      400 => ApiErrorType.badRequest,
      401 => ApiErrorType.unauthorized,
      403 => ApiErrorType.forbidden,
      404 => ApiErrorType.notFound,
      409 => ApiErrorType.conflict,
      422 => ApiErrorType.validation,
      429 => ApiErrorType.rateLimited,
      _ => ApiErrorType.unknown,
    };
  }

  static Map<String, dynamic> _asMap(Object? data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } on FormatException {
        return const {};
      }
    }
    return const {};
  }

  static String? _readCode(Map<String, dynamic> body) {
    for (final key in const ['error_code', 'code', 'error']) {
      final value = body[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }

  static String? _readMessage(Map<String, dynamic> body) {
    for (final key in const ['msg', 'message', 'error_description', 'error']) {
      final value = body[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }
}
