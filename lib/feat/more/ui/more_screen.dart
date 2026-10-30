import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/session/app_session.dart';
import '../../../core/settings/app_settings.dart';
import '../../../core/theme/app_palette.dart';
import '../../home/data/home_content.dart';
import '../../home/ui/widgets/home_header.dart';
import '../data/models/more_action.dart';
import '../data/more_content.dart';
import 'more_navigator.dart';
import 'widgets/image_source_sheet.dart';
import 'widgets/more_logout_tile.dart';
import 'widgets/more_profile_card.dart';
import 'widgets/more_section_card.dart';
import 'widgets/more_verified_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  Future<void> _changeAvatar(BuildContext context) async {
    final session = AppSession.instance;
    final result = await ImageSourceSheet.choose(
      context,
      canRemove: session.avatarPath != null,
    );
    if (result == null) return;
    session.setAvatar(result.path);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final padding = MediaQuery.paddingOf(context);
    final session = AppSession.instance;
    final settings = AppSettings.instance;

    return ColoredBox(
      color: palette.background,
      child: AdaptiveContentWrapper(
        child: ListenableBuilder(
          listenable: Listenable.merge([session, settings]),
          builder: (context, _) {
            final headerName = session.firstName.isEmpty
                ? HomeContent.userName
                : session.firstName;
            final cardName = session.fullName.isEmpty
                ? 'معلم درسّك'
                : session.fullName;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                16.w,
                padding.top + 12.h,
                16.w,
                padding.bottom + 110.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeHeader(
                    name: headerName,
                    onNotifications: () =>
                        MoreNavigator.run(context, MoreAction.notifications),
                  ),
                  verticalSpace(height: 18),
                  MoreProfileCard(
                    name: cardName,
                    subject: session.subject,
                    email: session.email,
                    phone: session.phone,
                    avatarPath: session.avatarPath,
                    onEdit: () =>
                        MoreNavigator.run(context, MoreAction.editProfile),
                    onChangeAvatar: () => _changeAvatar(context),
                  ),
                  verticalSpace(height: 12),
                  MoreVerifiedCard(
                    verified: session.isVerified,
                    onTap: () =>
                        MoreNavigator.run(context, MoreAction.verification),
                  ),
                  verticalSpace(height: 12),
                  for (final section in MoreContent.sections) ...[
                    MoreSectionCard(
                      section: section,
                      darkMode: settings.isDark,
                      onDarkChanged: settings.setDark,
                      onTap: (action) => MoreNavigator.run(context, action),
                    ),
                    verticalSpace(height: 12),
                  ],
                  MoreLogoutTile(
                    onTap: () => MoreNavigator.run(context, MoreAction.logout),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
