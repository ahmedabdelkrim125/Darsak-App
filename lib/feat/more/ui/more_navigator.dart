import 'package:flutter/material.dart';
import '../../../core/settings/app_settings.dart';
import '../data/models/more_action.dart';
import 'about_sheet.dart';
import 'contact_us_screen.dart';
import 'edit_profile_screen.dart';
import 'help_center_screen.dart';
import 'language_sheet.dart';
import 'logout_sheet.dart';
import 'notification_settings_screen.dart';
import 'public_profile_screen.dart';
import 'subscription_sheet.dart';
import 'verification_screen.dart';

class MoreNavigator {
  MoreNavigator._();

  static void run(BuildContext context, MoreAction action) {
    switch (action) {
      case MoreAction.editProfile:
        push(context, const EditProfileScreen());
      case MoreAction.publicProfile:
        push(context, const PublicProfileScreen());
      case MoreAction.verification:
        push(context, const VerificationScreen());
      case MoreAction.subscription:
        SubscriptionSheet.show(context);
      case MoreAction.darkMode:
        final settings = AppSettings.instance;
        settings.setDark(!settings.isDark);
      case MoreAction.language:
        LanguageSheet.show(context);
      case MoreAction.notifications:
        push(context, const NotificationSettingsScreen());
      case MoreAction.help:
        push(context, const HelpCenterScreen());
      case MoreAction.contact:
        push(context, const ContactUsScreen());
      case MoreAction.about:
        AboutSheet.show(context);
      case MoreAction.logout:
        LogoutSheet.show(context);
    }
  }

  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}
