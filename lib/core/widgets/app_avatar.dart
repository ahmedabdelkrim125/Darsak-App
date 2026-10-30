import 'dart:io';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../theme/app_palette.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.size,
    this.path,
    this.borderWidth = 2,
  });

  final double size;
  final String? path;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final avatarPath = path;
    final fallback = Center(
      child: Icon(
        SolarIconsBold.user,
        size: size * 0.55,
        color: palette.primary,
      ),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            palette.primary.withValues(alpha: 0.35),
            palette.accent.withValues(alpha: 0.35),
          ],
        ),
        border: Border.all(color: palette.background, width: borderWidth),
      ),
      child: ClipOval(
        child: avatarPath == null
            ? fallback
            : Image.file(
                File(avatarPath),
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }
}
