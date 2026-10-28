import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../../core/helper/responsive_extension.dart';

class SuccessConfetti extends StatelessWidget {
  const SuccessConfetti({
    super.key,
    required this.progress,
    required this.originY,
    required this.colors,
  });

  final Animation<double> progress;
  final double originY;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _ConfettiPainter(
          progress: progress,
          originY: originY,
          colors: colors,
        ),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.spin,
    required this.delay,
    required this.colorIndex,
    required this.round,
  });

  final double angle;
  final double speed;
  final double size;
  final double spin;
  final double delay;
  final int colorIndex;
  final bool round;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.progress,
    required this.originY,
    required this.colors,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final double originY;
  final List<Color> colors;

  static const Interval _window = Interval(0.34, 1);
  static final List<_Particle> _particles = _generate();

  static List<_Particle> _generate() {
    final random = Random(42);
    return List.generate(30, (index) {
      return _Particle(
        angle: -pi * (0.08 + 0.84 * random.nextDouble()),
        speed: 0.85 + 0.6 * random.nextDouble(),
        size: 4 + 4 * random.nextDouble(),
        spin: (random.nextDouble() - 0.5) * 2,
        delay: 0.12 * random.nextDouble(),
        colorIndex: random.nextInt(4),
        round: random.nextBool(),
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final t = _window.transform(progress.value);
    if (t <= 0 || t >= 1) return;

    final range = 300.h;
    final origin = Offset(size.width / 2, originY);
    final paint = Paint();

    for (final particle in _particles) {
      final tt = ((t - particle.delay) / (1 - particle.delay))
          .clamp(0.0, 1.0)
          .toDouble();
      if (tt <= 0) continue;

      final dx = cos(particle.angle) * particle.speed * range * 0.9 * tt;
      final dy =
          sin(particle.angle) * particle.speed * range * tt +
          0.9 * range * tt * tt;
      final fade = pow(1 - tt, 1.3).toDouble();

      paint.color = colors[particle.colorIndex % colors.length].withValues(
        alpha: fade,
      );
      canvas.save();
      canvas.translate(origin.dx + dx, origin.dy + dy);
      canvas.rotate(particle.spin * tt * 8);
      if (particle.round) {
        canvas.drawCircle(Offset.zero, particle.size * 0.5, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size * 1.6,
              height: particle.size * 0.7,
            ),
            const Radius.circular(1.5),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.originY != originY || oldDelegate.colors != colors;
  }
}
