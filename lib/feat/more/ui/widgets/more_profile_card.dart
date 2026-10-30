import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/more_content.dart';
import '../../data/more_icons.dart';
import 'more_avatar.dart';

class MoreProfileCard extends StatelessWidget {
  const MoreProfileCard({
    super.key,
    required this.name,
    required this.subject,
    required this.email,
    required this.phone,
    required this.avatarPath,
    required this.onEdit,
    required this.onChangeAvatar,
  });

  final String name;
  final String subject;
  final String email;
  final String phone;
  final String? avatarPath;
  final VoidCallback onEdit;
  final VoidCallback onChangeAvatar;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final infoStyle = AppFonts.bodyMedium.copyWith(
      color: palette.textSecondary,
      fontSize: 13.sp,
    );

    Widget infoRow(IconData icon, String text, {bool ltr = false}) {
      return Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: Row(
          children: [
            Icon(icon, size: 16.r, color: palette.textSecondary),
            horizontalSpace(width: 6),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: ltr ? TextDirection.ltr : null,
                  style: infoStyle,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoreAvatar(size: 84.r, path: avatarPath, onTap: onChangeAvatar),
          horizontalSpace(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.titleLarge.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                infoRow(
                  MoreIcons.subject,
                  subject.isEmpty ? 'معلم' : 'معلم $subject',
                ),
                if (email.isNotEmpty)
                  infoRow(MoreIcons.email, email, ltr: true),
                if (phone.isNotEmpty)
                  infoRow(MoreIcons.phone, phone, ltr: true),
                verticalSpace(height: 10),
                AppPressable(
                  onTap: onEdit,
                  pressedScale: 0.96,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: palette.background.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: palette.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          MoreContent.editProfileAction,
                          style: AppFonts.labelMedium.copyWith(
                            color: palette.primary,
                            fontSize: 13.sp,
                          ),
                        ),
                        horizontalSpace(width: 4),
                        Icon(
                          MoreIcons.chevron,
                          size: 16.r,
                          color: palette.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
