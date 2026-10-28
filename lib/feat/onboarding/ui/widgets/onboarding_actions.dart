import 'package:flutter/material.dart';
import '../../../../core/widgets/app_button_style.dart';
import 'onboarding_indicator.dart';
import 'onboarding_nav_button.dart';
import 'onboarding_scroll.dart';

import '../../../../core/helper/responsive_extension.dart';

class OnboardingActions extends StatelessWidget {
  const OnboardingActions({
    super.key,
    required this.count,
    required this.scroll,
    required this.intro,
    required this.onNext,
    required this.onBack,
  });

  final int count;
  final OnboardingScroll scroll;
  final Animation<double> intro;
  final VoidCallback onNext;
  final VoidCallback onBack;

  static const Interval _fade = Interval(0.65, 1, curve: Curves.easeOut);
  static const Interval _slide = Interval(0.65, 1, curve: Curves.easeOutBack);

  @override
  Widget build(BuildContext context) {
    final slot = 64.h;

    return ListenableBuilder(
      listenable: Listenable.merge([scroll.controller, intro]),
      builder: (context, _) {
        final index = scroll.current;
        final isLast = index == count - 1;
        final fade = _fade.transform(intro.value);
        final slide = _slide.transform(intro.value);

        return Opacity(
          opacity: fade,
          child: Transform.translate(
            offset: Offset(0, (1 - slide) * 60.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    SizedBox(
                      width: slot,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: OnboardingNavButton(
                          icon: Icons.chevron_left_rounded,
                          onPressed: onBack,
                          size: 52.h,
                          visible: index > 0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: OnboardingIndicator(
                          count: count,
                          scroll: scroll,
                          intro: intro,
                        ),
                      ),
                    ),
                    OnboardingNavButton(
                      icon: isLast
                          ? Icons.check_rounded
                          : Icons.chevron_right_rounded,
                      onPressed: onNext,
                      variant: AppButtonVariant.primary,
                      size: slot,
                      iconSize: 30.r,
                      pulse: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
