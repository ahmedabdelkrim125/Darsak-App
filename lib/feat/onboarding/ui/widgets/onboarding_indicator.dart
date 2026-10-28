import 'package:flutter/material.dart';
import 'package:darsak_app/core/widgets/app_step_bar.dart';
import 'package:darsak_app/feat/onboarding/ui/widgets/onboarding_scroll.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.scroll,
    required this.intro,
  });

  final int count;
  final OnboardingScroll scroll;
  final Animation<double> intro;

  static const Interval _appear = Interval(0.6, 1, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([scroll.controller, intro]),
      builder: (context, _) {
        return Opacity(
          opacity: _appear.transform(intro.value),
          child: AppStepBar(count: count, value: scroll.page),
        );
      },
    );
  }
}
