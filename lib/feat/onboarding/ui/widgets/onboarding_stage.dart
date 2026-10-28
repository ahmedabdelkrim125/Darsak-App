import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import 'onboarding_reveal.dart';
import 'onboarding_scroll.dart';
import 'onboarding_sparkles.dart';
import '../../../../core/helper/responsive_extension.dart';

class OnboardingStage extends StatelessWidget {
  const OnboardingStage({
    super.key,
    required this.images,
    required this.scroll,
    required this.intro,
    required this.loop,
  });

  final List<String> images;
  final OnboardingScroll scroll;
  final Animation<double> intro;
  final Animation<double> loop;

  static const Interval _enter = Interval(0, 0.6, curve: Curves.elasticOut);
  static const Interval _fade = Interval(0, 0.25, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    const flow = OnboardingScroll.flow;
    final palette = context.palette;
    final last = images.length - 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListenableBuilder(
        listenable: Listenable.merge([scroll.controller, intro, loop]),
        builder: (context, _) {
          final page = scroll.page.clamp(0.0, last.toDouble()).toDouble();
          final from = page.floor();
          final to = min(from + 1, last);
          final t = page - from;
          final reveal = Curves.easeInOutCubic.transform(t);

          final enter = _enter.transform(intro.value);
          final fade = _fade.transform(intro.value);
          final wave = loop.value * 2 * pi;
          final float = sin(wave) * 8.h;
          final wobble = sin(wave * 2) * 0.012;
          final breath = 1 + sin(wave * 3) * 0.008;
          final introScale = 0.55 + 0.45 * enter;
          final introTurn = (1 - enter) * -0.25;

          return Opacity(
            opacity: fade,
            child: Transform.translate(
              offset: Offset(0, float),
              child: Transform.rotate(
                angle: wobble + introTurn,
                child: Transform.scale(
                  scale: introScale * breath,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _StageImage(
                        image: images[from],
                        scale: 1 - 0.25 * reveal,
                        angle: -0.12 * reveal * flow,
                        opacity: (1 - reveal * 1.4).clamp(0.0, 1.0).toDouble(),
                        offset: Offset(-flow * reveal * 40.w, 12.h * reveal),
                      ),
                      if (t > 0 && to != from)
                        ClipPath(
                          clipper: RevealClipper(progress: reveal),
                          child: _StageImage(
                            image: images[to],
                            scale: 1.3 - 0.3 * reveal,
                            angle: 0.18 * (1 - reveal) * flow,
                            opacity: 1,
                            offset: Offset.zero,
                          ),
                        ),
                      IgnorePointer(
                        child: ClipRect(
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: RevealRingPainter(
                              progress: t > 0 ? reveal : 0,
                              primary: palette.primary,
                              accent: palette.accent,
                            ),
                          ),
                        ),
                      ),
                      OnboardingSparkles(
                        phase: loop.value,
                        burst: sin(pi * t),
                        opacity: fade,
                        colors: [
                          palette.primary,
                          palette.accent,
                          palette.textSecondary,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StageImage extends StatelessWidget {
  const _StageImage({
    required this.image,
    required this.scale,
    required this.angle,
    required this.opacity,
    required this.offset,
  });

  final String image;
  final double scale;
  final double angle;
  final double opacity;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: angle,
          child: Transform.scale(
            scale: scale,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              gaplessPlayback: true,
            ),
          ),
        ),
      ),
    );
  }
}
