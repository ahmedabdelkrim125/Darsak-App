class AppValidators {
  AppValidators._();

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _username = RegExp(r'^[a-zA-Z][a-zA-Z0-9_.]{2,19}$');
  static final RegExp _phone = RegExp(r'^01[0125][0-9]{8}$');

  static String? required(String? value, {String message = 'هذا الحقل مطلوب'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? fullName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'أدخل الاسم الكامل';
    if (name.split(RegExp(r'\s+')).length < 2) {
      return 'أدخل اسمك الأول والثاني على الأقل';
    }
    return null;
  }

  static String? username(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'أدخل اسم المستخدم';
    if (!_username.hasMatch(name)) {
      return 'استخدم 3-20 حرفاً إنجليزياً أو أرقاماً أو _';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'أدخل البريد الإلكتروني';
    }
    if (!_email.hasMatch(value.trim())) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  static String? phone(
    String? value, {
    String emptyMessage = 'أدخل رقم الهاتف',
  }) {
    final number = value?.trim() ?? '';
    if (number.isEmpty) return emptyMessage;
    if (!_phone.hasMatch(number)) return 'رقم الهاتف غير صحيح';
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) return 'أدخل كلمة المرور';
    if (value.length < minLength) {
      return 'كلمة المرور يجب ألا تقل عن $minLength أحرف';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'أكد كلمة المرور';
    if (value != original) return 'كلمتا المرور غير متطابقتين';
    return null;
  }
}
