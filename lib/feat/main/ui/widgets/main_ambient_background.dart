import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';

class MainAmbientBackground extends StatelessWidget {
  const MainAmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = palette.background.computeLuminance() < 0.5;
    final width = MediaQuery.sizeOf(context).width;
    final strength = isDark ? 0.45 : 0.32;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.background, palette.surface],
        ),
      ),
      child: Stack(
        children: [
          _Orb(
            alignment: const Alignment(0.95, -0.85),
            diameter: width * 1.1,
            color: palette.primary.withValues(alpha: strength),
          ),
          _Orb(
            alignment: const Alignment(-1, -0.1),
            diameter: width * 0.95,
            color: palette.accent.withValues(alpha: strength * 0.9),
          ),
          _Orb(
            alignment: const Alignment(0.8, 0.6),
            diameter: width * 1.05,
            color: palette.primary.withValues(alpha: strength),
          ),
          _Orb(
            alignment: const Alignment(-0.85, 1),
            diameter: width * 1.1,
            color: palette.accent.withValues(alpha: strength),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({
    required this.alignment,
    required this.diameter,
    required this.color,
  });

  final Alignment alignment;
  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}
