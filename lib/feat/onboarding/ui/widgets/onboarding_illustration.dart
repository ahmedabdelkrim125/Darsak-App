import 'dart:math';
import 'package:flutter/material.dart';
import 'onboarding_scroll.dart';

import '../../../../core/helper/responsive_extension.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    super.key,
    required this.index,
    required this.image,
    required this.scroll,
    required this.intro,
    required this.loop,
  });

  final int index;
  final String image;
  final OnboardingScroll scroll;
  final Animation<double> intro;
  final Animation<double> loop;

  static const Interval _enter = Interval(0, 0.6, curve: Curves.elasticOut);
  static const Interval _fade = Interval(0, 0.25, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    const sign = OnboardingScroll.flow;
    final width = context.screenWidth;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListenableBuilder(
        listenable: Listenable.merge([scroll.controller, intro, loop]),
        builder: (context, child) {
          final delta = scroll.delta(index);
          final away = delta.abs().clamp(0.0, 1.0).toDouble();
          final enter = _enter.transform(intro.value);
          final fade = _fade.transform(intro.value);
          final floatY = sin(loop.value * 2 * pi + index * 1.3) * 8.h;
          final scale = (1 - 0.3 * away) * (0.6 + 0.4 * enter);
          final tilt = delta.clamp(-1.0, 1.0).toDouble() * 0.9 * -sign;
          final opacity = ((1 - away * 1.1).clamp(0.0, 1.0)).toDouble() * fade;

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(sign * delta * width * 0.3, floatY),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateY(tilt),
                child: Transform.scale(scale: scale, child: child),
              ),
            ),
          );
        },
        child: Image.asset(image, fit: BoxFit.contain, gaplessPlayback: true),
      ),
    );
  }
}
