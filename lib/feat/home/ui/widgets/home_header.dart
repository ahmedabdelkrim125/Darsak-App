import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/session/app_session.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../notification/data/notification_store.dart';
import '../../../notification/ui/notification_navigator.dart';
import '../../data/home_content.dart';
import 'home_notification_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final store = NotificationStore.instance;

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
        ListenableBuilder(
          listenable: store,
          builder: (context, _) => HomeNotificationButton(
            count: store.unreadCount,
            onTap: () => NotificationNavigator.open(context),
          ),
        ),
      ],
    );
  }
}
