import 'package:flutter/material.dart';
import 'package:darsak_app/core/widgets/app_text_button.dart';
import '../../../../core/helper/responsive_extension.dart';

class OnboardingSkip extends StatelessWidget {
  const OnboardingSkip({super.key, required this.intro, required this.onSkip});

  final Animation<double> intro;
  final VoidCallback onSkip;

  static const Interval _appear = Interval(0.5, 0.9, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AnimatedBuilder(
        animation: intro,
        builder: (context, child) {
          final t = _appear.transform(intro.value);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, -16.h * (1 - t)),
              child: child,
            ),
          );
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h),
            child: AppTextButton(
              label: 'تخطي',
              onPressed: onSkip,
              icon: Icons.chevron_right_rounded,
            ),
          ),
        ),
      ),
    );
  }
}
