import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/const/app_assets.dart';
import '../../../../core/helper/responsive_extension.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key, required this.intro, required this.loop});

  final Animation<double> intro;
  final Animation<double> loop;

  static const Interval _entrance = Interval(
    0.15,
    0.6,
    curve: Curves.elasticOut,
  );
  static const Interval _turn = Interval(0.15, 0.55, curve: Curves.easeOutBack);
  static const Interval _fade = Interval(0.15, 0.3, curve: Curves.easeOut);
  static const Interval _shine = Interval(0.62, 0.9, curve: Curves.easeInOut);
  static const Interval _floatIn = Interval(0.5, 0.7);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([intro, loop]),
      builder: (context, child) {
        final t = intro.value;
        final scale = _entrance.transform(t);
        final angle = (1 - _turn.transform(t)) * -0.6;
        final opacity = _fade.transform(t).clamp(0.0, 1.0).toDouble();
        final shine = _shine.transform(t);
        final floatY = sin(loop.value * 2 * pi) * 7.h * _floatIn.transform(t);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.rotate(
              angle: angle,
              child: Transform.scale(
                scale: scale,
                child: ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                      stops: const [0.35, 0.5, 0.65],
                      transform: _SlideGradientTransform(shine),
                    ).createShader(bounds);
                  },
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      child: Image.asset(AppAssets.logo, width: 230.w, fit: BoxFit.contain),
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  const _SlideGradientTransform(this.percent);

  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (percent * 2 - 1), 0, 0);
  }
}
