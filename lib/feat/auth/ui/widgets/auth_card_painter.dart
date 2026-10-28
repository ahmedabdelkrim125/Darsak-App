import 'package:flutter/material.dart';
import 'auth_card_shape.dart';

import '../../../../core/helper/responsive_extension.dart';

typedef AuthCardPathBuilder = Path Function(Size size);

class AuthCardPainter extends CustomPainter {
  const AuthCardPainter({
    required this.fill,
    required this.border,
    required this.shadow,
    this.pathBuilder = AuthCardShape.path,
  });

  final Color fill;
  final Color border;
  final Color shadow;
  final AuthCardPathBuilder pathBuilder;

  @override
  void paint(Canvas canvas, Size size) {
    final path = pathBuilder(size);

    canvas.drawPath(
      path.shift(Offset(0, 8.h)),
      Paint()
        ..color = shadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = border,
    );
  }

  @override
  bool shouldRepaint(covariant AuthCardPainter oldDelegate) {
    return oldDelegate.fill != fill ||
        oldDelegate.border != border ||
        oldDelegate.shadow != shadow ||
        oldDelegate.pathBuilder != pathBuilder;
  }
}
