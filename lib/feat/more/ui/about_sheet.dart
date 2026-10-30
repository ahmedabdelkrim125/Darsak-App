import 'package:flutter/material.dart';
import '../../../core/const/app_assets.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../data/more_content.dart';

class AboutSheet extends StatelessWidget {
  const AboutSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show<void>(
      context,
      title: 'عن التطبيق',
      child: const AboutSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Image.asset(AppAssets.logo, width: 88.w, fit: BoxFit.contain),
        ),
        verticalSpace(height: 10),
        Text(
          MoreContent.appName,
          textAlign: TextAlign.center,
          style: AppFonts.headlineMedium.copyWith(color: palette.textPrimary),
        ),
        verticalSpace(height: 4),
        Text(
          'الإصدار ${MoreContent.appVersion}',
          textAlign: TextAlign.center,
          style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
        ),
        verticalSpace(height: 12),
        Text(
          MoreContent.appDescription,
          textAlign: TextAlign.center,
          style: AppFonts.bodyMedium.copyWith(
            color: palette.textPrimary,
            height: 1.6,
          ),
        ),
        verticalSpace(height: 18),
        AppButton(
          label: 'إغلاق',
          expanded: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
