import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/const/school_year.dart';
import '../../../core/const/student_grade.dart';
import '../../../core/helper/app_validators.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/session/app_session.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_choice_chips.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../data/classroom_store.dart';
import 'widgets/sheet_label.dart';

class AddGroupSheet extends StatefulWidget {
  const AddGroupSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show<void>(
      context,
      title: 'إضافة مجموعة',
      child: const AddGroupSheet(),
    );
  }

  @override
  State<AddGroupSheet> createState() => _AddGroupSheetState();
}

class _AddGroupSheetState extends State<AddGroupSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _fee = TextEditingController();
  final TextEditingController _subject = TextEditingController();
  final bool _needsSubject = !AppSession.instance.hasSubject;
  StudentGrade? _stage;
  SchoolYear? _year;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _fee.dispose();
    _subject.dispose();
    super.dispose();
  }

  void _onStageChanged(StudentGrade stage) {
    setState(() {
      _stage = stage;
      _year = stage == StudentGrade.university ? SchoolYear.university : null;
      _error = null;
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final year = _year;
    final fee = int.tryParse(_fee.text.trim());
    if (year == null || fee == null) return;
    final session = AppSession.instance;
    if (_needsSubject) session.updateSubject(_subject.text);
    final error = ClassroomStore.instance.addGroup(
      name: _name.text,
      year: year,
      subject: session.subject,
      monthlyFee: fee,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    AppToast.show(context, 'تمت إضافة المجموعة');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final stage = _stage;
    final session = AppSession.instance;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_needsSubject)
            AppTextField(
              controller: _subject,
              hintText: 'المادة التي تدرسها',
              prefixIcon: Icons.menu_book_outlined,
              textInputAction: TextInputAction.next,
              validator: (value) => AppValidators.required(
                value,
                message: 'أدخل المادة التي تدرسها',
              ),
              reserveErrorSpace: true,
            )
          else
            Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: Text(
                'المادة: ${session.subject}',
                style: AppFonts.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ),
          AppTextField(
            controller: _name,
            hintText: 'اسم المجموعة (مثال: مجموعة أ)',
            prefixIcon: Icons.groups_outlined,
            textInputAction: TextInputAction.next,
            validator: (value) =>
                AppValidators.required(value, message: 'أدخل اسم المجموعة'),
            reserveErrorSpace: true,
          ),
          AppTextField(
            controller: _fee,
            hintText: 'سعر الشهر للطالب (جنيه)',
            prefixIcon: Icons.payments_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              final amount = int.tryParse(value?.trim() ?? '');
              if (amount == null || amount <= 0) return 'أدخل سعر الشهر';
              return null;
            },
            reserveErrorSpace: true,
          ),
          const SheetLabel('المرحلة الدراسية'),
          AppChoiceChips<StudentGrade>(
            items: [
              for (final item in StudentGrade.values)
                AppChoiceItem<StudentGrade>(value: item, label: item.label),
            ],
            value: _stage,
            onChanged: _onStageChanged,
            validator: (value) => value == null ? 'اختر المرحلة الدراسية' : null,
            reserveErrorSpace: true,
          ),
          if (stage != null && stage != StudentGrade.university) ...[
            const SheetLabel('السنة الدراسية'),
            AppChoiceChips<SchoolYear>(
              key: ValueKey(stage),
              items: [
                for (final year in SchoolYear.of(stage))
                  AppChoiceItem<SchoolYear>(
                    value: year,
                    label: year.shortLabel,
                  ),
              ],
              value: _year,
              onChanged: (value) => _year = value,
              validator: (value) =>
                  value == null ? 'اختر السنة الدراسية' : null,
              reserveErrorSpace: true,
              spacing: 6.w,
              textStyle: AppFonts.bodySmall.copyWith(fontSize: 12.sp),
            ),
          ],
          if (_error != null)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                _error!,
                style: AppFonts.bodySmall.copyWith(color: palette.error),
              ),
            ),
          verticalSpace(height: 6),
          AppButton(
            label: 'إضافة المجموعة',
            onPressed: _submit,
            expanded: true,
          ),
        ],
      ),
    );
  }
}