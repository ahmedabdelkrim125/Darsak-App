import 'package:flutter/services.dart';

class AppFormatters {
  AppFormatters._();

  static final TextInputFormatter lowerCase = TextInputFormatter.withFunction(
    (oldValue, newValue) =>
        newValue.copyWith(text: newValue.text.toLowerCase()),
  );

  static final List<TextInputFormatter> username = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_.]')),
    lowerCase,
    LengthLimitingTextInputFormatter(20),
  ];

  static final List<TextInputFormatter> phone = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(11),
  ];
}
