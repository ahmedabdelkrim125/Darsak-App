import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/home_icons.dart';
import '../../data/models/home_file_model.dart';

class HomeFileCard extends StatelessWidget {
  const HomeFileCard({
    super.key,
    required this.file,
    required this.onTap,
    required this.onMenu,
  });

  final HomeFileModel file;
  final VoidCallback onTap;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.96,
      child: Container(
        padding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 12.h),
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppPressable(
                onTap: onMenu,
                pressedScale: 0.85,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    HomeIcons.menu,
                    size: 18.r,
                    color: palette.textSecondary,
                  ),
                ),
              ),
            ),
            Icon(file.icon, size: 40.r, color: file.color),
            verticalSpace(height: 10),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  file.name,
                  maxLines: 1,
                  style: AppFonts.bodySmall.copyWith(
                    color: palette.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            verticalSpace(height: 2),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  file.meta,
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                  style: AppFonts.bodySmall.copyWith(
                    color: palette.textSecondary,
                    fontSize: 10.sp,
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
