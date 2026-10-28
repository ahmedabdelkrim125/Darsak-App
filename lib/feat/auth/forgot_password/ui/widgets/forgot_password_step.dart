import 'package:flutter/material.dart';
import '../../../../../core/helper/app_validators.dart';
import '../../../../../core/widgets/app_text_field.dart';

class ForgotPasswordStep extends StatelessWidget {
  const ForgotPasswordStep({
    super.key,
    required this.passwordController,
    required this.confirmController,
    required this.onSubmit,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: passwordController,
          hintText: 'كلمة المرور الجديدة',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: true,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          validator: (value) => AppValidators.password(value, minLength: 8),
          reserveErrorSpace: true,
        ),
        AppTextField(
          controller: confirmController,
          hintText: 'تأكيد كلمة المرور الجديدة',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: true,
          textInputAction: TextInputAction.done,
          validator: (value) =>
              AppValidators.confirmPassword(value, passwordController.text),
          onSubmitted: (_) => onSubmit(),
          reserveErrorSpace: true,
        ),
      ],
    );
  }
}
