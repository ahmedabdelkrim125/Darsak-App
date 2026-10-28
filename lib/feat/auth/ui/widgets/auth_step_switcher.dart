import 'package:flutter/material.dart';

class AuthStepSwitcher extends StatelessWidget {
  const AuthStepSwitcher({
    super.key,
    required this.step,
    required this.forward,
    required this.child,
  });

  final int step;
  final bool forward;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (current, previous) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [...previous, ?current],
        );
      },
      transitionBuilder: (child, animation) {
        final entering = child.key == ValueKey<int>(step);
        final side = entering ? (forward ? 1.0 : -1.0) : (forward ? -1.0 : 1.0);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.15 * side, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(key: ValueKey<int>(step), child: child),
    );
  }
}
