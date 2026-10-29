import 'package:flutter/material.dart';
import '../../../core/const/week_days.dart';
import '../../../core/helper/app_validators.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/helper/time_formatter.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../data/classroom_store.dart';
import 'widgets/classroom_chip.dart';
import 'widgets/group_picker.dart';
import 'widgets/sheet_label.dart';

class AddLessonSheet extends StatefulWidget {
  const AddLessonSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show<void>(
      context,
      title: 'إضافة حصة',
      child: const AddLessonSheet(),
    );
  }

  @override
  State<AddLessonSheet> createState() => _AddLessonSheetState();
}

class _AddLessonSheetState extends State<AddLessonSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _timeController = TextEditingController();
  final Set<int> _days = {DateTime.now().weekday};
  late String? _groupId;
  TimeOfDay? _time;
  String? _error;

  @override
  void initState() {
    super.initState();
    final groups = ClassroomStore.instance.groups;
    _groupId = groups.isEmpty ? null : groups.first.id;
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    FocusScope.of(context).unfocus();
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 16, minute: 0),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _time = picked;
      _timeController.text = formatTime(picked);
      _error = null;
    });
  }

  void _toggleDay(int day) {
    setState(() {
      if (_days.contains(day)) {
        _days.remove(day);
      } else {
        _days.add(day);
      }
      _error = null;
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final groupId = _groupId;
    final time = _time;
    if (groupId == null || time == null) return;
    if (_days.isEmpty) {
      setState(() => _error = 'اختر يوماً واحداً على الأقل');
      return;
    }
    final error = ClassroomStore.instance.addLesson(
      groupId: groupId,
      time: time,
      weekdays: _days,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    AppToast.show(context, 'تمت إضافة الحصة');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final store = ClassroomStore.instance;
    final group = _groupId == null ? null : store.groupById(_groupId!);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetLabel('المجموعة'),
          GroupPicker(
            groups: store.groups,
            selectedId: _groupId,
            onChanged: (id) => setState(() {
              _groupId = id;
              _error = null;
            }),
          ),
          if (group != null)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                'المادة: ${group.subject} · ${group.year.label}',
                style: AppFonts.bodySmall.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ),
          verticalSpace(height: 16),
          AppTextField(
            controller: _timeController,
            hintText: 'وقت الحصة',
            prefixIcon: Icons.schedule_rounded,
            readOnly: true,
            onTap: _pickTime,
            validator: (value) =>
                AppValidators.required(value, message: 'اختر وقت الحصة'),
            reserveErrorSpace: true,
          ),
          const SheetLabel('أيام الحصة'),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final day in WeekDays.order)
                ClassroomChip(
                  label: WeekDays.label(day),
                  selected: _days.contains(day),
                  onTap: () => _toggleDay(day),
                ),
            ],
          ),
          verticalSpace(height: 14),
          if (_error != null)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                _error!,
                style: AppFonts.bodySmall.copyWith(color: palette.error),
              ),
            ),
          AppButton(label: 'إضافة الحصة', onPressed: _submit, expanded: true),
        ],
      ),
    );
  }
}
