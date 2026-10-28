import 'package:flutter/material.dart';
import 'package:darsak_app/core/helper/app_validators.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import 'package:darsak_app/core/widgets/app_checkbox.dart';
import 'package:darsak_app/core/widgets/app_text_field.dart';
import '../../../../../core/helper/responsive_extension.dart';

class RegisterSecurityStep extends StatelessWidget {
  const RegisterSecurityStep({
    super.key,
    required this.passwordController,
    required this.confirmController,
    required this.termsAccepted,
    required this.onTermsChanged,
    required this.onSubmit,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool termsAccepted;
  final ValueChanged<bool> onTermsChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: passwordController,
          hintText: 'كلمة المرور',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: true,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          validator: (value) => AppValidators.password(value, minLength: 8),
          reserveErrorSpace: true,
        ),
        AppTextField(
          controller: confirmController,
          hintText: 'تأكيد كلمة المرور',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: true,
          textInputAction: TextInputAction.done,
          validator: (value) =>
              AppValidators.confirmPassword(value, passwordController.text),
          onSubmitted: (_) => onSubmit(),
          reserveErrorSpace: true,
        ),
        FormField<bool>(
          initialValue: termsAccepted,
          validator: (value) =>
              value == true ? null : 'يجب الموافقة على الشروط والأحكام',
          builder: (state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AppCheckbox(
                    value: state.value ?? false,
                    onChanged: (value) {
                      state.didChange(value);
                      onTermsChanged(value);
                    },
                    label: 'أوافق على الشروط والأحكام',
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 4.h),
                    child: Text(
                      state.errorText!,
                      style: AppFonts.bodySmall.copyWith(color: palette.error),
                    ),
                  )
                else
                  SizedBox(height: 22.h),
              ],
            );
          },
        ),
      ],
    );
  }
}
