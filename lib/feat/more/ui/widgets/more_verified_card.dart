import 'package:flutter/material.dart';
import '../../../../core/const/app_assets.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/more_content.dart';
import '../../data/more_icons.dart';

class MoreVerifiedCard extends StatelessWidget {
  const MoreVerifiedCard({
    super.key,
    required this.verified,
    required this.onTap,
  });

  final bool verified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    const amber = Color(0xFFF59E0B);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: palette.primary.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          AppPressable(
            onTap: onTap,
            pressedScale: 0.95,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: palette.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Text(
                verified
                    ? MoreContent.verifiedAction
                    : MoreContent.unverifiedAction,
                style: AppFonts.labelMedium.copyWith(
                  color: palette.primary,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          horizontalSpace(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        verified
                            ? MoreContent.verifiedTitle
                            : MoreContent.unverifiedTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.titleMedium.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    if (verified) ...[
                      horizontalSpace(width: 6),
                      Icon(
                        MoreIcons.verified,
                        size: 18.r,
                        color: palette.success,
                      ),
                    ],
                  ],
                ),
                verticalSpace(height: 4),
                Text(
                  verified
                      ? MoreContent.verifiedDescription
                      : MoreContent.unverifiedDescription,
                  style: AppFonts.bodySmall.copyWith(
                    color: palette.textSecondary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(width: 8),
          if (verified)
            Image.asset(
              AppAssets.verifiedBadge,
              width: 72.w,
              fit: BoxFit.contain,
            )
          else
            Container(
              width: 60.r,
              height: 60.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: amber.withValues(alpha: 0.15),
              ),
              child: Icon(MoreIcons.shield, size: 30.r, color: amber),
            ),
        ],
      ),
    );
  }
}
