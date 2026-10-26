import 'dart:math';
import 'package:flutter/material.dart';
import 'package:darsak_app/core/theme/app_colors.dart';

import '../../../../core/helper/responsive_extension.dart';

class SplashOrbit extends StatelessWidget {
  const SplashOrbit({super.key, required this.intro});

  final Animation<double> intro;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: intro,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _OrbitPainter(progress: intro.value),
          );
        },
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({required this.progress});

  final double progress;

  static const int _count = 14;
  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.accent,
    AppColors.primaryLight,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final inward = Curves.easeOutCubic.transform(
      (progress / 0.55).clamp(0.0, 1.0).toDouble(),
    );
    final fadeOut = 1 - ((progress - 0.8) / 0.2).clamp(0.0, 1.0).toDouble();
    final fadeIn = (progress / 0.1).clamp(0.0, 1.0).toDouble();
    final startRadius = size.longestSide * 0.6;
    final endRadius = size.shortestSide * 0.36;
    final radius = startRadius + (endRadius - startRadius) * inward;
    final spin = (1 - inward) * pi * 1.5 + progress * pi * 0.6;

    for (var i = 0; i < _count; i++) {
      final angle = spin + i * 2 * pi / _count;
      final position = center + Offset(cos(angle), sin(angle)) * radius;
      final dotRadius = (3 + (i % 3) * 1.5).r * (0.5 + 0.5 * inward);
      final paint = Paint()
        ..color = _colors[i % _colors.length].withValues(
          alpha: 0.85 * fadeOut * fadeIn,
        );
      canvas.drawCircle(position, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
