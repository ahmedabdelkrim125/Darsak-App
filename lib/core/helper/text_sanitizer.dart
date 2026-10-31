class TextSanitizer {
  TextSanitizer._();

  static final RegExp _control = RegExp(
    r'[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F]',
  );
  static final RegExp _spaces = RegExp(r'\s+');

  static String clean(String value) {
    return value.replaceAll(_control, '').replaceAll(_spaces, ' ').trim();
  }
}
