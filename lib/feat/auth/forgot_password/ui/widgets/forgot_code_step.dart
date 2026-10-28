import 'package:flutter/material.dart';
import 'package:darsak_app/core/widgets/app_otp_field.dart';

import 'forgot_resend_row.dart';

class ForgotCodeStep extends StatelessWidget {
  const ForgotCodeStep({
    super.key,
    required this.codeController,
    required this.onSubmit,
    required this.onResend,
  });

  final TextEditingController codeController;
  final VoidCallback onSubmit;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppOtpField(
          controller: codeController,
          autofocus: true,
          reserveErrorSpace: true,
          validator: (value) => (value ?? '').length == 6
              ? null
              : 'أدخل الرمز المكوّن من 6 أرقام',
          onCompleted: (_) => onSubmit(),
        ),
        ForgotResendRow(onResend: onResend),
      ],
    );
  }
}
