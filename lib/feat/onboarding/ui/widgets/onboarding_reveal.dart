import 'dart:math';
import 'package:flutter/material.dart';

class OnboardingReveal {
  OnboardingReveal._();

  static const double originX = 0.95;
  static const double originY = 1.1;

  static Offset origin(Size size) {
    return Offset(size.width * originX, size.height * originY);
  }

  static double maxRadius(Size size) {
    final center = origin(size);
    final dx = max(center.dx, size.width - center.dx);
    final dy = max(center.dy, size.height - center.dy);
    return sqrt(dx * dx + dy * dy);
  }
}

class RevealClipper extends CustomClipper<Path> {
  const RevealClipper({required this.progress});

  final double progress;

  @override
  Path getClip(Size size) {
    final radius = OnboardingReveal.maxRadius(size) * progress;
    return Path()..addOval(
      Rect.fromCircle(center: OnboardingReveal.origin(size), radius: radius),
    );
  }

  @override
  bool shouldReclip(covariant RevealClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

class RevealRingPainter extends CustomPainter {
  const RevealRingPainter({
    required this.progress,
    required this.primary,
    required this.accent,
  });

  final double progress;
  final Color primary;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final center = OnboardingReveal.origin(size);
    final maxRadius = OnboardingReveal.maxRadius(size);
    final fade = sin(pi * progress);

    final leading = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 + 5 * (1 - progress)
      ..color = primary.withValues(alpha: 0.55 * fade);
    canvas.drawCircle(center, maxRadius * progress, leading);

    final trailing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = accent.withValues(alpha: 0.35 * fade);
    canvas.drawCircle(center, maxRadius * progress * 0.93, trailing);
  }

  @override
  bool shouldRepaint(covariant RevealRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primary != primary ||
        oldDelegate.accent != accent;
  }
}
