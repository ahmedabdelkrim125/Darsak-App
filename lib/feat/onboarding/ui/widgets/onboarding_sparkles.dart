import 'dart:math';
import 'package:flutter/material.dart';

class OnboardingSparkles extends StatelessWidget {
  const OnboardingSparkles({
    super.key,
    required this.phase,
    required this.burst,
    required this.opacity,
    required this.colors,
  });

  final double phase;
  final double burst;
  final double opacity;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipRect(
        child: CustomPaint(
          size: Size.infinite,
          painter: _SparklesPainter(
            phase: phase,
            burst: burst,
            opacity: opacity,
            colors: colors,
          ),
        ),
      ),
    );
  }
}

class _Sparkle {
  const _Sparkle(this.x, this.y, this.size, this.phase, this.kind);

  final double x;
  final double y;
  final double size;
  final double phase;
  final int kind;
}

class _SparklesPainter extends CustomPainter {
  const _SparklesPainter({
    required this.phase,
    required this.burst,
    required this.opacity,
    required this.colors,
  });

  final double phase;
  final double burst;
  final double opacity;
  final List<Color> colors;

  static const List<_Sparkle> _items = [
    _Sparkle(0.08, 0.18, 5, 0.00, 1),
    _Sparkle(0.90, 0.12, 4, 0.15, 0),
    _Sparkle(0.15, 0.55, 3.5, 0.30, 2),
    _Sparkle(0.93, 0.50, 5.5, 0.45, 1),
    _Sparkle(0.05, 0.85, 4, 0.60, 0),
    _Sparkle(0.85, 0.88, 3.5, 0.75, 2),
    _Sparkle(0.30, 0.05, 3, 0.90, 0),
    _Sparkle(0.70, 0.04, 4.5, 0.20, 1),
    _Sparkle(0.50, 0.97, 3.5, 0.55, 0),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      final cycle = (phase + item.phase) % 1.0;
      final twinkle = sin(cycle * 2 * pi) * 0.5 + 0.5;
      final base = Offset(item.x * size.width, item.y * size.height);
      final push =
          Offset(item.x - 0.5, item.y - 0.5) *
          (burst * size.shortestSide * 0.4);
      final drift = Offset(sin(cycle * 2 * pi) * 4, cos(cycle * 2 * pi) * 6);
      final position = base + push + drift;
      final alpha =
          (0.2 + 0.6 * twinkle + 0.4 * burst).clamp(0.0, 1.0).toDouble() *
          opacity;
      final radius = item.size * (0.7 + 0.5 * twinkle + 0.8 * burst);
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: alpha)
        ..strokeCap = StrokeCap.round;

      switch (item.kind) {
        case 0:
          canvas.drawCircle(position, radius, paint);
        case 1:
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.7;
          canvas.drawLine(
            position - Offset(radius * 1.6, 0),
            position + Offset(radius * 1.6, 0),
            paint,
          );
          canvas.drawLine(
            position - Offset(0, radius * 1.6),
            position + Offset(0, radius * 1.6),
            paint,
          );
        default:
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6;
          canvas.drawCircle(position, radius * 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SparklesPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.burst != burst ||
        oldDelegate.opacity != opacity ||
        oldDelegate.colors != colors;
  }
}
