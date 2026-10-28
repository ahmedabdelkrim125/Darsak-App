import 'package:flutter/material.dart';
import 'package:darsak_app/core/helper/app_validators.dart';
import 'package:darsak_app/core/widgets/app_text_field.dart';

class ForgotEmailStep extends StatelessWidget {
  const ForgotEmailStep({
    super.key,
    required this.emailController,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: emailController,
          hintText: 'البريد الإلكتروني',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
          autofillHints: const [AutofillHints.email],
          validator: AppValidators.email,
          onSubmitted: (_) => onSubmit(),
          reserveErrorSpace: true,
        ),
      ],
    );
  }
}
