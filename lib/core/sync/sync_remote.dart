import 'package:dio/dio.dart';
import '../config/app_env.dart';
import '../di/service_locator.dart';
import '../network/error/api_error_handler.dart';

class SyncRemote {
  Dio get _dio => getIt<Dio>();

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on Object catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<void> upsert(String table, List<Map<String, dynamic>> rows) {
    return _guard(() async {
      await _dio.post<dynamic>(
        '${AppEnv.restUrl}/$table',
        queryParameters: {'on_conflict': 'id'},
        data: rows,
        options: Options(
          headers: {'Prefer': 'resolution=merge-duplicates,return=minimal'},
        ),
      );
    });
  }

  Future<List<Map<String, dynamic>>> fetch(
    String table, {
    String? cursor,
    int limit = 500,
  }) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(
        '${AppEnv.restUrl}/$table',
        queryParameters: {
          'select': '*',
          'order': 'updated_at.asc',
          'limit': limit,
          if (cursor != null) 'updated_at': 'gt.$cursor',
        },
      );
      final data = response.data;
      if (data is! List) return const <Map<String, dynamic>>[];
      return data
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    });
  }

  Future<Map<String, dynamic>?> fetchProfile(String userId) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(
        '${AppEnv.restUrl}/profiles',
        queryParameters: {'id': 'eq.$userId', 'select': '*'},
      );
      final data = response.data;
      if (data is! List || data.isEmpty) return null;
      return Map<String, dynamic>.from(data.first as Map);
    });
  }

  Future<void> patchProfile(String userId, Map<String, dynamic> fields) {
    return _guard(() async {
      await _dio.patch<dynamic>(
        '${AppEnv.restUrl}/profiles',
        queryParameters: {'id': 'eq.$userId'},
        data: fields,
        options: Options(headers: {'Prefer': 'return=minimal'}),
      );
    });
  }

  Future<void> uploadAvatar(String path, List<int> bytes) {
    return _guard(() async {
      await _dio.post<dynamic>(
        '${AppEnv.storageUrl}/object/avatars/$path',
        data: bytes,
        options: Options(
          contentType: 'image/jpeg',
          headers: {'x-upsert': 'true'},
        ),
      );
    });
  }

  Future<List<int>> downloadAvatar(String path) {
    return _guard(() async {
      final response = await _dio.get<List<int>>(
        '${AppEnv.storageUrl}/object/authenticated/avatars/$path',
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data ?? const <int>[];
    });
  }

  Future<void> deleteAvatar(String path) {
    return _guard(() async {
      await _dio.delete<dynamic>('${AppEnv.storageUrl}/object/avatars/$path');
    });
  }
}
