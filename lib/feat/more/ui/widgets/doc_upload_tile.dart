import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/more_icons.dart';

class DocUploadTile extends StatelessWidget {
  const DocUploadTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.path,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final picked = path;

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: (picked == null ? palette.primary : palette.success)
                .withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                width: 60.r,
                height: 60.r,
                color: palette.primary.withValues(alpha: 0.08),
                child: picked == null
                    ? Icon(MoreIcons.upload, size: 26.r, color: palette.primary)
                    : Image.file(
                        File(picked),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          MoreIcons.check,
                          size: 26.r,
                          color: palette.success,
                        ),
                      ),
              ),
            ),
            horizontalSpace(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppFonts.titleMedium.copyWith(
                      color: palette.textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                  verticalSpace(height: 2),
                  Text(
                    picked == null
                        ? subtitle
                        : 'تم اختيار الصورة · اضغط للتغيير',
                    style: AppFonts.bodySmall.copyWith(
                      color: picked == null
                          ? palette.textSecondary
                          : palette.success,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
