import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/session/app_session.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../data/home_content.dart';
import 'home_notification_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.onNotifications,
  });

  final String name;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        AppAvatar(size: 52.r, path: AppSession.instance.avatarPath),
        horizontalSpace(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مرحباً $name 👋',
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
