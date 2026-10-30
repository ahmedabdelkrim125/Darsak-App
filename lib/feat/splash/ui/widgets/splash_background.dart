import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/const/app_assets.dart';
import '../../../../core/helper/responsive_extension.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.intro, required this.loop});

  final Animation<double> intro;
  final Animation<double> loop;

  static const Interval _reveal = Interval(0, 0.35, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRect(
      child: AnimatedBuilder(
        animation: Listenable.merge([intro, loop]),
        builder: (context, child) {
          final opacity = _reveal.transform(intro.value);
          final zoom = 1.2 - 0.16 * Curves.easeOutCubic.transform(intro.value);
          final floatY = sin(loop.value * 2 * pi) * 6.h;
          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, floatY),
              child: Transform.scale(scale: zoom, child: child),
            ),
          );
        },
        child: Image.asset(
          isDark ? AppAssets.splashBackDark : AppAssets.splashBack,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
