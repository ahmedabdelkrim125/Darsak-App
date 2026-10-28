import 'package:flutter/material.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import 'onboarding_scroll.dart';
import '../../../../core/helper/responsive_extension.dart';

class OnboardingTexts extends StatelessWidget {
  const OnboardingTexts({
    super.key,
    required this.index,
    required this.title,
    required this.description,
    required this.scroll,
    required this.intro,
  });

  final int index;
  final String title;
  final String description;
  final OnboardingScroll scroll;
  final Animation<double> intro;

  static const Interval _descriptionRise = Interval(
    0.6,
    1,
    curve: Curves.easeOut,
  );

  @override
  Widget build(BuildContext context) {
    const sign = OnboardingScroll.flow;
    final width = context.screenWidth;
    final palette = context.palette;
    final words = title.split(' ');
    final titleStyle = AppFonts.displayLarge.copyWith(
      color: palette.textPrimary,
    );
    final descriptionStyle = AppFonts.bodyLarge.copyWith(
      color: palette.textSecondary,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ListenableBuilder(
        listenable: Listenable.merge([scroll.controller, intro]),
        builder: (context, _) {
          final delta = scroll.delta(index);
          final away = delta.abs().clamp(0.0, 1.0).toDouble();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10.w,
                  children: [
                    for (var i = 0; i < words.length; i++)
                      _buildWord(
                        words[i],
                        i,
                        delta,
                        away,
                        sign,
                        width,
                        titleStyle,
                      ),
                  ],
                ),
              ),
              verticalSpace(height: 14),
              _buildDescription(delta, away, sign, width, descriptionStyle),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWord(
    String word,
    int i,
    double delta,
    double away,
    double sign,
    double width,
    TextStyle style,
  ) {
    final begin = (0.35 + i * 0.08).clamp(0.0, 0.7).toDouble();
    final rise = Interval(
      begin,
      begin + 0.3,
      curve: Curves.easeOutCubic,
    ).transform(intro.value);
    final scrollFade = (1 - away * (1 + i * 0.4)).clamp(0.0, 1.0).toDouble();
    final dx = sign * delta * width * (0.5 + i * 0.25);
    final dy = (1 - rise) * 26.h + away * 20.h;

    return Opacity(
      opacity: scrollFade * rise,
      child: Transform.translate(
        offset: Offset(dx, dy),
        child: Text(word, style: style),
      ),
    );
  }

  Widget _buildDescription(
    double delta,
    double away,
    double sign,
    double width,
    TextStyle style,
  ) {
    final rise = _descriptionRise.transform(intro.value);
    final scrollFade = (1 - away * 1.3).clamp(0.0, 1.0).toDouble();

    return Opacity(
      opacity: scrollFade * rise,
      child: Transform.translate(
        offset: Offset(sign * delta * width * 0.2, (1 - rise) * 18.h),
        child: Text(description, textAlign: TextAlign.center, style: style),
      ),
    );
  }
}
