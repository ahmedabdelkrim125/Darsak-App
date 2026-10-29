import 'package:flutter/material.dart';
import '../../../core/helper/app_formatters.dart';
import '../../../core/helper/app_validators.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_choice_chips.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../data/classroom_store.dart';
import 'widgets/group_picker.dart';
import 'widgets/sheet_label.dart';

class AddStudentSheet extends StatefulWidget {
  const AddStudentSheet({super.key, this.initialGroupId});

  final String? initialGroupId;

  static Future<void> show(BuildContext context, {String? initialGroupId}) {
    return AppBottomSheet.show<void>(
      context,
      title: 'إضافة طالب',
      child: AddStudentSheet(initialGroupId: initialGroupId),
    );
  }

  @override
  State<AddStudentSheet> createState() => _AddStudentSheetState();
}

class _AddStudentSheetState extends State<AddStudentSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  late String? _groupId;
  bool _hasAccount = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final groups = ClassroomStore.instance.groups;
    _groupId =
        widget.initialGroupId ?? (groups.isEmpty ? null : groups.first.id);
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final groupId = _groupId;
    if (groupId == null) return;
    final error = ClassroomStore.instance.addStudent(
      groupId: groupId,
      name: _name.text,
      username: _hasAccount ? _username.text : null,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    AppToast.show(context, 'تمت إضافة الطالب');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final groups = ClassroomStore.instance.groups;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetLabel('المجموعة'),
          GroupPicker(
            groups: groups,
            selectedId: _groupId,
            onChanged: (id) => setState(() {
              _groupId = id;
              _error = null;
            }),
          ),
          verticalSpace(height: 16),
          AppTextField(
            controller: _name,
            hintText: 'اسم الطالب',
            prefixIcon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: (value) =>
                AppValidators.required(value, message: 'أدخل اسم الطالب'),
            reserveErrorSpace: true,
          ),
          const SheetLabel('حساب الطالب في التطبيق'),
          AppChoiceChips<bool>(
            items: const [
              AppChoiceItem<bool>(value: true, label: 'لديه حساب'),
              AppChoiceItem<bool>(value: false, label: 'بدون حساب'),
            ],
            value: _hasAccount,
            onChanged: (value) => setState(() {
              _hasAccount = value;
              _error = null;
            }),
          ),
          verticalSpace(height: 14),
          if (_hasAccount)
            AppTextField(
              controller: _username,
              hintText: 'اسم المستخدم الخاص بالطالب',
              prefixIcon: Icons.alternate_email_rounded,
              textInputAction: TextInputAction.done,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
              inputFormatters: AppFormatters.username,
              validator: AppValidators.username,
              onSubmitted: (_) => _submit(),
              reserveErrorSpace: true,
            ),
          if (_error != null)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                _error!,
                style: AppFonts.bodySmall.copyWith(color: palette.error),
              ),
            ),
          AppButton(label: 'إضافة الطالب', onPressed: _submit, expanded: true),
        ],
      ),
    );
  }
}
