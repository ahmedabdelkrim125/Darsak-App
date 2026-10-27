// import 'package:flutter/material.dart';
// import 'package:darsak_app/core/theme/app_palette.dart';
// import 'package:darsak_app/feat/onboarding/ui/widgets/onboarding_scroll.dart';

// import '../../../../core/helper/responsive_extension.dart';

// class OnboardingIndicator extends StatelessWidget {
//   const OnboardingIndicator({
//     super.key,
//     required this.count,
//     required this.scroll,
//     required this.intro,
//   });

//   final int count;
//   final OnboardingScroll scroll;
//   final Animation<double> intro;

//   static const Interval _appear = Interval(0.6, 1, curve: Curves.easeOut);

//   @override
//   Widget build(BuildContext context) {
//     final palette = context.palette;

//     return ListenableBuilder(
//       listenable: Listenable.merge([scroll.controller, intro]),
//       builder: (context, _) {
//         final page = scroll.page;

//         return Opacity(
//           opacity: _appear.transform(intro.value),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               for (var i = 0; i < count; i++)
//                 Padding(
//                   padding: EdgeInsetsDirectional.only(
//                     end: i == count - 1 ? 0 : 6.w,
//                   ),
//                   child: _ProgressBar(
//                     index: i,
//                     page: page,
//                     fillColor: palette.primary,
//                     trackColor: palette.track,
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _ProgressBar extends StatelessWidget {
//   const _ProgressBar({
//     required this.index,
//     required this.page,
//     required this.fillColor,
//     required this.trackColor,
//   });

//   final int index;
//   final double page;
//   final Color fillColor;
//   final Color trackColor;

//   @override
//   Widget build(BuildContext context) {
//     final barHeight = 8.h;
//     final collapsed = 14.w;
//     final expanded = 44.w;
//     final closeness = (1 - (page - index).abs()).clamp(0.0, 1.0).toDouble();
//     final fill = (page - index + 1).clamp(0.0, 1.0).toDouble();
//     final radius = BorderRadius.circular(barHeight);

//     return Container(
//       width: collapsed + (expanded - collapsed) * closeness,
//       height: barHeight,
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(color: trackColor, borderRadius: radius),
//       child: FractionallySizedBox(
//         alignment: AlignmentDirectional.centerStart,
//         widthFactor: fill,
//         child: DecoratedBox(
//           decoration: BoxDecoration(color: fillColor, borderRadius: radius),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:darsak_app/core/widgets/app_step_bar.dart';
import 'package:darsak_app/feat/onboarding/ui/widgets/onboarding_scroll.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.scroll,
    required this.intro,
  });

  final int count;
  final OnboardingScroll scroll;
  final Animation<double> intro;

  static const Interval _appear = Interval(0.6, 1, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([scroll.controller, intro]),
      builder: (context, _) {
        return Opacity(
          opacity: _appear.transform(intro.value),
          child: AppStepBar(count: count, value: scroll.page),
        );
      },
    );
  }
}
