import 'package:flutter/material.dart';
import '../../../../../core/helper/spacing.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_entrance.dart';
import '../../data/register_success_content.dart';
import 'success_card_shape.dart';
import '../../../widgets/auth_card_painter.dart';

import '../../../../../core/helper/responsive_extension.dart';
import '../../../../../core/widgets/app_success_check.dart';

class SuccessCard extends StatelessWidget {
  const SuccessCard({
    super.key,
    required this.intro,
    required this.loop,
    required this.content,
    required this.onStart,
  });

  final Animation<double> intro;
  final Animation<double> loop;
  final RegisterSuccessContent content;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return CustomPaint(
      painter: AuthCardPainter(
        fill: palette.surface,
        border: palette.track,
        shadow: palette.primary.withValues(alpha: 0.14),
        pathBuilder: SuccessCardShape.path,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 26.h, 24.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSuccessCheck(intro: intro, loop: loop),
            verticalSpace(height: 14),
            AppEntrance(
              animation: intro,
              begin: 0.45,
              span: 0.25,
              child: Text(
                content.title,
                textAlign: TextAlign.center,
                style: AppFonts.headlineMedium.copyWith(
                  color: palette.textPrimary,
                ),
              ),
            ),
            verticalSpace(height: 6),
            AppEntrance(
              animation: intro,
              begin: 0.55,
              span: 0.25,
              child: Text(
                '${content.welcome}\n${content.community}',
                textAlign: TextAlign.center,
                style: AppFonts.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ),
            verticalSpace(height: 18),
            AppEntrance(
              animation: intro,
              begin: 0.65,
              span: 0.3,
              child: AppButton(
                label: content.action,
                expanded: true,
                radius: 16.r,
                height: 52.h,
                onPressed: onStart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
