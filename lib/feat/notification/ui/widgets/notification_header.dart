import 'package:flutter/material.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/helper/responsive_extension.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({
    super.key,
    required this.unreadCount,
    required this.onBack,
    required this.onMarkAllRead,
  });

  final int unreadCount;
  final VoidCallback onBack;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
      child: Row(
        children: [
          Material(
            color: palette.surface,
            shape: CircleBorder(side: BorderSide(color: palette.track)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onBack,
              child: SizedBox(
                width: 42.r,
                height: 42.r,
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 20.r,
                  color: palette.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإشعارات',
                  style: AppFonts.headlineMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                if (unreadCount > 0)
                  Text(
                    '$unreadCount غير مقروء',
                    style: AppFonts.bodySmall.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: onMarkAllRead,
              style: TextButton.styleFrom(foregroundColor: palette.primary),
              icon: Icon(Icons.done_all_rounded, size: 18.r),
              label: Text(
                'قراءة الكل',
                style: AppFonts.labelMedium.copyWith(color: palette.primary),
              ),
            ),
        ],
      ),
    );
  }
}
