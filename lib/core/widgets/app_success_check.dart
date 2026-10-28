import 'dart:math';
import 'package:flutter/material.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import 'package:darsak_app/core/widgets/app_success_check_painters.dart';
import '../helper/responsive_extension.dart';

class AppSuccessCheck extends StatelessWidget {
  const AppSuccessCheck({
    super.key,
    required this.intro,
    required this.loop,
    this.size,
  });

  final Animation<double> intro;
  final Animation<double> loop;
  final double? size;

  static const Interval _pop = Interval(0.10, 0.42, curve: Curves.elasticOut);
  static const Interval _draw = Interval(
    0.30,
    0.55,
    curve: Curves.easeOutCubic,
  );
  static const Interval _ring = Interval(0.28, 0.65, curve: Curves.easeOut);
  static const Interval _rays = Interval(
    0.34,
    0.75,
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final dimension = size ?? 64.h;

    return SizedBox(
      width: dimension * 2.2,
      height: dimension,
      child: ListenableBuilder(
        listenable: Listenable.merge([intro, loop]),
        builder: (context, _) {
          final pop = _pop.transform(intro.value);
          final pulse = sin(loop.value * 2 * pi) * 0.5 + 0.5;
          final halo = dimension * (1.3 + 0.05 * pulse);

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: SuccessBurstPainter(
                    rays: _rays.transform(intro.value),
                    ring: _ring.transform(intro.value),
                    ringColor: palette.success,
                    rayColors: [
                      palette.success,
                      palette.success,
                      palette.primary,
                      palette.primary,
                      palette.accent,
                      palette.accent,
                    ],
                  ),
                ),
              ),
              Transform.scale(
                scale: pop,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: halo,
                      height: halo,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.success.withValues(alpha: 0.12),
                      ),
                    ),
                    Container(
                      width: dimension,
                      height: dimension,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.success,
                        boxShadow: [
                          BoxShadow(
                            color: palette.success.withValues(alpha: 0.4),
                            blurRadius: 18.r,
                            offset: Offset(0, 6.h),
                          ),
                        ],
                      ),
                      child: CustomPaint(
                        painter: CheckMarkPainter(
                          progress: _draw.transform(intro.value),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
