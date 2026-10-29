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
import '../../../core/widgets/app_choice_chips.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../data/classroom_store.dart';
import '../data/models/classroom_lesson.dart';
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
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final Set<int> _days = {DateTime.now().weekday};
  late String? _groupId;
  TimeOfDay? _start;
  TimeOfDay? _end;
  LessonPlaceType _placeType = LessonPlaceType.online;
  String? _error;

  @override
  void initState() {
    super.initState();
    final groups = ClassroomStore.instance.groups;
    _groupId = groups.isEmpty ? null : groups.first.id;
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  Future<TimeOfDay?> _pick(TimeOfDay? current, TimeOfDay fallback) {
    FocusScope.of(context).unfocus();
    return showTimePicker(context: context, initialTime: current ?? fallback);
  }

  Future<void> _pickStart() async {
    final picked = await _pick(_start, const TimeOfDay(hour: 16, minute: 0));
    if (picked == null || !mounted) return;
    setState(() {
      _start = picked;
      _startController.text = formatTime(picked);
      if (_end == null) {
        final minutes = picked.hour * 60 + picked.minute + 90;
        if (minutes < 24 * 60) {
          final suggested = TimeOfDay(
            hour: minutes ~/ 60,
            minute: minutes % 60,
          );
          _end = suggested;
          _endController.text = formatTime(suggested);
        }
      }
      _error = null;
    });
  }

  Future<void> _pickEnd() async {
    final picked = await _pick(
      _end ?? _start,
      const TimeOfDay(hour: 17, minute: 30),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _end = picked;
      _endController.text = formatTime(picked);
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
    final start = _start;
    final end = _end;
    if (groupId == null || start == null || end == null) return;
    if (_days.isEmpty) {
      setState(() => _error = 'اختر يوماً واحداً على الأقل');
      return;
    }
    final error = ClassroomStore.instance.addLesson(
      groupId: groupId,
      time: start,
      endTime: end,
      weekdays: _days,
      placeType: _placeType,
      placeName: _placeController.text,
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
    final isOnline = _placeType == LessonPlaceType.online;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  controller: _startController,
                  hintText: 'وقت البداية',
                  prefixIcon: Icons.schedule_rounded,
                  readOnly: true,
                  onTap: _pickStart,
                  validator: (value) => AppValidators.required(
                    value,
                    message: 'اختر وقت البداية',
                  ),
                  reserveErrorSpace: true,
                ),
              ),
              horizontalSpace(width: 10),
              Expanded(
                child: AppTextField(
                  controller: _endController,
                  hintText: 'وقت النهاية',
                  prefixIcon: Icons.schedule_rounded,
                  readOnly: true,
                  onTap: _pickEnd,
                  validator: (value) => AppValidators.required(
                    value,
                    message: 'اختر وقت النهاية',
                  ),
                  reserveErrorSpace: true,
                ),
              ),
            ],
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
          verticalSpace(height: 16),
          const SheetLabel('مكان الحصة'),
          AppChoiceChips<LessonPlaceType>(
            items: const [
              AppChoiceItem<LessonPlaceType>(
                value: LessonPlaceType.online,
                label: 'أونلاين',
              ),
              AppChoiceItem<LessonPlaceType>(
                value: LessonPlaceType.onsite,
                label: 'حضوري',
              ),
            ],
            value: _placeType,
            onChanged: (value) => setState(() => _placeType = value),
          ),
          verticalSpace(height: 14),
          AppTextField(
            controller: _placeController,
            hintText: isOnline
                ? 'المنصة (Zoom, Google Meet...)'
                : 'القاعة أو المكان',
            prefixIcon: isOnline
                ? Icons.videocam_outlined
                : Icons.location_on_outlined,
            textInputAction: TextInputAction.done,
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
          AppButton(label: 'إضافة الحصة', onPressed: _submit, expanded: true),
        ],
      ),
    );
  }
}
