import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/groups_icons.dart';
import '../../data/models/group_card_model.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
    required this.onTap,
    required this.onMenu,
  });

  final GroupCardModel group;
  final VoidCallback onTap;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tone = group.tone.resolve(palette);

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: palette.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: palette.primary.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: tone.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(group.icon, size: 28.r, color: tone),
            ),
            horizontalSpace(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    group.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.titleMedium.copyWith(
                      color: palette.textPrimary,
                      fontSize: 15.sp,
                    ),
                  ),
                  verticalSpace(height: 2),
                  Text(
                    group.yearLabel,
                    style: AppFonts.bodySmall.copyWith(
                      color: palette.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                  verticalSpace(height: 8),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: [
                      _Pill(
                        icon: GroupsIcons.students,
                        text: '${group.studentsCount} طالب',
                        color: tone,
                      ),
                      _Pill(
                        icon: GroupsIcons.lessons,
                        text: '${group.lessonsCount} حصة أسبوعياً',
                        color: tone,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppPressable(
              onTap: onMenu,
              pressedScale: 0.85,
              child: SizedBox(
                width: 32.w,
                height: 40.h,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      GroupsIcons.menu,
                      size: 20.r,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: color),
          horizontalSpace(width: 4),
          Text(
            text,
            style: AppFonts.bodySmall.copyWith(
              color: palette.textPrimary,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
