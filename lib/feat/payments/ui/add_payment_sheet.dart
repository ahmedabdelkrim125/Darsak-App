import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/helper/app_validators.dart';
import '../../../core/helper/date_formatter.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/data/models/classroom_group.dart';
import '../../classroom/ui/widgets/classroom_chip.dart';
import '../../classroom/ui/widgets/group_picker.dart';
import '../../classroom/ui/widgets/sheet_label.dart';
import '../data/payments_content.dart';
import '../data/payments_store.dart';

class AddPaymentSheet extends StatefulWidget {
  const AddPaymentSheet({super.key, required this.month, this.studentId});

  final DateTime month;
  final String? studentId;

  static Future<void> show(
    BuildContext context, {
    required DateTime month,
    String? studentId,
  }) {
    return AppBottomSheet.show<void>(
      context,
      title: PaymentsContent.addPayment,
      child: AddPaymentSheet(month: month, studentId: studentId),
    );
  }

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late DateTime _date = DateFormatter.dateOnly(DateTime.now());
  String? _groupId;
  String? _studentId;
  String? _error;

  List<ClassroomGroup> get _groups => ClassroomStore.instance.groups
      .where((group) => group.students.isNotEmpty)
      .toList();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormatter.shortDate(_date);
    final groups = _groups;
    final wanted = widget.studentId;
    if (wanted != null) {
      for (final group in groups) {
        if (group.students.any((student) => student.id == wanted)) {
          _groupId = group.id;
          _studentId = wanted;
        }
      }
    }
    if (_groupId == null && groups.isNotEmpty) {
      _groupId = groups.first.id;
      _studentId = groups.first.students.first.id;
    }
    _prefill();
  }

  @override
  void dispose() {
    _amount.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _prefill() {
    final id = _studentId;
    final entry = id == null
        ? null
        : PaymentsStore.instance.entryOf(id, widget.month);
    _amount.text = entry == null || entry.remaining == 0
        ? ''
        : '${entry.remaining}';
  }

  void _selectGroup(String id) {
    final group = ClassroomStore.instance.groupById(id);
    if (group == null || group.students.isEmpty) return;
    setState(() {
      _groupId = id;
      _studentId = group.students.first.id;
      _error = null;
      _prefill();
    });
  }

  void _selectStudent(String id) {
    setState(() {
      _studentId = id;
      _error = null;
      _prefill();
    });
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _date = DateFormatter.dateOnly(picked);
      _dateController.text = DateFormatter.shortDate(_date);
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final studentId = _studentId;
    final amount = int.tryParse(_amount.text.trim());
    if (studentId == null || amount == null) return;
    final error = PaymentsStore.instance.addPayment(
      studentId: studentId,
      month: widget.month,
      amount: amount,
      paidAt: _date,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    AppToast.show(context, 'تم تسجيل الدفعة');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final group = _groupId == null
        ? null
        : ClassroomStore.instance.groupById(_groupId!);
    final entry = _studentId == null
        ? null
        : PaymentsStore.instance.entryOf(_studentId!, widget.month);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'عن شهر ${DateFormatter.monthYear(widget.month)}',
            style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
          ),
          verticalSpace(height: 14),
          const SheetLabel('المجموعة'),
          GroupPicker(
            groups: _groups,
            selectedId: _groupId,
            onChanged: _selectGroup,
          ),
          verticalSpace(height: 14),
          const SheetLabel('الطالب'),
          if (group != null)
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final student in group.students)
                  ClassroomChip(
                    label: student.name,
                    selected: student.id == _studentId,
                    onTap: () => _selectStudent(student.id),
                  ),
              ],
            ),
          if (entry != null)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                'سعر الشهر: ${entry.fee} ${PaymentsContent.currency} · المدفوع: ${entry.paid} · المتبقي: ${entry.remaining}',
                style: AppFonts.bodySmall.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ),
          verticalSpace(height: 16),
          AppTextField(
            controller: _amount,
            hintText: 'المبلغ (جنيه)',
            prefixIcon: Icons.payments_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              final amount = int.tryParse(value?.trim() ?? '');
              if (amount == null || amount <= 0) return 'أدخل المبلغ';
              return null;
            },
            reserveErrorSpace: true,
          ),
          AppTextField(
            controller: _dateController,
            hintText: 'تاريخ الدفع',
            prefixIcon: Icons.event_outlined,
            readOnly: true,
            onTap: _pickDate,
            validator: (value) =>
                AppValidators.required(value, message: 'اختر تاريخ الدفع'),
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
          AppButton(label: 'تسجيل الدفعة', onPressed: _submit, expanded: true),
        ],
      ),
    );
  }
}
