import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/theme/app_palette.dart';

class SplashProgress extends StatelessWidget {
  const SplashProgress({super.key, required this.intro});

  final Animation<double> intro;

  static const Interval _fade = Interval(0.05, 0.2, curve: Curves.easeOut);
  static const Interval _fill = Interval(0.1, 1, curve: Curves.easeInOut);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: 48.h),
        child: AnimatedBuilder(
          animation: intro,
          builder: (context, _) {
            return Opacity(
              opacity: _fade.transform(intro.value),
              child: Container(
                width: 140.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: palette.track,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: _fill.transform(intro.value),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [palette.primary, palette.accent],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}