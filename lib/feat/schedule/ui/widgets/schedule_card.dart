import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/theme/app_palette.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 14.h),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: palette.primary.withValues(alpha: 0.06)),
      ),
      child: child,
    );
  }
}
