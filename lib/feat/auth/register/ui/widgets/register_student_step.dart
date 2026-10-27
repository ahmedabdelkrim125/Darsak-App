import 'package:flutter/material.dart';
import 'package:darsak_app/core/helper/app_formatters.dart';
import 'package:darsak_app/core/helper/app_validators.dart';
import 'package:darsak_app/core/widgets/app_choice_chips.dart';
import 'package:darsak_app/core/widgets/app_text_field.dart';
import '../../../../../core/const/student_grade.dart';

class RegisterStudentStep extends StatelessWidget {
  const RegisterStudentStep({
    super.key,
    required this.grade,
    required this.onGradeChanged,
    required this.parentPhoneController,
    required this.emailController,
    required this.onSubmit,
  });

  final StudentGrade? grade;
  final ValueChanged<StudentGrade> onGradeChanged;
  final TextEditingController parentPhoneController;
  final TextEditingController emailController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppChoiceChips<StudentGrade>(
          items: [
            for (final item in StudentGrade.values)
              AppChoiceItem<StudentGrade>(value: item, label: item.label),
          ],
          value: grade,
          onChanged: onGradeChanged,
          validator: (value) => value == null ? 'اختر مرحلتك الدراسية' : null,
          reserveErrorSpace: true,
        ),
        AppTextField(
          controller: parentPhoneController,
          hintText: 'رقم ولي الأمر',
          prefixIcon: Icons.family_restroom_rounded,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
          inputFormatters: AppFormatters.phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          validator: (value) =>
              AppValidators.phone(value, emptyMessage: 'أدخل رقم ولي الأمر'),
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
