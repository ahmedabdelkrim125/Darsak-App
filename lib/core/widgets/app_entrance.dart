import 'package:flutter/material.dart';
import '../helper/responsive_extension.dart';

class AppEntrance extends StatelessWidget {
  const AppEntrance({
    super.key,
    required this.animation,
    required this.child,
    this.begin = 0,
    this.span = 0.4,
    this.from,
    this.curve = Curves.easeOutCubic,
  });

  final Animation<double> animation;
  final Widget child;
  final double begin;
  final double span;
  final Offset? from;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final start = from ?? Offset(0, 24.h);
    final from0 = begin.clamp(0.0, 1.0).toDouble();
    final to1 = (begin + span).clamp(0.0, 1.0).toDouble();
    final interval = Interval(from0, to1, curve: curve);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = interval.transform(animation.value);
        return Opacity(
          opacity: t.clamp(0.0, 1.0).toDouble(),
          child: Transform.translate(
            offset: Offset(start.dx * (1 - t), start.dy * (1 - t)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
