import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_button_style.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_toast.dart';
import '../data/classroom_store.dart';
import 'lesson_details_sheet.dart';

class LessonActionsSheet extends StatefulWidget {
  const LessonActionsSheet({
    super.key,
    required this.lessonId,
    required this.hostContext,
  });

  final String lessonId;
  final BuildContext hostContext;

  static Future<void> show(BuildContext context, String lessonId) {
    return AppBottomSheet.show<void>(
      context,
      title: 'خيارات الحصة',
      child: LessonActionsSheet(lessonId: lessonId, hostContext: context),
    );
  }

  @override
  State<LessonActionsSheet> createState() => _LessonActionsSheetState();
}

class _LessonActionsSheetState extends State<LessonActionsSheet> {
  bool _confirming = false;

  void _showDetails() {
    Navigator.of(context).pop();
    if (widget.hostContext.mounted) {
      LessonDetailsSheet.show(widget.hostContext, widget.lessonId);
    }
  }

  void _delete() {
    ClassroomStore.instance.deleteLesson(widget.lessonId);
    AppToast.show(context, 'تم حذف الحصة');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (_confirming) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'سيتم حذف الحصة من كل أيامها. هل تريد المتابعة؟',
            textAlign: TextAlign.center,
            style: AppFonts.bodyMedium.copyWith(color: palette.textPrimary),
          ),
          verticalSpace(height: 18),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'إلغاء',
                  variant: AppButtonVariant.soft,
                  expanded: true,
                  onPressed: () => setState(() => _confirming = false),
                ),
              ),
              horizontalSpace(width: 10),
              Expanded(
                child: AppButton(
                  label: 'حذف',
                  variant: AppButtonVariant.accent,
                  expanded: true,
                  onPressed: _delete,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActionRow(
          icon: SolarIconsOutline.eye,
          label: 'عرض التفاصيل',
          color: palette.textPrimary,
          onTap: _showDetails,
        ),
        verticalSpace(height: 8),
        _ActionRow(
          icon: SolarIconsOutline.trashBinMinimalistic,
          label: 'حذف الحصة',
          color: palette.error,
          onTap: () => setState(() => _confirming = true),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: palette.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22.r, color: color),
            horizontalSpace(width: 12),
            Text(label, style: AppFonts.bodyMedium.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
