import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';

class RoleEntrance extends StatelessWidget {
  const RoleEntrance({
    super.key,
    required this.animation,
    required this.begin,
    required this.child,
  });

  final Animation<double> animation;
  final double begin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final end = (begin + 0.4).clamp(0.0, 1.0).toDouble();
    final interval = Interval(begin, end, curve: Curves.easeOutCubic);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = interval.transform(animation.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 24.h),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
