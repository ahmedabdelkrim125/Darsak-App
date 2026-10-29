import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/theme/app_palette.dart';

class HomeBannerSparkle extends StatelessWidget {
  const HomeBannerSparkle({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return CustomPaint(
      size: Size(30.w, 22.h),
      painter: _SparklePainter(
        primary: palette.primary,
        accent: palette.accent,
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter({required this.primary, required this.accent});

  final Color primary;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final stroke = width * 0.1;

    final first = Paint()
      ..color = primary
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final second = Paint()
      ..color = accent
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(width * 0.12, height * 0.05),
      Offset(width * 0.28, height * 0.5),
      first,
    );
    canvas.drawLine(
      Offset(width * 0.48, 0),
      Offset(width * 0.52, height * 0.45),
      first,
    );
    canvas.drawLine(
      Offset(width * 0.68, height * 0.4),
      Offset(width * 0.95, height * 0.72),
      second,
    );
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) {
    return oldDelegate.primary != primary || oldDelegate.accent != accent;
  }
}
