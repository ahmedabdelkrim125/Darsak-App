import 'package:flutter/material.dart';
import '../../../../core/const/app_assets.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/home_content.dart';
import 'home_banner_sparkle.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = BorderRadius.circular(28.r);

    return Container(
      height: 172.h,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.primary.withValues(alpha: 0.14),
            palette.accent.withValues(alpha: 0.07),
          ],
        ),
        border: Border.all(color: palette.primary.withValues(alpha: 0.06)),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 36.w),
                      child: const HomeBannerSparkle(),
                    ),
                    verticalSpace(height: 6),
                    Text(
                      HomeContent.bannerTitle,
                      style: AppFonts.headlineLarge.copyWith(
                        color: palette.textPrimary,
                        fontSize: 24.sp,
                        height: 1.3,
                      ),
                    ),
                    verticalSpace(height: 8),
                    Text(
                      HomeContent.bannerDescription,
                      style: AppFonts.bodySmall.copyWith(
                        color: palette.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 11,
              child: Image.asset(
                AppAssets.teacher,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
