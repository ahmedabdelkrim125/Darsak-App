import 'package:flutter/material.dart';
import '../../../../core/widgets/app_step_bar.dart';
import '../../../../core/helper/responsive_extension.dart';

class AuthStepProgress extends StatelessWidget {
  const AuthStepProgress({super.key, required this.count, required this.step});

  final int count;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: step.toDouble()),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: AppStepBar(
              count: count,
              value: value,
              inactiveWidth: 24.w,
              activeWidth: 64.w,
            ),
          );
        },
      ),
    );
  }
}
