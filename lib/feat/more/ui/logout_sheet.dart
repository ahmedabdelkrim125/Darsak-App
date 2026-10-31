import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_button_style.dart';
import '../../auth/data/repo/auth_repository.dart';
import '../../classroom/data/classroom_store.dart';
import '../../payments/data/payments_store.dart';

class LogoutSheet extends StatelessWidget {
  const LogoutSheet({super.key, required this.hostContext});

  final BuildContext hostContext;

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show<void>(
      context,
      title: 'تسجيل الخروج',
      child: LogoutSheet(hostContext: context),
    );
  }

  void _logout(BuildContext context) {
    final navigator = Navigator.of(hostContext);
    Navigator.of(context).pop();
    navigator.pushNamedAndRemoveUntil(Routes.roleSelection, (route) => false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(getIt<AuthRepository>().signOut());
      ClassroomStore.instance.reset();
      PaymentsStore.instance.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'هل تريد تسجيل الخروج من حسابك؟',
          textAlign: TextAlign.center,
          style: AppFonts.bodyMedium.copyWith(color: palette.textPrimary),
        ),
        verticalSpace(height: 18),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'إلغاء',
                variant: AppButtonVariant.soft,
                expanded: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            horizontalSpace(width: 10),
            Expanded(
              child: AppButton(
                label: 'خروج',
                variant: AppButtonVariant.accent,
                expanded: true,
                onPressed: () => _logout(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
