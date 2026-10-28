import 'package:flutter/material.dart';
import 'package:darsak_app/core/helper/app_formatters.dart';
import 'package:darsak_app/core/helper/app_validators.dart';
import 'package:darsak_app/core/widgets/app_text_field.dart';

class RegisterIdentityStep extends StatelessWidget {
  const RegisterIdentityStep({
    super.key,
    required this.fullNameController,
    required this.usernameController,
    required this.onSubmit,
  });

  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: fullNameController,
          hintText: 'الاسم الكامل',
          prefixIcon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
          validator: AppValidators.fullName,
          reserveErrorSpace: true,
        ),
        AppTextField(
          controller: usernameController,
          hintText: 'اسم المستخدم',
          helperText: 'حروف إنجليزية وأرقام و _ من 3 إلى 20',
          prefixIcon: Icons.alternate_email_rounded,
          textInputAction: TextInputAction.done,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
          inputFormatters: AppFormatters.username,
          autofillHints: const [AutofillHints.newUsername],
          validator: AppValidators.username,
          onSubmitted: (_) => onSubmit(),
        ),
      ],
    );
  }
}
