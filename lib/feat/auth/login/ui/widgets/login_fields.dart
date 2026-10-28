import 'package:flutter/material.dart';
import 'package:darsak_app/core/helper/app_validators.dart';
import 'package:darsak_app/core/widgets/app_text_field.dart';

class LoginFields extends StatelessWidget {
  const LoginFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: emailController,
          hintText: 'البريد الإلكتروني',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          validator: AppValidators.email,
          reserveErrorSpace: true,
        ),
        AppTextField(
          controller: passwordController,
          hintText: 'كلمة المرور',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          validator: AppValidators.password,
          onSubmitted: (_) => onSubmit(),
          reserveErrorSpace: true,
        ),
      ],
    );
  }
}
