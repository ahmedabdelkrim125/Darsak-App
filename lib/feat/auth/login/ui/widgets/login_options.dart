import 'package:flutter/material.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import 'package:darsak_app/core/widgets/app_checkbox.dart';
import 'package:darsak_app/core/widgets/app_text_button.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({
    super.key,
    required this.remember,
    required this.onRememberChanged,
    required this.onForgotPassword,
  });

  final bool remember;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppCheckbox(
          value: remember,
          onChanged: onRememberChanged,
          label: 'تذكرني',
        ),
        AppTextButton(
          label: 'نسيت كلمة المرور؟',
          onPressed: onForgotPassword,
          color: palette.primary,
          style: AppFonts.bodySmall,
          underlined: true,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
