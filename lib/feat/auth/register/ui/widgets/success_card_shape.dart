import 'package:flutter/material.dart';
import '../../../../../core/helper/responsive_extension.dart';

class SuccessCardShape {
  SuccessCardShape._();

  static Path path(Size size) {
    final w = size.width;
    final h = size.height;
    final shoulder = 28.h;
    final leftDrop = 64.h;
    final rightDrop = 56.h;
    final corner = 36.r;

    return Path()
      ..moveTo(0, leftDrop)
      ..cubicTo(
        0,
        shoulder + (leftDrop - shoulder) * 0.4,
        w * 0.06,
        shoulder,
        w * 0.20,
        shoulder,
      )
      ..cubicTo(w * 0.30, shoulder, w * 0.33, 0, w * 0.45, 0)
      ..cubicTo(w * 0.57, 0, w * 0.62, shoulder, w * 0.76, shoulder)
      ..cubicTo(
        w * 0.90,
        shoulder,
        w,
        shoulder + (rightDrop - shoulder) * 0.35,
        w,
        rightDrop,
      )
      ..lineTo(w, h - corner)
      ..arcToPoint(Offset(w - corner, h), radius: Radius.circular(corner))
      ..lineTo(corner, h)
      ..arcToPoint(Offset(0, h - corner), radius: Radius.circular(corner))
      ..close();
  }
}
