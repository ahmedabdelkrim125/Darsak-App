import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/home_icons.dart';

class HomeNotificationButton extends StatelessWidget {
  const HomeNotificationButton({
    super.key,
    required this.count,
    required this.onTap,
  });

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = 46.r;

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.9,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.surface.withValues(alpha: 0.8),
                  border: Border.all(
                    color: palette.primary.withValues(alpha: 0.08),
                  ),
                ),
                child: Center(
                  child: Icon(
                    HomeIcons.bell,
                    size: 24.r,
                    color: palette.textPrimary,
                  ),
                ),
              ),
            ),
            if (count > 0)
              Positioned(
                top: -4.r,
                right: -4.r,
                child: Container(
                  constraints: BoxConstraints(minWidth: 20.r, minHeight: 20.r),
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: palette.accent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '$count',
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white,
                      fontSize: 11.sp,
                      height: 1,
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
