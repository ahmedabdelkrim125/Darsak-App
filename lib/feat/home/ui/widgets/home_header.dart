import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/home_content.dart';
import '../../data/home_icons.dart';
import 'home_notification_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onNotifications});

  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Container(
          width: 52.r,
          height: 52.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                palette.primary.withValues(alpha: 0.35),
                palette.accent.withValues(alpha: 0.35),
              ],
            ),
            border: Border.all(color: palette.background, width: 2),
          ),
          child: Icon(HomeIcons.user, size: 28.r, color: palette.primary),
        ),
        horizontalSpace(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مرحباً ${HomeContent.userName} 👋',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.headlineMedium.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              Text(
                HomeContent.greetingNote,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        horizontalSpace(width: 12),
        HomeNotificationButton(
          count: HomeContent.notificationCount,
          onTap: onNotifications,
        ),
      ],
    );
  }
}
