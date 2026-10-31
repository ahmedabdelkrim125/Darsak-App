import 'api_error_type.dart';

class ApiMessages {
  ApiMessages._();

  static const String noConnection = 'لا يوجد اتصال بالإنترنت';
  static const String timeout = 'انتهت مهلة الاتصال، حاول مرة أخرى';
  static const String parsing = 'تعذر قراءة البيانات';
  static const String unknown = 'حدث خطأ غير متوقع';

  static const Map<ApiErrorType, String> _byType = {
    ApiErrorType.noConnection: noConnection,
    ApiErrorType.timeout: timeout,
    ApiErrorType.cancelled: 'تم إلغاء الطلب',
    ApiErrorType.badRequest: 'بيانات غير صالحة',
    ApiErrorType.unauthorized: 'يلزم تسجيل الدخول',
    ApiErrorType.sessionExpired: 'انتهت الجلسة، سجل الدخول مرة أخرى',
    ApiErrorType.forbidden: 'ليس لديك صلاحية لتنفيذ هذه العملية',
    ApiErrorType.notFound: 'العنصر المطلوب غير موجود',
    ApiErrorType.conflict: 'هذه البيانات موجودة بالفعل',
    ApiErrorType.validation: 'البيانات المدخلة غير صالحة',
    ApiErrorType.rateLimited: 'محاولات كثيرة، حاول بعد قليل',
    ApiErrorType.server: 'حدث خطأ في الخادم، حاول لاحقاً',
    ApiErrorType.parsing: parsing,
    ApiErrorType.unknown: unknown,
  };

  static const Map<String, String> _byCode = {
    'invalid_credentials': 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
    'invalid_grant': 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
    'email_not_confirmed':
        'لم يتم تأكيد بريدك بعد، أعد إنشاء الحساب بنفس البيانات لإرسال رمز جديد',
    'user_already_exists': 'هذا البريد الإلكتروني مسجل بالفعل',
    'email_exists': 'هذا البريد الإلكتروني مسجل بالفعل',
    'user_not_found': 'لا يوجد حساب بهذه البيانات',
    'weak_password': 'كلمة المرور ضعيفة، اختر كلمة أقوى',
    'same_password': 'كلمة المرور الجديدة يجب أن تختلف عن القديمة',
    'validation_failed': 'البيانات المدخلة غير صالحة',
    'otp_expired': 'انتهت صلاحية الرمز، اطلب رمزاً جديداً',
    'signup_disabled': 'إنشاء الحسابات غير متاح حالياً',
    'user_banned': 'تم إيقاف هذا الحساب',
    'over_request_rate_limit': 'محاولات كثيرة، حاول بعد قليل',
    'over_email_send_rate_limit': 'تم إرسال رسائل كثيرة، حاول بعد قليل',
    'session_expired': 'انتهت الجلسة، سجل الدخول مرة أخرى',
    'session_not_found': 'انتهت الجلسة، سجل الدخول مرة أخرى',
    'refresh_token_not_found': 'انتهت الجلسة، سجل الدخول مرة أخرى',
    'refresh_token_already_used': 'انتهت الجلسة، سجل الدخول مرة أخرى',
    'PGRST301': 'انتهت الجلسة، سجل الدخول مرة أخرى',
    '23505': 'هذه البيانات موجودة بالفعل',
    '23503': 'لا يمكن إتمام العملية بسبب بيانات مرتبطة',
    '23502': 'البيانات المدخلة غير مكتملة',
    '23514': 'البيانات المدخلة غير صالحة',
    '42501': 'ليس لديك صلاحية لتنفيذ هذه العملية',
    'invalid_code': 'كود المجموعة غير صحيح',
    'student_only': 'هذه الميزة متاحة للطلاب فقط',
    'username_taken': 'اسم المستخدم مستخدم بالفعل',
    'invalid_username': 'اسم المستخدم غير صالح',
  };

  static String resolve({
    required ApiErrorType type,
    String? code,
    String? raw,
  }) {
    final byCode = code == null ? null : _byCode[code];
    if (byCode != null) return byCode;
    final byRaw = raw == null ? null : _byCode[raw];
    if (byRaw != null) return byRaw;
    return _byType[type] ?? unknown;
  }
}
