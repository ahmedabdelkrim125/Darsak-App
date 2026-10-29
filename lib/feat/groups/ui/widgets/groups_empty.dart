import 'package:flutter/material.dart';
import '../../../../core/const/app_assets.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../schedule/ui/widgets/schedule_add_button.dart';
import '../../data/groups_content.dart';

class GroupsEmpty extends StatelessWidget {
  const GroupsEmpty({super.key, required this.searching, required this.onAdd});

  final bool searching;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: palette.primary.withValues(alpha: 0.06)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppAssets.scheduleEmpty,
            width: 130.w,
            fit: BoxFit.contain,
          ),
          verticalSpace(height: 10),
          Text(
            searching ? GroupsContent.noResults : GroupsContent.emptyTitle,
            textAlign: TextAlign.center,
            style: AppFonts.titleMedium.copyWith(color: palette.textPrimary),
          ),
          verticalSpace(height: 4),
          Text(
            searching
                ? GroupsContent.noResultsDescription
                : GroupsContent.emptyDescription,
            textAlign: TextAlign.center,
            style: AppFonts.bodySmall.copyWith(
              color: palette.textSecondary,
              fontSize: 12.sp,
            ),
          ),
          if (!searching) ...[
            verticalSpace(height: 14),
            ScheduleAddButton(label: GroupsContent.addGroup, onTap: onAdd),
          ],
        ],
      ),
    );
  }
}
