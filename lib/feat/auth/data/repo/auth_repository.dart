import 'dart:async';
import '../../../../core/const/student_grade.dart';
import '../../../../core/const/user_role.dart';
import '../../../../core/helper/text_sanitizer.dart';
import '../../../../core/network/api/auth_api.dart';
import '../../../../core/network/api/profile_api.dart';
import '../../../../core/network/api_guard.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/auth/auth_tokens.dart';
import '../../../../core/network/auth/token_storage.dart';
import '../../../../core/network/error/api_error.dart';
import '../../../../core/network/error/api_error_type.dart';
import '../../../../core/network/error/api_messages.dart';
import '../../../../core/network/models/profile_model.dart';
import '../../../../core/session/app_session.dart';
import '../../../../core/session/session_cache.dart';

class AuthRepository {
  AuthRepository({
    required AuthApi authApi,
    required ProfileApi profileApi,
    required TokenStorage storage,
    required SessionCache cache,
    required AppSession session,
  }) : _authApi = authApi,
       _profileApi = profileApi,
       _storage = storage,
       _cache = cache,
       _session = session {
    _session.addListener(_persistSession);
  }

  final AuthApi _authApi;
  final ProfileApi _profileApi;
  final TokenStorage _storage;
  final SessionCache _cache;
  final AppSession _session;

  Future<bool> restoreSession() async {
    final tokens = await _storage.read();
    final cached = await _cache.read();
    if (tokens == null || cached == null) return false;
    _session.restore(cached);
    return _session.isSignedIn;
  }

  Future<ApiResult<bool>> signUp({
    required UserRole role,
    required String fullName,
    required String username,
    required String email,
    required String password,
    String? subject,
    String? phone,
    String? parentPhone,
    StudentGrade? grade,
  }) {
    return ApiGuard.run(() async {
      final cleanUsername = TextSanitizer.clean(username).toLowerCase();
      final cleanEmail = TextSanitizer.clean(email);

      final available = await _profileApi.isUsernameAvailable({
        'p_username': cleanUsername,
        'p_email': cleanEmail,
      });
      if (!available) throw _error(ApiErrorType.conflict, 'username_taken');

      final response = await _authApi.signUp({
        'email': cleanEmail,
        'password': password,
        'data': {
          'role': role.name,
          'full_name': TextSanitizer.clean(fullName),
          'username': cleanUsername,
          if (subject != null) 'subject': TextSanitizer.clean(subject),
          if (phone != null) 'phone': TextSanitizer.clean(phone),
          if (parentPhone != null)
            'parent_phone': TextSanitizer.clean(parentPhone),
          if (grade != null) 'stage': grade.name,
        },
      });

      if (response.user.alreadyRegistered) {
        throw _error(ApiErrorType.conflict, 'email_exists');
      }

      final tokens = response.tokens;
      if (tokens == null) return true;
      await _openSession(tokens, response.user.id);
      return false;
    });
  }

  Future<ApiResult<void>> verifySignupCode({
    required String email,
    required String code,
  }) {
    return ApiGuard.run(() async {
      final response = await _authApi.verifyOtp({
        'type': 'signup',
        'email': TextSanitizer.clean(email),
        'token': code.trim(),
      });
      final tokens = response.tokens;
      if (tokens == null) throw _error(ApiErrorType.parsing, 'parsing');
      await _openSession(tokens, response.user.id);
    });
  }

  Future<ApiResult<void>> resendSignupCode(String email) {
    return ApiGuard.run(
      () => _authApi.resend({'type': 'signup', 'email': email.trim()}),
    );
  }

  Future<ApiResult<UserRole>> signIn({
    required String email,
    required String password,
    required UserRole expectedRole,
  }) {
    return ApiGuard.run(() async {
      final response = await _authApi.signInWithPassword({
        'email': email.trim(),
        'password': password,
      });
      final tokens = response.tokens;
      if (tokens == null) throw _error(ApiErrorType.parsing, 'parsing');
      final profile = await _openSession(
        tokens,
        response.user.id,
        expectedRole: expectedRole,
      );
      return profile.role;
    });
  }

  Future<ApiResult<void>> sendRecoveryCode(String email) {
    return ApiGuard.run(() => _authApi.recover({'email': email.trim()}));
  }

  Future<ApiResult<void>> verifyRecoveryCode({
    required String email,
    required String code,
  }) {
    return ApiGuard.run(() async {
      final response = await _authApi.verifyOtp({
        'type': 'recovery',
        'email': email.trim(),
        'token': code.trim(),
      });
      final tokens = response.tokens;
      if (tokens == null) throw _error(ApiErrorType.parsing, 'parsing');
      await _storage.write(tokens);
    });
  }

  Future<ApiResult<void>> resetPassword(String password) {
    return ApiGuard.run(() async {
      await _authApi.updateUser({'password': password});
      await _discardTokens();
    });
  }

  Future<void> signOut() async {
    _session.signOut();
    await _cache.clear();
    await _discardTokens();
  }

  Future<ProfileModel> _openSession(
    AuthTokens tokens,
    String userId, {
    UserRole? expectedRole,
  }) async {
    await _storage.write(tokens);
    try {
      final rows = await _profileApi.getProfile('eq.$userId', '*');
      if (rows.isEmpty)
        throw _error(ApiErrorType.notFound, 'profile_not_found');
      final profile = rows.first;
      if (expectedRole != null && profile.role != expectedRole) {
        final actual = profile.role == UserRole.teacher ? 'معلم' : 'طالب';
        throw ApiError(
          type: ApiErrorType.forbidden,
          message: 'هذا الحساب مسجل كـ $actual، اختر نوع الحساب الصحيح',
          code: 'wrong_role',
        );
      }
      _session.applyProfile(profile);
      return profile;
    } on Object {
      await _storage.clear();
      rethrow;
    }
  }

  Future<void> _discardTokens() async {
    try {
      await _authApi.signOut();
    } on Object {
      return;
    } finally {
      await _storage.clear();
    }
  }

  void _persistSession() {
    if (_session.isSignedIn) {
      unawaited(_cache.write(_session.toCache()));
    } else {
      unawaited(_cache.clear());
    }
  }

  ApiError _error(ApiErrorType type, String code) {
    return ApiError(
      type: type,
      message: ApiMessages.resolve(type: type, code: code),
      code: code,
    );
  }
}
