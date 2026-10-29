import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_button_style.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../data/classroom_store.dart';
import '../add_student_sheet.dart';
import '../group_details_sheet.dart';
import 'classroom_action_row.dart';

class GroupActionsSheet extends StatefulWidget {
  const GroupActionsSheet({
    super.key,
    required this.groupId,
    required this.hostContext,
  });

  final String groupId;
  final BuildContext hostContext;

  static Future<void> show(BuildContext context, String groupId) {
    return AppBottomSheet.show<void>(
      context,
      title: 'خيارات المجموعة',
      child: GroupActionsSheet(groupId: groupId, hostContext: context),
    );
  }

  @override
  State<GroupActionsSheet> createState() => _GroupActionsSheetState();
}

class _GroupActionsSheetState extends State<GroupActionsSheet> {
  bool _confirming = false;

  void _showDetails() {
    Navigator.of(context).pop();
    if (widget.hostContext.mounted) {
      GroupDetailsSheet.show(widget.hostContext, widget.groupId);
    }
  }

  void _addStudent() {
    Navigator.of(context).pop();
    if (widget.hostContext.mounted) {
      AddStudentSheet.show(widget.hostContext, initialGroupId: widget.groupId);
    }
  }

  void _delete() {
    ClassroomStore.instance.deleteGroup(widget.groupId);
    AppToast.show(context, 'تم حذف المجموعة');
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
            'سيتم حذف المجموعة وطلابها وكل حصصها. هل تريد المتابعة؟',
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
        ClassroomActionRow(
          icon: SolarIconsOutline.eye,
          label: 'عرض المجموعة',
          color: palette.textPrimary,
          onTap: _showDetails,
        ),
        verticalSpace(height: 8),
        ClassroomActionRow(
          icon: SolarIconsOutline.userPlus,
          label: 'إضافة طالب',
          color: palette.textPrimary,
          onTap: _addStudent,
        ),
        verticalSpace(height: 8),
        ClassroomActionRow(
          icon: SolarIconsOutline.trashBinMinimalistic,
          label: 'حذف المجموعة',
          color: palette.error,
          onTap: () => setState(() => _confirming = true),
        ),
      ],
    );
  }
}
