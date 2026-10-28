import 'package:flutter/material.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import 'package:darsak_app/feat/auth/ui/widgets/auth_card_painter.dart';
import 'package:darsak_app/feat/auth/ui/widgets/auth_card_shape.dart';

import '../../../../core/helper/responsive_extension.dart';

class AuthCurvedCard extends StatelessWidget {
  const AuthCurvedCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final resolved = (padding ?? EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 18.h))
        .resolve(Directionality.of(context));

    return CustomPaint(
      painter: AuthCardPainter(
        fill: palette.surface,
        border: palette.track,
        shadow: palette.primary.withValues(alpha: 0.12),
      ),
      child: ClipPath(
        clipper: const AuthCardClipper(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minHeight = constraints.hasBoundedHeight
                ? (constraints.maxHeight - resolved.vertical)
                      .clamp(0.0, double.infinity)
                      .toDouble()
                : 0.0;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: resolved,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
