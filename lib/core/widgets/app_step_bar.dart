import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../helper/responsive_extension.dart';

class AppStepBar extends StatelessWidget {
  const AppStepBar({
    super.key,
    required this.count,
    required this.value,
    this.height,
    this.inactiveWidth,
    this.activeWidth,
    this.spacing,
    this.activeColor,
    this.inactiveColor,
  });

  final int count;
  final double value;
  final double? height;
  final double? inactiveWidth;
  final double? activeWidth;
  final double? spacing;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final gap = spacing ?? 6.w;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          Padding(
            padding: EdgeInsetsDirectional.only(end: i == count - 1 ? 0 : gap),
            child: _StepSegment(
              index: i,
              value: value,
              height: height ?? 8.h,
              collapsed: inactiveWidth ?? 14.w,
              expanded: activeWidth ?? 44.w,
              fillColor: activeColor ?? palette.primary,
              trackColor: inactiveColor ?? palette.track,
            ),
          ),
      ],
    );
  }
}

class _StepSegment extends StatelessWidget {
  const _StepSegment({
    required this.index,
    required this.value,
    required this.height,
    required this.collapsed,
    required this.expanded,
    required this.fillColor,
    required this.trackColor,
  });

  final int index;
  final double value;
  final double height;
  final double collapsed;
  final double expanded;
  final Color fillColor;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final closeness = (1 - (value - index).abs()).clamp(0.0, 1.0).toDouble();
    final fill = (value - index + 1).clamp(0.0, 1.0).toDouble();
    final radius = BorderRadius.circular(height);

    return Container(
      width: collapsed + (expanded - collapsed) * closeness,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: trackColor, borderRadius: radius),
      child: FractionallySizedBox(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: fill,
        child: DecoratedBox(
          decoration: BoxDecoration(color: fillColor, borderRadius: radius),
        ),
      ),
    );
  }
}
