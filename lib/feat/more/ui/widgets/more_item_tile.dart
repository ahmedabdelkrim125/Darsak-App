import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/models/more_item_model.dart';
import '../../data/more_icons.dart';

class MoreItemTile extends StatelessWidget {
  const MoreItemTile({
    super.key,
    required this.item,
    required this.onTap,
    this.trailing,
  });

  final MoreItemModel item;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tone = item.tone.resolve(palette);

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.99,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: tone.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(item.icon, size: 22.r, color: tone),
            ),
            horizontalSpace(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.titleMedium.copyWith(
                      color: palette.textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                  verticalSpace(height: 2),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.bodySmall.copyWith(
                      color: palette.textSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            horizontalSpace(width: 8),
            trailing ??
                Icon(
                  MoreIcons.chevron,
                  size: 18.r,
                  color: palette.textSecondary,
                ),
          ],
        ),
      ),
    );
  }
}
