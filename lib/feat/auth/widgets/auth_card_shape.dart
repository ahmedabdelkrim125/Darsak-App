import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';

class AuthCardShape {
  AuthCardShape._();

  static Path path(Size size) {
    final w = size.width;
    final h = size.height;
    final shoulder = 26.h;
    final leftDrop = 66.h;
    final rightDrop = 56.h;
    final corner = 40.r;

    return Path()
      ..moveTo(0, leftDrop)
      ..cubicTo(
        0,
        shoulder + (leftDrop - shoulder) * 0.35,
        w * 0.07,
        shoulder,
        w * 0.28,
        shoulder,
      )
      ..cubicTo(w * 0.60, shoulder, w * 0.66, 0, w * 0.82, 0)
      ..cubicTo(w * 0.94, 0, w, rightDrop * 0.35, w, rightDrop)
      ..lineTo(w, h - corner)
      ..arcToPoint(Offset(w - corner, h), radius: Radius.circular(corner))
      ..lineTo(corner, h)
      ..arcToPoint(Offset(0, h - corner), radius: Radius.circular(corner))
      ..close();
  }
}

class AuthCardClipper extends CustomClipper<Path> {
  const AuthCardClipper();

  @override
  Path getClip(Size size) => AuthCardShape.path(size);

  @override
  bool shouldReclip(covariant AuthCardClipper oldClipper) => false;
}
