import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../../core/const/app_assets.dart';
import '../../../../../core/helper/responsive_extension.dart';

class SuccessHero extends StatelessWidget {
  const SuccessHero({
    super.key,
    required this.intro,
    required this.loop,
    required this.aspectRatio,
  });

  final Animation<double> intro;
  final Animation<double> loop;
  final double aspectRatio;

  static const Interval _rise = Interval(0, 0.35, curve: Curves.elasticOut);
  static const Interval _fade = Interval(0, 0.15, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([intro, loop]),
      builder: (context, child) {
        final rise = _rise.transform(intro.value);
        final fade = _fade.transform(intro.value);
        final bob = sin(loop.value * 2 * pi) * 4.h;

        return Opacity(
          opacity: fade,
          child: Transform.translate(
            offset: Offset(0, (1 - rise) * 80.h + bob),
            child: Transform.scale(
              scale: 0.9 + 0.1 * rise,
              alignment: Alignment.bottomCenter,
              child: child,
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.asset(
          AppAssets.accountSuccess,
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
