import 'package:flutter/material.dart';
import 'package:darsak_app/core/theme/app_colors.dart';

class SplashRipples extends StatelessWidget {
  const SplashRipples({super.key, required this.intro, required this.loop});

  final Animation<double> intro;
  final Animation<double> loop;

  static const Interval _appear = Interval(0.2, 0.5, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: Listenable.merge([intro, loop]),
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _RipplesPainter(
              appear: _appear.transform(intro.value),
              phase: loop.value,
            ),
          );
        },
      ),
    );
  }
}

class _RipplesPainter extends CustomPainter {
  _RipplesPainter({required this.appear, required this.phase});

  final double appear;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    if (appear <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.shortestSide * 0.8;
    final glowRadius = size.shortestSide * 0.45 * appear;

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primaryLight.withValues(alpha: 0.35 * appear),
          AppColors.accent.withValues(alpha: 0.12 * appear),
          Colors.transparent,
        ],
        stops: const [0, 0.55, 1],
      ).createShader(Rect.fromCircle(center: center, radius: glowRadius));
    canvas.drawCircle(center, glowRadius, glowPaint);

    for (var i = 0; i < 3; i++) {
      final t = (phase + i / 3) % 1.0;
      final radius = maxRadius * (0.2 + 0.8 * Curves.easeOut.transform(t));
      final alpha = (1 - t) * 0.4 * appear;
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 + (1 - t) * 3
        ..color = (i.isEven ? AppColors.primaryLight : AppColors.accent)
            .withValues(alpha: alpha);
      canvas.drawCircle(center, radius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplesPainter oldDelegate) {
    return oldDelegate.appear != appear || oldDelegate.phase != phase;
  }
}
