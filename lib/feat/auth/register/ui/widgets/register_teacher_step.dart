import 'package:flutter/material.dart';
import '../../../../../core/helper/app_formatters.dart';
import '../../../../../core/helper/app_validators.dart';
import '../../../../../core/widgets/app_text_field.dart';

class RegisterTeacherStep extends StatelessWidget {
  const RegisterTeacherStep({
    super.key,
    required this.subjectController,
    required this.phoneController,
    required this.emailController,
    required this.onSubmit,
  });

  final TextEditingController subjectController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: subjectController,
          hintText: 'المادة التي تدرسها',
          prefixIcon: Icons.menu_book_outlined,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          validator: (value) =>
              AppValidators.required(value, message: 'أدخل المادة التي تدرسها'),
          reserveErrorSpace: true,
        ),
        AppTextField(
          controller: phoneController,
          hintText: 'رقم الهاتف',
          prefixIcon: Icons.phone_iphone_rounded,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
          inputFormatters: AppFormatters.phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          validator: AppValidators.phone,
          reserveErrorSpace: true,
        ),
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
