import 'dart:math';
import 'package:flutter/material.dart';

class CheckMarkPainter extends CustomPainter {
  const CheckMarkPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final path = Path()
      ..moveTo(size.width * 0.27, size.height * 0.52)
      ..lineTo(size.width * 0.44, size.height * 0.68)
      ..lineTo(size.width * 0.74, size.height * 0.34);
    final metric = path.computeMetrics().first;

    canvas.drawPath(
      metric.extractPath(0, metric.length * progress),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.1
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant CheckMarkPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class SuccessBurstPainter extends CustomPainter {
  const SuccessBurstPainter({
    required this.rays,
    required this.ring,
    required this.rayColors,
    required this.ringColor,
  });

  final double rays;
  final double ring;
  final List<Color> rayColors;
  final Color ringColor;

  static const List<double> _angles = [-2.4, -0.74, pi, 0, 2.4, 0.74];

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final base = size.height / 2;

    if (ring > 0 && ring < 1) {
      canvas.drawCircle(
        center,
        base * (1 + 0.6 * ring),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = ringColor.withValues(alpha: 0.4 * (1 - ring)),
      );
    }

    if (rays <= 0) return;

    final grow = (rays * 2).clamp(0.0, 1.0).toDouble();
    final alpha = (rays * 6).clamp(0.0, 1.0).toDouble();
    final inner = base * (1.34 + 0.2 * rays);
    final length = base * 0.3 * grow;

    for (var i = 0; i < _angles.length; i++) {
      final direction = Offset(cos(_angles[i]), sin(_angles[i]));
      canvas.drawLine(
        center + direction * inner,
        center + direction * (inner + length),
        Paint()
          ..strokeCap = StrokeCap.round
          ..strokeWidth = base * 0.12
          ..color = rayColors[i % rayColors.length].withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant SuccessBurstPainter oldDelegate) {
    return oldDelegate.rays != rays ||
        oldDelegate.ring != ring ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.rayColors != rayColors;
  }
}
